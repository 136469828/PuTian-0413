//
//  OffPriceInfoList.h
//  PuTian
//
//  Created by guofeng on 15/9/9.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 优惠信息 */
@interface OffPriceInfo : NSObject

@property (nonatomic,assign) NSInteger productid;
@property (nonatomic,assign) NSInteger shopid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *introduce;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,assign) float marketprice;
@property (nonatomic,assign) float saleprice;
@property (nonatomic,assign) NSInteger buyerCount;
/** 下载数量 */
@property (nonatomic,assign) NSInteger qty;

@end

/** 优惠信息列表 */
@interface OffPriceInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;

@property (nonatomic,readonly) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,readonly) NSInteger recordCount;
@property (nonatomic,readonly) NSInteger pageCount;
/** 优惠信息列表(OffPriceInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadDataWithSlideType:(SlideType)slideType keywords:(NSString *)keywords;
-(void)clearList;
-(void)disposeRequest;

@end
