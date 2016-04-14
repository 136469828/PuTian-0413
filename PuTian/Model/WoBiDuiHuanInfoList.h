//
//  OffPriceInfoList.h
//  PuTian
//
//  Created by guofeng on 15/9/9.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 优惠信息 */
@interface WoBiDuanHuanInfo : NSObject

@property (nonatomic,assign) NSInteger productid;
@property (nonatomic,assign) NSInteger shopid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *introduce;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,assign) float marketprice;
@property (nonatomic,assign) float use_point;
@property (nonatomic,assign) float point;
@property (nonatomic,assign) float pointid;
@property (nonatomic,assign) NSInteger buyerCount;
@property (nonatomic,assign) NSInteger orderno;
@property (nonatomic,assign) NSInteger status;
/** 下载数量 */
@property (nonatomic,assign) NSInteger qty;

@end

/** 优惠信息列表 */
@interface WoBiDuanHuanInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;

@property (nonatomic,readonly) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,readonly) NSInteger recordCount;
@property (nonatomic,readonly) NSInteger pageCount;
/** 优惠信息列表(OffPriceInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadDataWithSlideType:(SlideType)slideType keywords:(NSString *)keywords;
-(void)loadDataWithSlideTypeFordingdan:(SlideType)slideType keywords:(NSString *)keywords UserId:(NSString *)userid;
-(void)clearList;
-(void)disposeRequest;

@end
