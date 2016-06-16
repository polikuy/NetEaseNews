//
//  ManagerLogin.m
//  毕业设计
//
//  Created by 李宇佳 on 16/6/11.
//  Copyright © 2016年 lyj. All rights reserved.
//

#import "ManagerLogin.h"
#import "AFNetworking.h"
#import "AccountEntity.h"
@interface ManagerLogin ()
@property (strong,nonatomic) AFHTTPSessionManager * afManager;
@property (strong, nonatomic)  AccountEntity *accoutEntity;
@end

@implementation ManagerLogin
+ (instancetype)shareManager
{
    static ManagerLogin * m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[ManagerLogin alloc]init];
    });
    return m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.afManager = [[AFHTTPSessionManager alloc]init];
        self.afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}



//获取验证码的方法
- (void)requestAuthCodeWithTel:(NSString *)tel andType:(NSString *)type completionHandler:(ErrorDescriptionBlock)handler
{
    //判断手机号位数
    if (tel.length == 0) {
        handler(NO,@"没有填写手机号");
    }
    //判断手机号是否合法的正则匹配
    NSString * regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:tel];
    
    if(!isMatch){
        //手机号不存在或是不合法
        handler(NO,@"请输入正确的手机号");
    }else{
        //手机号位数合法,发送验证码
        NSDictionary * dic = @{@"tel":tel,@"type":type};
        [self.afManager GET:sendCodeURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError * error = nil;
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"获取验证码dic = %@",dic);
            if (error) {
                NSLog(@"解析数据失败:%@",error.localizedDescription);
                handler(NO,@"数据解析失败");
            }else if ([dic[@"data"][0][@"result"] isEqualToNumber:@0]) {
                NSLog(@"验证码发送成功");
                handler(YES,@"验证码发送成功");
            }else if([dic[@"data"][0][@"result"] isEqualToNumber:@1]){
                NSLog(@"验证码发送失败");
                handler(NO,@"验证码发送失败");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"验证码发送请求失败");
            handler(NO,@"验证码发送请求失败");
        }];
    }
}

//用户注册的方法
- (void)registerAccountWithTel:(NSString *)tel andCode:(NSString *)code andPassword1:(NSString *)password1 andPassword2:(NSString *)password2 completionHandler:(ErrorDescriptionBlock)handler
{
    //初始化loginStateType
    //"1"未登录状态
    NSUserDefaults * loginState = [NSUserDefaults standardUserDefaults];
    [loginState setObject:@"1" forKey:@"loginStateType"];
    
    //判断手机号位数
    if (tel.length == 0) {
        handler(NO,@"没有填写手机号");
    }
    //判断手机号是否合法的正则匹配
    NSString * regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:tel];
    
    if(!isMatch){
        //手机号不存在或是不合法
        handler(NO,@"请输入正确的手机号");
    }else if(!(password1.length >= 6)){
        handler(NO,@"密码少于6位");
    }else if(![password1 isEqualToString:password2]){
        //密码不相同
        handler(NO,@"两次输入密码不一致");
    }else if(password1 != nil && password2 != nil){
        //注册
        NSDictionary * dic = @{@"tel":tel,@"code":code,@"password":password1};
        [self.afManager GET:registerURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError * error = nil;
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"注册dic = %@",dic);
            if (error) {
                NSLog(@"解析数据失败:%@",error.localizedDescription);
                handler(NO,@"数据解析失败");
            }else
            {
                if ([dic[@"data"][0][@"result"] isEqualToNumber:@0]) {
                    NSLog(@"注册成功");
                    handler(YES,@"注册成功");
                }else if([dic[@"data"][0][@"result"] isEqualToNumber:@1]){
                    NSLog(@"注册失败--已注册/验证码错误描述%@",dic[@"data"][0][@"error"]);
                    handler(NO,dic[@"data"][0][@"error"]);//失败原因
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"注册请求失败");
            handler(NO,@"注册请求失败");
        }];
    }
}

//修改密码的方法
- (void)changePasswordWithTel:(NSString *)tel andCode:(NSString *)code andNewPassword1:(NSString *)newPassword1 andNewPassword2:(NSString *)newPassword2 completionHandler:(ErrorDescriptionBlock)handler
{
    //判断手机号位数
    //判断手机号位数
    if (tel.length == 0) {
        handler(NO,@"没有填写手机号");
    }
    //判断手机号是否合法的正则匹配
    NSString * regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:tel];
    
    if(!isMatch){
        //手机号不存在或是不合法
        handler(NO,@"请输入正确的手机号");
    }else if(!(newPassword1.length >= 6)){
        handler(NO,@"密码少于6位");
    }else if(![newPassword1 isEqualToString:newPassword2]){
        //密码不相同
        handler(NO,@"两次输入密码不一致");
    }else if(newPassword1 != nil && newPassword2 != nil){
        //修改密码
        NSDictionary * dic = @{@"tel":tel,@"code":code,@"newPassword":newPassword1};
        [self.afManager GET:resetPasswordURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError * error = nil;
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"修改密码dic = %@",dic);
            if (error) {
                NSLog(@"解析数据失败:%@",error.localizedDescription);
                handler(NO,@"数据解析失败");
            }else
            {
                if ([dic[@"data"][0][@"result"] isEqualToNumber:@0]) {
                    NSLog(@"修改成功");
                    handler(YES,@"修改成功");
                }else if ([dic[@"data"][0][@"result"] isEqualToNumber:@1]){
                    NSLog(@"修改失败--账号/验证码错误描述？");
                    handler(NO,dic[@"data"][0][@"error"]);//失败原因
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            handler(NO,@"修改请求失败");
            NSLog(@"修改请求失败");
        }];
    }
}

//用户登录的方法
- (void)loginWithTel:(NSString *)tel andPassword:(NSString *)password completionHandler:(LoginDescriptionBlock)handler
{
    //初始化数组
    //    self.users_Arr = [NSMutableArray arrayWithCapacity:10];
    self.accoutEntity = [[AccountEntity alloc]init];
    NSDictionary * dic = @{@"tel":tel,@"password":password};
    [self.afManager GET:loginURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError * error = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"登录dic = %@",dic);
        
        if (error) {
            NSLog(@"解析数据失败:%@",error.localizedDescription);
            handler(NO,nil,@"数据解析失败");
        }else if([tel isEqualToString:@""] || [password isEqualToString:@""]){
            handler(NO,nil,@"用户名或密码为空");
            NSLog(@"用户名或密码为空");
        }else if([dic[@"data"][0][@"result"] isEqualToNumber:@0]){
            //登录成功
            
            //将账户信息存入实体
            self.accoutEntity.userID = dic[@"data"][0][@"userId"];
            self.accoutEntity.token = dic[@"data"][0][@"token"];
            self.accoutEntity.matchToken = dic[@"data"][0][@"matchToken"];
            
            NSUserDefaults * matchstate = [NSUserDefaults standardUserDefaults];
            [matchstate setObject:dic[@"data"][0][@"matchStatus"] forKey:@"matchStatus"];
            
            //            [self.users_Arr addObject:self.accoutEntity];
            //个人设置已设置
            if ([dic[@"data"][0][@"infoStatus"] isEqualToString:@"0"]) {
                
                //并已匹配
                if ([dic[@"data"][0][@"matchStatus"] isEqualToString:@"0"]) {
                    //登录成功并被通知对方同意匹配，进入匹配界面
                    
                    NSUserDefaults * loginStateType = [NSUserDefaults standardUserDefaults];
                    //"0"已登录状态 "1"未登录
                    NSString * login_State = [loginStateType objectForKey:@"loginStateType"];
                    if ([login_State isEqualToString:@"1"]) {
                        handler(YES,@"MatchViewController",nil);
                        NSLog(@"登录成功跳转到匹配界面");
                    }else if (![login_State isEqualToString:@"1"]) {
                        //登录成功直接跳转到主页
                        //"0"已登录状态
                        NSUserDefaults * loginState = [NSUserDefaults standardUserDefaults];
                        [loginState setObject:@"0" forKey:@"loginStateType"];
                        
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        //登陆成功后把用户名和密码存储到UserDefault
                        [userDefaults setObject:tel forKey:@"tel"];
                        [userDefaults setObject:password forKey:@"password"];
                        
                        handler(YES,@"MainViewController",nil);
                        NSLog(@"登录成功直接跳转到主页");
                    }
                }else if([dic[@"data"][0][@"matchStatus"] isEqualToString:@"1"]){
                    //未匹配（也可能是解除关系了），登录成功跳转到匹配界面
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    //登陆成功后把用户名和密码存储到UserDefault
                    [userDefaults setObject:tel forKey:@"tel"];
                    [userDefaults setObject:password forKey:@"password"];
                    handler(YES,@"MatchViewController",nil);
                    NSLog(@"登录成功跳转到匹配界面");
                }
            }else if ([dic[@"data"][0][@"infoStatus"] isEqualToString:@"1"]){
                //个人设置还未设置,跳转到初始设置界面
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //登陆成功后把用户名和密码存储到UserDefault
                [userDefaults setObject:tel forKey:@"tel"];
                [userDefaults setObject:password forKey:@"password"];
                handler(YES,@"InitSettingViewController",nil);
            }
        }else{
            NSString * error = dic[@"data"][0][@"error"];
            NSLog(@"登录失败--原因?%@",error);
            handler(NO,nil,error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
}

@end
