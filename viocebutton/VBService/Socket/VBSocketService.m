//
//  VBSocketService.m
//  viocebutton
//
//  Created by Seth Chen on 17/1/11.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "VBSocketService.h"
#import "GCDAsyncSocket.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

#define PORT   888666  // 监听的端口

@interface VBSocketService()<GCDAsyncSocketDelegate>

@property(strong,nonatomic)NSMutableArray *clientSocket;

@end

@implementation VBSocketService
{
    GCDAsyncSocket *_serverSocket;
}

+ (instancetype)shareInstance {
    static VBSocketService * sigle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sigle = [VBSocketService new];
    });
    return sigle;
}

-(instancetype)init{
    if (self = [super init]) {
        _clientSocket = [NSMutableArray array];
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return self;
}

//
-(void)startSocketServer {
    //打开监听端口
    NSError *err;
    [_serverSocket acceptOnPort:PORT error:&err];
    if (!err) {
        NSLog(@"服务开启成功");
    }else{
        NSLog(@"服务开启失败");
    }
}

#pragma mark 有客户端建立连接的时候调用
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    //sock为服务端的socket，服务端的socket只负责客户端的连接，不负责数据的读取。   newSocket为客户端的socket
    [self.clientSocket addObject:newSocket];
    [newSocket readDataWithTimeout:-1 tag:100];
}


#pragma mark 接收客户端传递过来的数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    // sock为客户端的socket
    NSLog(@"客户端的socket %p",sock);
    
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    receiverStr = [[receiverStr stringByReplacingOccurrencesOfString:@"\r" withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    // 外传数据
    if(self.clientData)self.clientData([receiverStr dataUsingEncoding:NSUTF8StringEncoding]);
    // 回应客户端
    [sock writeData:[@"OK" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    // quit指令
    if ([receiverStr isEqualToString:@"quit"]) {
        
        [sock disconnect];
        [self.clientSocket removeObject:sock];
    }
}

#pragma mark 服务器写数据给客户端
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [sock readDataWithTimeout:-1 tag:100];
}



//获取ip地址
- (NSString *)socketIP {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)socketPort {
    return [NSString stringWithFormat:@"%d", PORT];
}

@end
