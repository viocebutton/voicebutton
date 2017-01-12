//
//  VBBlueToothManager.m
//
//  Created by David on 16/5/5.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "VBBlueToothManager.h"

@implementation VBBlueToothManager

+ (CBUUID *) ServiceUUID
{
    return [CBUUID UUIDWithString:@"FFA0"];
}

+ (CBUUID *) ValueCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"FFA1"];
}

+ (CBUUID *) StateCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"FFA2"];
}

+ (instancetype)shareInstance {

    static VBBlueToothManager *sigle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sigle = [VBBlueToothManager new];
    });
    return sigle;
}

-(VBBlueToothManager *) start
{
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    return self;
}


//搜索蓝牙 ..
- (void)scan
{
    if (TARGET_OS_SIMULATOR) {
        NSLog(@"此设备不支持蓝牙");
        return;
    }
    
    [self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
}


//写入data
-(void) writeData:(NSData *)data res:(void(^)(NSData *data))res
{
    self.blueToothRes = res;
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark - CBCentralManager Delegates
// 蓝牙开关发生改变
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //TODO: to handle the state updates
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"没有打开蓝牙");
            break;
        default:
            [self scan];
            break;
    }
}

/*
 * 扫描到了一个蓝牙设备peripheral
 */
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Did discover peripheral %@", peripheral.name);

    if ([peripheral.name isEqualToString:@"hum3C"]) {
        self.peripheral = peripheral;
       [self.manager connectPeripheral:self.peripheral options:nil];
    }
}



/*
 * 成功连接蓝牙设备peripheral
 */
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect peripheral %@", peripheral.name);
    [self.manager stopScan];
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    //连接成功的回调
    [self.peripheral discoverServices:@[self.class.ServiceUUID]];
    if (self.connectRes) {
        self.connectRes(YES);
    }
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    self.peripheral = nil;
    if (self.connectRes) {
        self.connectRes(NO);
    }
}


#pragma mark - CBPeripheral delegates
/*
 *从peripheral成功读取到services
 */
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering services: %@", error);
        return;
    }
    
    
    for (CBService *s in [peripheral services])
    {
        if ([s.UUID isEqual:self.class.ServiceUUID])
        {
            NSLog(@"Found  service");
            self.Service = s;
            [self.peripheral discoverCharacteristics:@[self.class.ValueCharacteristicUUID, self.class.StateCharacteristicUUID] forService:self.Service];
        }
    }
}

/*
 * 从peripheral的service成功读取到characteristics
 */
- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering characteristics: %@", error);
        return;
    }
    
    for (CBCharacteristic *c in [service characteristics])
    {
        NSLog(@"%@", [service characteristics]);
        self.characteristic = [service characteristics][0];
        
        if ([c.UUID isEqual:self.class.ValueCharacteristicUUID])
        {
            NSLog(@"Found Value characteristic");
            self.boardValueCharacteristic = c;
            const uint8_t *bytes = c.value.bytes;
            NSLog(@"%s", bytes);
            [self.peripheral readValueForCharacteristic:self.boardValueCharacteristic];
//            [self.peripheral setNotifyValue:YES forCharacteristic:self.boardValueCharacteristic];
        }
        else if ([c.UUID isEqual:self.class.StateCharacteristicUUID])
        {
            NSLog(@"Found State characteristic");
            const uint8_t *bytes = c.value.bytes;
            NSLog(@"%s", bytes);
            self.boardStateCharacteristic = c;
            [self.peripheral setNotifyValue:YES forCharacteristic:self.boardStateCharacteristic];
        }
       
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error

{
 
    if (error) {
        NSLog(@"写入错误%@", error);
    }
    NSLog(@"发送了数据");
    NSLog(@"%@", characteristic.value.bytes);
    
}

// 数据返回
- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error receiving notification for characteristic %@: %@", characteristic, error);
    }
    
    NSString * value = [NSString stringWithFormat:@"%@",characteristic.value];
    if (self.blueToothRes) {
        self.blueToothRes([value dataUsingEncoding:NSUTF8StringEncoding]);
    }
    NSLog(@"接受数据");
}


@end
