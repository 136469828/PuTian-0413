//
//  UserInfo.h
//  PuTian
//
//  Created by guofeng on 15/9/17.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,strong) NSString *notificationName;

/** 是否已经登录 */
@property (nonatomic,assign) BOOL isLogin;
/** userid */
@property (nonatomic,assign) NSInteger userid;
/** 登录账号 */
@property (nonatomic,copy) NSString *loginId;
/** 密码 */
@property (nonatomic,copy) NSString *pwd;
/** 服务端加密密码 */
@property (nonatomic,copy) NSString *encryptPwd;
@property (nonatomic,readonly) NSString *encryptPwdFromUserDefaults;
/** 昵称 */
@property (nonatomic,copy) NSString *nickname;
/** 沃币 */
@property (nonatomic,assign) NSInteger wobi;
/** 头像url */
@property (nonatomic,copy) NSString *portraitUrl;
/** 头像本地存放路径 */
@property (nonatomic,copy) NSString *portraitPath;
/** 注册验证码 */
@property (nonatomic,copy) NSString *verifyCode;
/** 最后登录时间 */
@property (nonatomic,copy) NSDate *lastLoginDate;
/** 今天是否已经登录过 */
@property (nonatomic,readonly) BOOL isLoginToday;
/** 今天是否已签到 */
@property (nonatomic,assign) BOOL isSignIn;

/** 是否为浦田联通号 */
@property (nonatomic,assign) BOOL isUnion;

+(instancetype)sharedInstance;

/** 获取注册短信验证码(type:1) */
-(void)requestVerifyCodeForRegist;
/** 注册(type:2) */
-(void)regist;
/** 登录(type:3) */
-(void)login;
/** 获取用户详情(type:4) */
-(void)requestUserInfo;
/** 上传用户头像(type:5) */
-(void)uploadPortrait:(NSData *)image;
/** 修改用户信息(type:6) */
-(void)modifyUserInfoWithNickName:(NSString *)nickname;
/** 修改密码(type:7) */
-(void)modifyPassword:(NSString *)newPwd oldPassword:(NSString *)oldPwd;
/** 签到(type:8) */
-(void)signIn;
/** 获取忘记密码短信验证码(type:9) */
-(void)requestVerifyCodeForForgetPwd;
/** 重新设置密码(type:10) */
-(void)resetPassword:(NSString *)pwd mobile:(NSString *)mobile verifyCode:(NSString *)code;
/** 注销用户 */
-(void)logout;
/** 将用户信息保存至本地 */
-(void)saveUserInfo;
/** 判断用户是否为浦田联通号(type:11) */
-(void)requestVerifyCodeForUnionPwd:(NSString *)mobile;
@end
