//
//  UnionOffPriceInfoList.h
//  PuTian
//
//  Created by guofeng on 15/9/16.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OffPriceInfoList.h"

/** 店铺其他优惠信息 */
@interface UnionOffPriceInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;

@property (nonatomic,assign) NSInteger shopid;
/** 优惠信息列表(OffPriceInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)disposeRequest;
-(void)loadDataWithNumber:(NSInteger)number;

@end
