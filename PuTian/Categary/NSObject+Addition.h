//
//  NSObject+Addition.h
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Addition)

/** 不是空字符串 */
-(BOOL)isNotNilOrEmptyString;
/** 去除字符串两端的空格 */
-(NSString *)trim;
/** 是否为NSNull */
-(BOOL)isNull;

/** 编码base64字符串 */
-(NSString *)encodeBase64;
/** 解码base64字符串 */
-(NSString *)decodeBase64;

/** md5加密 */
-(NSString *)md5HexDigest;

/** 是否为网址 */
-(BOOL)isUrl;
/** 验证邮箱地址 */
-(BOOL)isEmail;
/** 验证手机号码 */
-(BOOL)isMobile;

@end
