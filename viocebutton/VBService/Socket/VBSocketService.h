//
//  VBSocketService.h
//  viocebutton
//
//  Created by Seth Chen on 17/1/11.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^clientData)(NSData * data);

/**
 *   Socket服务器
 */
@interface VBSocketService : NSObject

@property (nonatomic, copy) NSString *socketIP;         // 服务器IP
@property (nonatomic, copy) NSString *socketPort;       // 服务器端口


@property (nonatomic, copy) clientData clientData;

+ (instancetype)shareInstance ;

- (void)startSocketServer ;
- (NSString *)getIpAddresses ;
@end
