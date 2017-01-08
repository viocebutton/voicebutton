//
//  VBScoketManager.h
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VBSocketSDK.h"

@interface VBScoketManager : NSObject

@property (nonatomic, strong) VBSocketSDK *ITPSocket;

+ (instancetype)shareInstance;

- (BOOL)startConnect;

- (void)disConnect;

//  申请注册
- (void)registerAuthWith:(NSString *)nickName
             withTimeout:(NSTimeInterval)timeout
                     tag:(long)tag
                 result:(void(^)(NSData *data, long tag, NSError*error))result;
///< 注册
- (void)registerWith:(NSString *)emailName
            password:(NSString *)password
            authCode:(NSString *)authCode
            nickName:(NSString *)nickName
               phone:(NSString *)phone
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             result:(void(^)(NSData *data, long tag, NSError*error))result;
// 登录
- (void)loginWith:(NSString *)nickName
         password:(NSString *)password
      withTimeout:(NSTimeInterval)timeout
              tag:(long)tag
          result:(void(^)(NSData *data, long tag, NSError*error))result;


// 设置亲情号码
- (void)phbWithEmail:(NSString *)email
               phone:(NSString *)phone
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             result:(void(^)(NSData *data, long tag, NSError*error))result;

// 获取联系人
- (void)lxrWithEmail:(NSString *)email
//               bagId:(NSString *)bagId
         withTimeout:(NSTimeInterval)timeout
                 tag:(long)tag
             result:(void(^)(NSData *data, long tag, NSError*error))result;


/*!
 * 绑定箱子
 */
- (void)bingWithEmail:(NSString *)email
                bagId:(NSString *)bagId
               bagNum:(NSString *)bagNum
              bagName:(NSString *)bagName
          withTimeout:(NSTimeInterval)timeout
                  tag:(long)tag
              result:(void(^)(NSData *data, long tag, NSError*error))result;

/*!
 * 箱子列表
 */
- (void)bagListWithTimeout:(NSTimeInterval)timeout
                       tag:(long)tag
                   result:(void(^)(NSData *data, long tag, NSError*error))result;


// 实时查询
- (void)crWithEmail:(NSString *)email
              bagId:(NSString *)bagId
        withTimeout:(NSTimeInterval)timeout
                tag:(long)tag
            result:(void(^)(NSData *data, long tag, NSError*error))result;


// 删除绑定箱子
- (void)deleteBagWithEmail:(NSString *)email
                     bagId:(NSString *)bagId
               withTimeout:(NSTimeInterval)timeout
                       tag:(long)tag
                   result:(void(^)(NSData *data, long tag, NSError*error))result ;
// 删除联系人
- (void)deleteContactWithEmail:(NSString *)email
                         phone:(NSString *)phone
                   withTimeout:(NSTimeInterval)timeout
                           tag:(long)tag
                      result:(void(^)(NSData *data, long tag, NSError*error))result ;

// 提交安全栏
- (void)setSafeRegion:(NSString *)email
                bagId:(NSString *)bagId
            longitude:(NSString *)longitude     //经度
             latitude:(NSString *)latitude      //纬度
               radius:(NSString *)radius        //半径
          withTimeout:(NSTimeInterval)timeout
                  tag:(long)tag
              result:(void(^)(NSData *data, long tag, NSError*error))result ;


//邮箱号,原密码,新密码,新电话号码,新昵称
// 修改用户信息
- (void)modifyUserInformationWithEmail:(NSString *)email
                           oldPassword:(NSString *)oldPassword
                           newPassword:(NSString *)newPassword
                                 phone:(NSString *)phone                //电话
                              nickName:(NSString *)nickName             //昵称
                           withTimeout:(NSTimeInterval)timeout
                                   tag:(long)tag
                               result:(void(^)(NSData *data, long tag, NSError*error))result;


// 获取箱子定位历史信息
- (void)getHistoryRecordWithEmail:(NSString *)email
                            bagId:(NSString *)bagId
                        startDate:(NSString *)startDate           //开始时间
                          endDate:(NSString *)endDate             //结束时间
                      withTimeout:(NSTimeInterval)timeout
                              tag:(long)tag
                         result:(void(^)(NSData *data, long tag, NSError*error))result ;
// 箱子称重开锁
- (void)setLockAndWeightWithEmail:(NSString *)email
                            bagId:(NSString *)bagId
                         isWeight:(BOOL )isWeight
                          isUlock:(BOOL )isUlock
                      withTimeout:(NSTimeInterval)timeout
                              tag:(long)tag
                          result:(void(^)(NSData *data, long tag, NSError*error))result ;
@end
