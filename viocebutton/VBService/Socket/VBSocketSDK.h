//
//  VBSocketSDK.h
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"


@interface VBSocketSDK : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket * socket;


+ (instancetype)shareInstance;

- (void)disConnect ;

///< Host port 连接
- (BOOL)socketConnectToHost:(NSString *)host port:(uint16_t)port;

///< Host port 断开上次的 重新连接
- (BOOL)socketReconnectToHost:(NSString *)host port:(uint16_t)port;

///< Url 连接
- (BOOL)socketConnectToUrl:(NSString *)url withTimeOut:(NSTimeInterval)tiemOut;
///< Url 断开上次的 重新连接
- (BOOL)socketReconnectToUrl:(NSString *)url withTimeOut:(NSTimeInterval)tiemOut;


///< 写数据入口

- (void)writeData:(NSData *)data
      withTimeout:(NSTimeInterval)timeout
              tag:(long)tag
          result:(void(^)(NSData *data, long tag, NSError*error))result ;



@end
