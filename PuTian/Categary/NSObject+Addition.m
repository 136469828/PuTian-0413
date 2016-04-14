//
//  NSObject+Addition.m
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "NSObject+Addition.h"
#import "GTMBase64.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSObject(Addition)

/** 不是空字符串 */
-(BOOL)isNotNilOrEmptyString
{
    if(self)
    {
        if(![self isKindOfClass:[NSString class]])return NO;
        NSString *str=(NSString *)self;
        if(str.length==0)return NO;
        return YES;
    }
    return NO;
}
/** 去除字符串两端的空格 */
-(NSString *)trim
{
    if(self)
    {
        if(![self isKindOfClass:[NSString class]])return nil;
        NSString *str=(NSString *)self;
        if(str.length==0)return str;
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return nil;
}
/** 是否为NSNull */
-(BOOL)isNull
{
    if(self)
    {
        if([self isKindOfClass:[NSNull class]])return YES;
    }
    return NO;
}

/** 编码base64字符串 */
-(NSString *)encodeBase64
{
    if(self && [self isKindOfClass:[NSString class]])
    {
        NSString *str=(NSString *)self;
        return [GTMBase64 stringByEncodingData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return nil;
}
/** 解码base64字符串 */
-(NSString *)decodeBase64
{
    if(self && [self isKindOfClass:[NSString class]])
    {
        NSString *str=(NSString *)self;
        NSData *dataStr=[GTMBase64 decodeString:str];
        return [[NSString alloc] initWithBytes:[dataStr bytes] length:dataStr.length encoding:NSUTF8StringEncoding];
    }
    return @"";
}

/** md5加密 */
-(NSString *)md5HexDigest
{
    if(self && [self isKindOfClass:[NSString class]])
    {
        NSString *str=(NSString *)self;
        const char *original_str = [str UTF8String];
        
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        
        CC_MD5(original_str, strlen(original_str), result);
        
        NSMutableString *hash = [NSMutableString string];
        
        for (int i = 0; i < 16; i++)
        {
            [hash appendFormat:@"%02X", result[i]];
        }
        
        return [hash lowercaseString];
    }
    return nil;
}

/** 是否为网址 */
-(BOOL)isUrl
{
    if(self && [self isKindOfClass:[NSString class]])
    {
        NSString *url=(NSString *)self;
        if (url.length == 0)return NO;
        
        NSString *regex2 = @"^(((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp)://)|(www\\.))+(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(/[a-zA-Z0-9\\&%_\\./-~-]*)?$";
        NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        return [urlPredicate evaluateWithObject:url];
    }
    return NO;
}
/** 验证邮箱地址 */
-(BOOL)isEmail
{
    if(self && [self isKindOfClass:[NSString class]])
    {
        NSString *email=(NSString *)self;
        if(email.length==0)return NO;
        
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:email];
    }
    return NO;
}
/** 验证手机号码 */
-(BOOL)isMobile
{
    if(self && [self isKindOfClass:[NSString class]])
    {
        NSString *mobile=(NSString *)self;
        if(mobile.length==0)return NO;
        
        //手机号以13， 15，18开头，八个 \d 数字字符
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        return [phoneTest evaluateWithObject:mobile];
    }
    return NO;
}
/** 验证身份证号 */
-(BOOL)isIdentityCard
{
    if(self && [self isKindOfClass:[NSString class]])
    {
        NSString *identityCard=(NSString *)self;
        if (identityCard.length == 0)return NO;
        
        NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        return [identityCardPredicate evaluateWithObject:identityCard];
    }
    return NO;
}

@end
