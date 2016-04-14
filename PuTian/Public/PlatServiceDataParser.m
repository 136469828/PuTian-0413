//
//  PlatServiceDataParser.m
//  TestService
//
//  Created by Mac_WF on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlatServiceDataParser.h"
#import <objc/runtime.h>

@implementation PlatServiceDataParser

//将二进制数据转化为字符串
+(NSString*)parseToHexStringWithBytes:(Byte*)bytes addLength:(NSUInteger)length
{
    if (bytes && length>0) {        
        NSMutableString *hexString = [[NSMutableString alloc]init];                
        for (int i=0; i<length; i++) {
            NSString *tmpString =[[NSString alloc] initWithFormat:@"%x",bytes[i]&0xff];
            if ([tmpString length]==1) {
                [hexString appendFormat:@"0%@",tmpString];
            }else {
                [hexString appendFormat:@"%@",tmpString];
            }
        }
        return [NSString stringWithFormat:@"0x%@",hexString];
    }
    return @"0x";
}

//将NSData数据转为字符串
+(NSString*)parseToHexStringWithNSData:(NSData*)data
{
    if (data) {
        Byte *bt = (Byte*)[data bytes];
        NSUInteger length = [data length];        
        return [PlatServiceDataParser parseToHexStringWithBytes:bt addLength:length];    
    }
    return @"0x";
}

//将符合规格字符串转换为二级制
+(Byte*)parseToBytesWithHexString:(NSString*) hexString
{
    if ([[hexString substringToIndex:2] isEqualToString:@"0x"]) {
        
        NSString *tmpHexString = [hexString substringFromIndex:2];        
        Byte bt[[tmpHexString length]/2];
        
        for (int i=0,j=0; i<tmpHexString.length; i=i+2,j++) {
            bt[j] = [self parseByteData:[tmpHexString characterAtIndex:i]] * 16 
                     + [self parseByteData:[tmpHexString characterAtIndex:(i+1)]];
        }
        Byte * bts=bt;
        return bts;
    }
    return  nil;  
}
//字符转换
+(int)parseByteData:(unichar)ch
{       
    int int_ch;              
    if(ch >= '0' && ch <='9'){
        int_ch = ch-48;   
    }
    else if(ch >= 'A' && ch <='F'){
        int_ch = ch - 55; 
    }
    else{
        int_ch = ch - 87; 
    }
    return  int_ch;
}

//将符合规格的字符串转为NSData
+(NSData*)parseToNSDataWithHexString:(NSString*)hexString
{    
    Byte *bt = [PlatServiceDataParser parseToBytesWithHexString:hexString];
    if (bt) {
        return [[NSData alloc]initWithBytes:bt length:([hexString length]-2)/2];
    }    
    return  nil;
}

//将Json数据转为NSDictionary
+(NSDictionary*)parseToDictionaryWithJsonData:(NSData*)jsonData
{
    if (jsonData) {
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            return (NSDictionary*)result;
        }
    }   
    return  nil;    
}

//将Json 字符串数据转为NSDictionary
+(NSDictionary*)parseToDictionaryWithJsonString:(NSString*)jsonString
{
    if (jsonString) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        return [PlatServiceDataParser parseToDictionaryWithJsonData:jsonData];
    }
    return  nil;   
}

//将Json数据转为NSArray
+(NSArray*)parseToArrayWithJsonData:(NSData*)jsonData
{
    if (jsonData) {
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        if ([result isKindOfClass:[NSArray class]]) {
            return (NSArray*)result;
        }
    }
    return nil;
}

//将Json字符串数据转为NSArray
+(NSArray*)parseToArrayWithJsonString:(NSString*)jsonString
{
    if (jsonString) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        return  [PlatServiceDataParser parseToArrayWithJsonData:jsonData];
    }
    return  nil;    
}

//将对象转为Json数据
+(NSData*)parseToJsonDataWithObject:(id)data
{
    if (data) {
        return  [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    }
    return  nil;    
}

//将对象转为Json字符串
+(NSString*)parseToJsonStringWithObject:(id)data
{
    if (data) {
        NSData *jsonData  = [PlatServiceDataParser parseToJsonDataWithObject:data];
        return  [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return  nil;
}

//将json字符串转换为实体对象数组
+(id)arrayWithJsonString:(NSString *)jsonString andClassName:(Class)className andSpecialColumn:(NSDictionary *)dicSpecail
{
    NSMutableArray *array=nil;
    
    NSArray *tmparr=[PlatServiceDataParser parseToArrayWithJsonString:jsonString];
    if(tmparr && tmparr.count>0)
    {
        //获取该类的所有属性
        NSMutableArray *arrProperties=[[NSMutableArray alloc] init];
        unsigned int outCount,i;
        objc_property_t *properties = class_copyPropertyList(className, &outCount);
        for (i=0; i<outCount; i++)
        {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [arrProperties addObject:propertyName];
        }
        
        if(arrProperties.count>0)
        {
            array=[[NSMutableArray alloc] initWithCapacity:10];
            for(NSDictionary *dic in tmparr)
            {
                if([dic isKindOfClass:[NSDictionary class]])
                {
                    id object=[[className alloc] init];
                    for(NSString *key in dic.allKeys)
                    {
                        if([arrProperties containsObject:key])
                        {
                            [object setValue:[dic objectForKey:key] forKey:key];
                        }
                        else
                        {
                            if(dicSpecail && [dicSpecail.allKeys containsObject:key] && [arrProperties containsObject:[dicSpecail objectForKey:key]])
                            {
                                [object setValue:[dic objectForKey:key] forKey:[dicSpecail objectForKey:key]];
                            }
                        }
                    }
                    [array addObject:object];
                }
            }
        }
    }
    
    return array;
}

@end
