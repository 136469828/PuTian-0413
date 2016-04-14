//
//  DateHelper.h
//  KuqiSports
//
//  Created by DBY on 14-6-5.
//  Copyright (c) 2014年 dby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

/**
 获取一天的开始时间
 @param day 日期索引(0:今天;1:昨天;2:前天...)
 */
+(NSDate *)getStartTimeWithDay:(int)day;

/**
 获取一天的结束时间
 @param day 日期索引(0:今天;1:昨天;2:前天...)
 */
+(NSDate *)getDayEndTimeWithDay:(int)day;

/** 根据时间获取日期索引(日期索引,0表示今天;1表示昨天;...) */
+(NSInteger)getDayWithDate:(NSDate *)date;

/** 根据日期索引获取日期字符串 */
+(NSString *)getDayStringWithDay:(int)day;

/** 根据时间获取日期字符串 */
+(NSString *)getDayStringWithDate:(NSDate *)date;

@end
