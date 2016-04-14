//
//  CouponsList.h
//  PuTian
//
//  Created by guofeng on 15/9/19.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OffPriceInfoList.h"

/** 用户优惠券列表 */
@interface CouponsList : NSObject

@property (nonatomic,strong) NSString *notificationName;

@property (nonatomic,assign) NSInteger userid;
@property (nonatomic,readonly) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,readonly) NSInteger recordCount;
@property (nonatomic,readonly) NSInteger pageCount;
/** 优惠券列表(OffPriceInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadDataWithSlideType:(SlideType)slideType;
-(void)clearList;
-(void)disposeRequest;

@end
