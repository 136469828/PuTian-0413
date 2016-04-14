//
//  DateHelper.m
//  KuqiSports
//
//  Created by DBY on 14-6-5.
//  Copyright (c) 2014年 dby. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

/**
 获取一天的开始时间
 @param day 日期索引(0:今天;1:昨天;2:前天...)
 */
+(NSDate *)getStartTimeWithDay:(int)day
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    return [NSDate dateWithTimeInterval:-day*24*60*60 sinceDate:date];
}

/**
 获取一天的结束时间
 @param day 日期索引(0:今天;1:昨天;2:前天...)
 */
+(NSDate *)getDayEndTimeWithDay:(int)day
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    return [NSDate dateWithTimeInterval:-day*24*60*60 sinceDate:date];
}

/** 根据时间获取日期索引(日期索引,0表示今天;1表示昨天;...) */
+(NSInteger)getDayWithDate:(NSDate *)date
{
    NSDate *startDate = [DateHelper getStartTimeWithDay:0];
    long timerInterval = [startDate timeIntervalSinceDate:date];
    NSInteger days = timerInterval/(24*60*60);
    NSInteger remainder=timerInterval%(24*60*60);
    if(remainder>0)
        days+=1;
    return days;
}

/** 根据日期索引获取日期字符串 */
+(NSString *)getDayStringWithDay:(int)day
{
    if (day == 0)
        return @"今天";
    if (day == 1)
        return @"昨天";
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[DateHelper getStartTimeWithDay:day]];
    return [NSString stringWithFormat:@"%02d日",components.day];
}

/** 根据时间获取日期字符串 */
+(NSString *)getDayStringWithDate:(NSDate *)date
{
    int day=[DateHelper getDayWithDate:date];
    return [DateHelper getDayStringWithDay:day];
}

@end
