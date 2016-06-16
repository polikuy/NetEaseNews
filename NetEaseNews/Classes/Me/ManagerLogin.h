//
//  ManagerLogin.h
//  毕业设计
//
//  Created by 李宇佳 on 16/6/11.
//  Copyright © 2016年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface ManagerLogin : NSObject
//单例manager
+ (instancetype)shareManager;

//方法返回错误描述
typedef void(^ErrorDescriptionBlock)(BOOL success,NSString * description);

//登录方法返回参数
typedef void(^LoginDescriptionBlock)(BOOL success,NSString * nextVCStoryboardID,NSString * description);

//获取验证码的方法
- (void)requestAuthCodeWithTel:(NSString *)tel
                       andType:(NSString *)type
             completionHandler:(ErrorDescriptionBlock)handler;

//用户注册的方法
- (void)registerAccountWithTel:(NSString *)tel
                       andCode:(NSString *)code
                  andPassword1:(NSString *)password1
                  andPassword2:(NSString *)password2
             completionHandler:(ErrorDescriptionBlock)handler;

//修改密码的方法
- (void)changePasswordWithTel:(NSString *)tel
                      andCode:(NSString *)code
              andNewPassword1:(NSString *)newPassword1
              andNewPassword2:(NSString *)newPassword2
            completionHandler:(ErrorDescriptionBlock)handler;

//用户登录的方法
- (void)loginWithTel:(NSString *)tel
         andPassword:(NSString *)password
   completionHandler:(LoginDescriptionBlock)handler;


@end
