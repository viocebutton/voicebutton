//
//  ViewController.m
//  viocebutton
//
//  Created by Seth on 17/1/6.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "ViewController.h"
#import "VBSocketService.h"
#import "VBBlueToothManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * test = [UIButton buttonWithType:UIButtonTypeCustom];
    [test setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    test.frame = (CGRect){0, 0, 100, 100};
    test.center = self.view.center;
    [test setTitle:@"Monitor" forState:UIControlStateNormal];
    [test addTarget:self action:@selector(monitor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:test];
    
    
    UIButton * testTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    [testTwo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    testTwo.frame = CGRectMake(test.frame.origin.x, CGRectGetMaxY(test.frame), 100, 100);
    [testTwo setTitle:@"IP" forState:UIControlStateNormal];
    [testTwo addTarget:self action:@selector(testTwo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testTwo];
    
    
    // socket 监听数据返回  在delegate开启
    __weak typeof(self) weakSelf = self;
    [VBSocketService shareInstance].clientData = ^(NSData * data){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [self performBlock:^{
            [strongSelf showAlertIndictorWithMessage:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withDelay:1];
        } afterDelay:0];
    };
    
    
    //蓝牙 开启
    [[VBBlueToothManager shareInstance] start].connectRes = ^(BOOL success){
    
        if (success) {
            [self performBlock:^{
                [self showAlertIndictorWithMessage:@"蓝牙链接成功" withDelay:2];
            } afterDelay:.01];
        }
    };
}

- (void)monitor:(UIButton *)sender {
    
    NSDictionary * data = @{@"SSID":@"xiaowanzi",@"password":@"LINXIAN123", @"server IP":[VBSocketService shareInstance].socketIP, @"port":[VBSocketService shareInstance].socketPort};
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    [[VBBlueToothManager shareInstance] writeData:jsonData res:^(NSData *data) {
        if (data) {
            NSLog(@"");
        }
    }];
}

- (void)testTwo:(UIButton *)sender {
    NSLog(@"%@",[VBSocketService shareInstance].socketIP);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
