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
    return [CBUUID UUIDWithString:@"FFF2"];
}


-(void) setup
{
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.BLEArray = [NSArray array].mutableCopy;
    self.RSSIArray = [NSArray array].mutableCopy;
}

// scan Peripheral...
-(int) findPeripherals
{
    NSLog(@"discovering BLE");
    if ([self.manager state] != CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth is not correctly initialized !\n");
        return -1;
    }
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    [self.manager scanForPeripheralsWithServices:nil options:dic];
    return 0;
}


//写入data
- (void) writeString:(NSData *) data
{
    [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}

//连接
- (void)connectPeripheralF4:(CBPeripheral *)F4 {
   
    [self.manager connectPeripheral:F4 options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    [self.manager stopScan];
}

#pragma mark - CBCentralManager Delegates
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //TODO: to handle the state updates
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Did discover peripheral %@", peripheral.name);

    if ([peripheral.name isEqualToString:@"DETU-F4 360Camera"]) {
       [self.BLEArray addObject:peripheral];
        [self.RSSIArray addObject:RSSI];
    }
    
//    Call(_updateBLEArray, self.BLEArray, self.RSSIArray);
//    
    
}




- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect peripheral %@", peripheral.name);
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    //连接成功的回调
//    Call(_didConnect);
    [self.peripheral discoverServices:@[self.class.ServiceUUID]];
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    self.peripheral = nil;
    [self.delegate didDisConnect];
}


#pragma mark - CBPeripheral delegates
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
            NSLog(@"Found F4 service");
            self.f4Service = s;
            
            [self.peripheral discoverCharacteristics:@[self.class.ValueCharacteristicUUID, self.class.StateCharacteristicUUID] forService:self.f4Service];
        }
    }
}

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
//            [self.peripheral readValueForCharacteristic:self.boardValueCharacteristic];
            [self.peripheral setNotifyValue:YES forCharacteristic:self.boardValueCharacteristic];
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

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    
    if (error)
    {
        NSLog(@"Error receiving notification for characteristic %@: %@", characteristic, error);
    }
    
//    Call(_success, error);
    NSLog(@"%@", [characteristic value].bytes);
    NSLog(@"%@", [characteristic service]);
    NSLog(@"接受数据");
    
 
}


- (void)sendCMD:(NSString *)cmd {
    
    NSString *cmdStr = [NSString stringWithFormat:@"55%@", cmd];
    NSString *hexString = cmd; //16进制字符串
    int leng = (int)cmd.length/2;
    int j=0;
    Byte bytes[leng];
    ///3ds key的Byte 数组， 128位
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    
    int c = CRC16_1(bytes, leng);
    cmdStr = [cmdStr stringByAppendingString:[self toHex:c length:leng]];
    int leng2 = (int)cmdStr.length/2;
    int k=0;
    Byte bytess[leng2];
    ///3ds key的Byte 数组， 128位
    for(int i=0;i<[cmdStr length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [cmdStr characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [cmdStr characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytess[k] = int_ch;  ///将转化后的数放入Byte数组里
        k++;
    }
    
    NSLog(@"%@", cmdStr);
    NSData *dataaa = [[NSData alloc] initWithBytes:bytess length:leng2];
    [self writeString:dataaa];
}

- (NSString *)toHex:(long long int)tmpid length:(int)length
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    while (str.length < length) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    return [NSString stringWithFormat:@"%@",str];
}

unsigned int CRC16_1(unsigned char *buf, unsigned int length){
    
    unsigned int i, j, c;
    
    unsigned int crc = 0xFFFF;
    for (i = 0; i<length; i++) {
        c = *(buf+i)&0x00FF;
        crc^=c;
        for (j = 0; j<8; j++) {
            if (crc&0x0001) {
                crc>>=1;
                crc^= 0xA001;
            }else {
                crc>>=1;
            }
        }
    }
    return (crc);
    
}

@end
