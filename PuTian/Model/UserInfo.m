//
//  UserInfo.m
//  PuTian
//
//  Created by guofeng on 15/9/17.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "UserInfo.h"
#import "ASIHTTPRequest.h"
#import "PlatServiceDataParser.h"
#import "DateHelper.h"

@interface UserInfo()

@property (atomic,assign) BOOL isLoading1;
@property (atomic,assign) BOOL isLoading2;
@property (atomic,assign) BOOL isLoading3;
@property (atomic,assign) BOOL isLoading4;
@property (atomic,assign) BOOL isLoading5;
@property (atomic,assign) BOOL isLoading6;
@property (atomic,assign) BOOL isLoading7;
@property (atomic,assign) BOOL isLoading8;
@property (atomic,assign) BOOL isLoading9;
@property (atomic,assign) BOOL isLoading10;
@property (atomic,assign) BOOL isLoading11;

/** 修改密码 */
@property (nonatomic,copy) NSString *modifyPwd;

@end

@implementation UserInfo

+(instancetype)sharedInstance
{
    static UserInfo *gUserInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gUserInfo = [[UserInfo alloc] init];
        gUserInfo.notificationName=kNotificationNameUserInfo;
    });
    return gUserInfo;
}

-(id)init
{
    if(self=[super init])
    {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        self.isLogin=[userDefaults boolForKey:kUserDefaultsKeyIsLogin];
        self.userid=[userDefaults integerForKey:kUserDefaultsKeyUserID];
        self.loginId=[userDefaults stringForKey:kUserDefaultsKeyLoginId];
        self.nickname=[userDefaults stringForKey:kUserDefaultsKeyNickName];
        self.portraitUrl=[userDefaults stringForKey:kUserDefaultsKeyPortraitUrl];
        _portraitPath=[[NSString alloc] initWithFormat:@"%@/portrait.jpg",[Common mainDirectory]];
        self.lastLoginDate=[userDefaults objectForKey:kUserDefaultsKeyLastLoginDate];
        
        NSString *tmpstr=[userDefaults stringForKey:kUserDefaultsKeyPwd];
        if([tmpstr isNotNilOrEmptyString])
        {
            self.pwd=[tmpstr decodeBase64];
        }
        self.encryptPwd=[userDefaults stringForKey:kUserDefaultsKeyEncryptPwd];
    }
    return self;
}

-(BOOL)isLoginToday
{
    if(_lastLoginDate)
    {
        NSInteger day=[DateHelper getDayWithDate:_lastLoginDate];
        if(day==0)return YES;
    }
    return NO;
}
-(NSString *)encryptPwdFromUserDefaults
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyEncryptPwd];
}

/** 获取注册短信验证码(type:1) */
-(void)requestVerifyCodeForRegist
{
    if(!self.isLoading1)
    {
        self.isLoading1=YES;
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=getVerificationCode&mobile=%@&stype=%d",URL_Server,_loginId,1];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=1;
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 注册(type:2) */
-(void)regist
{
    if(!self.isLoading2)
    {
        self.isLoading2=YES;
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=register&username=%@&pwd=%@&code=%@",URL_Server,_loginId,_pwd,_verifyCode];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=2;
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 登录(type:3) */
-(void)login
{
    if(!self.isLoading3)
    {
        self.isLoading3=YES;
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=login&username=%@&pwd=%@",URL_Server,_loginId,_pwd];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=3;
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}

/** 获取用户详情(type:4) */
-(void)requestUserInfo
{
    if(!self.isLoading4)
    {
        self.isLoading4=YES;
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=userinfo&uid=%d",URL_Server,_userid];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=4;
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 上传用户头像(type:5) */
-(void)uploadPortrait:(NSData *)image
{
    if(!self.isLoading5 && image)
    {
        self.isLoading5=YES;
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=uploadpic&uid=%d",URL_Server,_userid];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        //NSDictionary *postData=[[NSDictionary alloc] initWithObjectsAndKeys:image, @"imagedata", nil];
        NSMutableData *postData=[[NSMutableData alloc] initWithData:image];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=5;
        _request.postBody=postData;
        [_request setRequestMethod:@"POST"];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 修改用户信息(type:6) */
-(void)modifyUserInfoWithNickName:(NSString *)nickname
{
    if(!self.isLoading6)
    {
        self.isLoading6=YES;
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=userupdate&uid=%d&nicename=%@",URL_Server,_userid,nickname];
        NSURL *url=[[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=6;
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 修改密码(type:7) */
-(void)modifyPassword:(NSString *)newPwd oldPassword:(NSString *)oldPwd
{
    if(!self.isLoading7)
    {
        self.isLoading7=YES;
        
        self.modifyPwd=newPwd;
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=pwdupdate&uid=%d&pwd=%@&newpwd=%@",URL_Server,_userid,oldPwd,newPwd];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=7;
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 签到(type:8) */
-(void)signIn
{
    if(!self.isLoading8)
    {
        self.isLoading8=YES;
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=usersignin&uid=%d",URL_Server,_userid];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=8;
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 获取忘记密码短信验证码(type:9) */
-(void)requestVerifyCodeForForgetPwd
{
    
    
    if(!self.isLoading9)
    {
        self.isLoading9=YES;
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=getVerificationCode&mobile=%@&stype=%d",URL_Server,_loginId,2];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=9;
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 重新设置密码(type:10) */
-(void)resetPassword:(NSString *)pwd mobile:(NSString *)mobile verifyCode:(NSString *)code
{
    if(!self.isLoading10)
    {
        self.isLoading10=YES;
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=pwdupdatebycode&mobile=%@&newpwd=%@&code=%@",URL_Server,mobile,pwd,code];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=10;
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 判断用户是否为浦田联通号(type:11) */
-(void)requestVerifyCodeForUnionPwd:(NSString *)mobile
{
    if(!self.isLoading11)
    {
        self.isLoading11=YES;
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=users&a=getVerificationCode&mobile=%@&stype=1",URL_Server,mobile];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        ASIHTTPRequest *_request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=11;
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 注销用户 */
-(void)logout
{
    self.isLogin=NO;
    self.userid=0;
    self.loginId=nil;
    self.pwd=nil;
    self.nickname=nil;
    self.encryptPwd=nil;
    self.portraitUrl=nil;
    self.wobi=0;
    [self saveUserInfo];
}
/** 将用户信息保存至本地 */
-(void)saveUserInfo
{
    NSString *tmpstr=nil;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:self.isLogin forKey:kUserDefaultsKeyIsLogin];
    [userDefaults setInteger:self.userid forKey:kUserDefaultsKeyUserID];
    
    tmpstr=self.loginId;
    if(tmpstr==nil)tmpstr=@"";
    [userDefaults setObject:tmpstr forKey:kUserDefaultsKeyLoginId];
    
    tmpstr=self.portraitUrl;
    if(tmpstr==nil)tmpstr=@"";
    [userDefaults setObject:tmpstr forKey:kUserDefaultsKeyPortraitUrl];
    
    tmpstr=self.pwd;
    if([self.pwd isNotNilOrEmptyString])
    {
        tmpstr=[self.pwd encodeBase64];
    }
    if(tmpstr==nil)tmpstr=@"";
    [userDefaults setObject:tmpstr forKey:kUserDefaultsKeyPwd];
    
    tmpstr=self.encryptPwd;
    if(tmpstr==nil)tmpstr=@"";
    [userDefaults setObject:tmpstr forKey:kUserDefaultsKeyEncryptPwd];
    
    tmpstr=self.nickname;
    if(tmpstr==nil)tmpstr=@"";
    [userDefaults setObject:tmpstr forKey:kUserDefaultsKeyNickName];
    
    if(_lastLoginDate)
        [userDefaults setObject:_lastLoginDate forKey:kUserDefaultsKeyLastLoginDate];
    
    [userDefaults synchronize];
}

-(void)didFinishHttpRequest:(ASIHTTPRequest *)request
{
    BOOL hasNetworkFlags=[Common hasNetworkFlags];
    BOOL succeed=NO;
    BOOL hasData=NO;
    NSString *msg=@"";
    NSInteger nType=request.tag;
    NSString *jsonString=[request responseString];
    NSDictionary *dic=[PlatServiceDataParser parseToDictionaryWithJsonString:jsonString];
    if(dic && [[dic objectForKey:@"state"] integerValue]==0)
    {
        succeed=YES;
        
        NSString *tmpstr=nil;
        self.isUnion=true;
        switch(nType)
        {
            case 1: //获取验证码
            {
                tmpstr=[dic objectForKey:@"data"];
                if([tmpstr isNotNilOrEmptyString])
                {
                    hasData=YES;
                    self.verifyCode=tmpstr;
                }
            }
                break;
            case 2: //注册
            {
                self.isLogin=YES;
                
                NSDictionary *tmpdic=[dic objectForKey:@"data"];
                if(tmpdic && [tmpdic isKindOfClass:[NSDictionary class]])
                {
                    tmpstr=[tmpdic objectForKey:@"id"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.userid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"wbtotal"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.wobi=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"user_pass"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.encryptPwd=tmpstr;
                }
                
                if(_lastLoginDate)
                    self.lastLoginDate=nil;
                _lastLoginDate=[[NSDate alloc] init];
                
                [self saveUserInfo];
            }
                break;
            case 3: //登录
            {
                self.isLogin=YES;
                
                NSDictionary *tmpdic=[dic objectForKey:@"data"];
                if(tmpdic && [tmpdic isKindOfClass:[NSDictionary class]])
                {
                    tmpstr=[tmpdic objectForKey:@"id"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.userid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"wbtotal"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.wobi=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"user_pass"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.encryptPwd=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"user_nicename"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.nickname=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"user_url"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.portraitUrl=tmpstr;
                    
                    if(![[tmpdic objectForKey:@"signin"] isNull])
                    {
                        self.isSignIn=[[tmpdic objectForKey:@"signin"] boolValue];
                    }
                }
                
                if(_lastLoginDate)
                    self.lastLoginDate=nil;
                _lastLoginDate=[[NSDate alloc] init];
                
                [self saveUserInfo];
            }
                break;
            case 4: //用户详情
            {
                NSDictionary *tmpdic=[dic objectForKey:@"data"];
                if(tmpdic && [tmpdic isKindOfClass:[NSDictionary class]])
                {
                    tmpstr=[tmpdic objectForKey:@"id"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.userid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"wbtotal"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.wobi=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"user_pass"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.encryptPwd=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"user_nicename"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.nickname=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"user_url"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.portraitUrl=tmpstr;
                    
                    if(![[tmpdic objectForKey:@"signin"] isNull])
                    {
                        self.isSignIn=[[tmpdic objectForKey:@"signin"] boolValue];
                    }
                }
            }
                break;
            case 6: //修改用户信息
            {
                NSDictionary *tmpdic=[dic objectForKey:@"data"];
                if(tmpdic && [tmpdic isKindOfClass:[NSDictionary class]])
                {
                    tmpstr=[tmpdic objectForKey:@"user_nicename"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.nickname=tmpstr;
                    
                    [self saveUserInfo];
                }
            }
                break;
            case 7: //修改密码
            {
                NSDictionary *tmpdic=[dic objectForKey:@"data"];
                if(tmpdic && [tmpdic isKindOfClass:[NSDictionary class]])
                {
                    tmpstr=[tmpdic objectForKey:@"user_pass"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.encryptPwd=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"user_nicename"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.nickname=tmpstr;
                    
                    self.pwd=self.modifyPwd;
                    [self saveUserInfo];
                }
            }
                break;
            case 8: //签到
            {
                self.isSignIn=YES;
                NSDictionary *tmpdic=[dic objectForKey:@"data"];
                if(tmpdic && [tmpdic isKindOfClass:[NSDictionary class]])
                {
                    tmpstr=[tmpdic objectForKey:@"wbtotal"];
                    if([tmpstr isNotNilOrEmptyString])
                        self.wobi=[tmpstr integerValue];
                }
            }
                break;
            case 9: //忘记密码验证码
            {
                
            }
                break;
            case 10: //重新设置密码
            {
                
            }
                break;
            case 11:
            {
                
                
            }
                break;
        }
    }
    else
    {
        if(dic && [dic objectForKey:@"msg"])
        {
            if(![[dic objectForKey:@"msg"] isNull])
                msg=[dic objectForKey:@"msg"];
        }
        //获取非浦田联通的验证码
        if(dic && [dic objectForKey:@"data"])
        {
            if(![[dic objectForKey:@"data"] isNull])
            {
                self.verifyCode=[dic objectForKey:@"data"];
                self.isUnion=false;

            }
            
        }
    }
    
    switch(nType)
    {
        case 1:self.isLoading1=NO;break;
        case 2:self.isLoading2=NO;break;
        case 3:self.isLoading3=NO;break;
        case 4:self.isLoading4=NO;break;
        case 5:self.isLoading5=NO;break;
        case 6:self.isLoading6=NO;break;
        case 7:self.isLoading7=NO;break;
        case 8:self.isLoading8=NO;break;
        case 9:self.isLoading9=NO;break;
    }
    
    NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] init];
    [userInfo setObject:@(hasNetworkFlags) forKey:kNotificationNetworkFlagsKey];
    [userInfo setObject:@(succeed) forKey:kNotificationSucceedKey];
    [userInfo setObject:@(hasData) forKey:kNotificationContentKey];
    [userInfo setObject:@(nType) forKey:kNotificationTypeKey];
    [userInfo setObject:msg forKey:kNotificationMessageKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:self userInfo:userInfo];
}

-(void)didFailedHttpRequest:(ASIHTTPRequest *)request
{
    switch(request.tag)
    {
        case 1:self.isLoading1=NO;break;
        case 2:self.isLoading2=NO;break;
        case 3:self.isLoading3=NO;break;
        case 4:self.isLoading4=NO;break;
        case 5:self.isLoading5=NO;break;
        case 6:self.isLoading6=NO;break;
        case 7:self.isLoading7=NO;break;
        case 8:self.isLoading8=NO;break;
        case 9:self.isLoading9=NO;break;
    }
    
    if([_notificationName isNotNilOrEmptyString])
    {
        NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] init];
        if([Common hasNetworkFlags])
            [userInfo setObject:@"1" forKey:kNotificationNetworkFlagsKey];
        else
            [userInfo setObject:@"0" forKey:kNotificationNetworkFlagsKey];
        [userInfo setObject:@"0" forKey:kNotificationSucceedKey];
        [userInfo setObject:@"0" forKey:kNotificationContentKey];
        [userInfo setObject:@(request.tag) forKey:kNotificationTypeKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:userInfo];
    }
}

@end
