//
//  WobiInfoList.h
//  PuTian
//
//  Created by guofeng on 15/9/19.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WobiInfo : NSObject

/** 详情id */
@property (nonatomic,assign) NSInteger detailid;
/** 沃币来源(1:登录签到;2:订单;) */
@property (nonatomic,assign) NSInteger fktype;
/** 沃币来源 */
@property (nonatomic,strong) NSString *fktypeName;
/** 沃币数量 */
@property (nonatomic,assign) NSInteger wobi;
/** 时间 */
@property (nonatomic,strong) NSDate *createDate;
/** 来源订单号 */
@property (nonatomic,strong) NSString *orderNo;

@end

/** 沃币详情列表 */
@interface WobiInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;

/** 用户id */
@property (nonatomic,assign) NSInteger userid;

@property (nonatomic,readonly) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,readonly) NSInteger recordCount;
@property (nonatomic,readonly) NSInteger pageCount;
/** 沃币详情列表(WobiInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadDataWithSlideType:(SlideType)slideType;
-(void)clearList;
-(void)disposeRequest;

@end
