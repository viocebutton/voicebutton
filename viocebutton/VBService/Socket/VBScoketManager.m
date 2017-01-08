//
//  VBScoketManager.m
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "VBScoketManager.h"

@implementation VBScoketManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (VBSocketSDK *)ITPSocket {
    return [VBSocketSDK shareInstance];
}

+ (instancetype)shareInstance
{
    static VBScoketManager * _sigton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sigton) {
            _sigton = [[VBScoketManager alloc]init];
            [_sigton startConnect];
        }
    });
    [_sigton startConnect];
    sleep(0.2);
    return _sigton;
}

- (BOOL)startConnect { // www.jsscom.com
    BOOL abool = [self.ITPSocket socketConnectToHost:@"120.76.217.157" port:23000];
    return abool;
}

- (void)disConnect {
    
    [self.ITPSocket disConnect];
}

//  申请注册
- (void)registerAuthWith:(NSString *)nickName
             withTimeout:(NSTimeInterval)timeout
                     tag:(long)tag
                result:(void(^)(NSData *data, long tag, NSError*error))result
{
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[nickName] command:ITP_REGISTER_REQUEST];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_REGISTER_REQUEST_TAG result:result];
}


// 注册
- (void)registerWith:(NSString *)emailName
            password:(NSString *)password
            authCode:(NSString *)authCode
            nickName:(NSString *)nickName
               phone:(NSString *)phone
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             result:(void(^)(NSData *data, long tag, NSError*error))result
{
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[emailName, password, authCode, nickName, phone] command:ITP_REGISTER_CONFIM];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_REGISTER_CONFIM_TAG result:result];
}

// 登录
- (void)loginWith:(NSString *)nickName
            password:(NSString *)password
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             result:(void(^)(NSData *data, long tag, NSError*error))result
{
//    NSString *isChinese = @"zh_CN";
//    if (![ITPLanguageManager sharedInstance].isChinese) {
//        isChinese = @"en";
//    }
//    
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[nickName, password, isChinese] command:ITP_LOGIN];
//       
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_LOGIN_TAG result:result];
}

// 绑定箱子
- (void)bingWithEmail:(NSString *)email
              bagId:(NSString *)bagId
               bagNum:(NSString *)bagNum
              bagName:(NSString *)bagName
        withTimeout:(NSTimeInterval)timeout
                tag:(long)tag
            result:(void(^)(NSData *data, long tag, NSError*error))result {
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId, bagNum, bagName] command:ITP_BANGDING];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_BANGDING_TAG result:result];
}

// 箱子列表
- (void)bagListWithTimeout:(NSTimeInterval)timeout
                       tag:(long)tag
                  result:(void(^)(NSData *data, long tag, NSError*error))result {
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[[ITPUserManager ShareInstanceOne].userEmail] command:ITP_BAGLIST];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_BAGLIST_TAG result:result];
}


// 实时查询
- (void)crWithEmail:(NSString *)email
              bagId:(NSString *)bagId
        withTimeout:(NSTimeInterval)timeout
                tag:(long)tag
            result:(void(^)(NSData *data, long tag, NSError*error))result {
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId] command:ITP_CR];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_CR_TAG result:result];
}


// 设置亲情号码
- (void)phbWithEmail:(NSString *)email
               phone:(NSString *)phone
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             result:(void(^)(NSData *data, long tag, NSError*error))result {
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[[ITPUserManager ShareInstanceOne].userEmail/*@"355567207@qq.com"*/, email, phone] command:ITP_PHB];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_PHB_TAG result:result];
}

// 亲情号码监听
- (void)monitorWithEmail:(NSString *)email
                   bagId:(NSString *)bagId
                   phone:(NSString *)phone
             withTimeout:(NSTimeInterval)timeout
                     tag:(long)tag
                 result:(void(^)(NSData *data, long tag, NSError*error))result {
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId, phone] command:ITP_MONITOR];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_MONITOR_TAG result:result];
}

// 请求终端操作
- (void)actWithEmail:(NSString *)email
               bagId:(NSString *)bagId
            weighton:(NSString *)weighton
              lockon:(NSString *)lockon
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             result:(void(^)(NSData *data, long tag, NSError*error))result {
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId, weighton, lockon] command:ITP_ACT];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_ACT_TAG result:result];
    
}

// GPS
- (void)gpsWithEmail:(NSString *)email
               bagId:(NSString *)bagId
             onORoff:(NSString *)onORoff
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             result:(void(^)(NSData *data, long tag, NSError*error))result {
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId, onORoff] command:ITP_GPS];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_GPS_TAG result:result];
    
}

// 获取联系人
- (void)lxrWithEmail:(NSString *)email
//               bagId:(NSString *)bagId
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             result:(void(^)(NSData *data, long tag, NSError*error))result {
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email] command:ITP_LXR];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_LXR_TAG result:result];
}

// 删除绑定箱子
- (void)deleteBagWithEmail:(NSString *)email
                      bagId:(NSString *)bagId
              withTimeout:(NSTimeInterval)timeout
                      tag:(long)tag
                  result:(void(^)(NSData *data, long tag, NSError*error))result {
//    NSData * data = [[ITPDataCenter sharedInstance] paramData:@[email, bagId] command:ITP_DELETEBINDDEV];
//    
//    [self.ITPSocket writeData:data withTimeout:timeout tag:ITP_DELETEBINDDEV_TAG result:result];
    
}

@end
