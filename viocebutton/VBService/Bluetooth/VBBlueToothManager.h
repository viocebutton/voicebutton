//
//  VBBlueToothManager.h
//
//  Created by David on 16/5/5.
//  Copyright © 2016年 detu. All rights reserved.
//

#define takePhotoCMD     @"0500"
#define startRecordCMD   @"060101"
#define stopRecordCMD    @"060100"
#define setMode_photoCMD @"040101"
#define setMode_videoCMD @"040100"
#define setH_Resolution @"080257604320"
#define setL_Resolution @"080238402160"

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>



@protocol BTDartboardDelegate
@optional
- (void) didReceiveData:(NSString *) string score:(NSString *)score;
- (void) didReadBatteryLevel:(NSString *) battery;
- (void) didDisConnect;
@end
@interface VBBlueToothManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, assign) id <BTDartboardDelegate> delegate;
@property (strong, nonatomic) CBCentralManager *manager;
@property (strong, nonatomic) CBPeripheral *peripheral;

@property CBService *f4Service;
@property CBCharacteristic *boardValueCharacteristic;
@property CBCharacteristic *boardStateCharacteristic;
@property CBCharacteristic *characteristic;

@property CBService *batteryService;
@property CBCharacteristic *batteryLevelCharacteristic;
@property (nonatomic, strong) NSMutableArray *BLEArray;
@property (nonatomic, strong) NSMutableArray *RSSIArray;
@property (nonatomic, copy) void (^updateBLEArray)(NSArray *array, NSArray *RSSIArray);
@property (nonatomic, copy) void(^didConnect)();
@property (nonatomic, copy) void(^success)(NSError *error);
#pragma mark - Methods for controlling the joofunn Dartboard
-(void) setup;
-(int) findPeripherals;
-(void) writeString:(NSData *) data;
- (void)connectPeripheralF4:(CBPeripheral *)F4;
- (void)sendCMD:(NSString *)cmd;
@end
