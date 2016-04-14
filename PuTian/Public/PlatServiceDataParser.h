//
//  PlatServiceDataParser.h
//  TestService
//
//  Created by Mac_WF on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//和服务器 进行数据交互的数据转换类
//
@interface PlatServiceDataParser : NSObject

//将二进制数据转化为字符串
+(NSString*)parseToHexStringWithBytes:(Byte*)bytes addLength:(NSUInteger)length;
//将NSData数据转为字符串
+(NSString*)parseToHexStringWithNSData:(NSData*)data;
//将符合规格字符串转换为二级制
+(Byte*)parseToBytesWithHexString:(NSString*) hexString;
//将符合规格的字符串转为NSData
+(NSData*)parseToNSDataWithHexString:(NSString*)hexString;


//将Json数据转为NSDictionary
+(NSDictionary*)parseToDictionaryWithJsonData:(NSData*)jsonData;
//将Json 字符串数据转为NSDictionary
+(NSDictionary*)parseToDictionaryWithJsonString:(NSString*)jsonString;
//将Json数据转为NSArray
+(NSArray*)parseToArrayWithJsonData:(NSData*)jsonData;
//将Json字符串数据转为NSArray
+(NSArray*)parseToArrayWithJsonString:(NSString*)jsonString;

//将对象转为Json数据
+(NSData*)parseToJsonDataWithObject:(id)data;
//将对象转为Json字符串
+(NSString*)parseToJsonStringWithObject:(id)data;

+(id)arrayWithJsonString:(NSString *)jsonString andClassName:(Class)className andSpecialColumn:(NSDictionary *)dicSpecail;

@end
