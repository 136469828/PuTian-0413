//
//  OffPriceDetail.h
//  PuTian
//
//  Created by guofeng on 15/9/12.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentInfo;

/** 优惠信息详情 */
@interface OffPriceDetail : NSObject

@property (nonatomic,strong) NSString *notificationName;
@property (nonatomic,assign) NSInteger userid;

@property (nonatomic,assign) NSInteger productid;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,assign) float marketprice;
@property (nonatomic,assign) float saleprice;
@property (nonatomic,assign) NSInteger inventory;
@property (nonatomic,assign) NSInteger buyerCount;
@property (nonatomic,strong) NSString *introduce;
@property (nonatomic,strong) NSString *thumbimg;
@property (nonatomic,assign) NSInteger shopid;
@property (nonatomic,strong) NSString *validity_start;
@property (nonatomic,strong) NSString *validity_end;
@property (nonatomic,strong) NSArray *photos;
/** 是否已收藏 */
@property (nonatomic,assign) BOOL isCollect;

-(void)disposeRequest;
/** 加载数据(type:1) */
-(void)loadData;
/** 提交评论(type:2) */
-(void)comment:(CommentInfo *)comment;
/** 收藏(type:3) */
-(void)collect:(BOOL)flag;

@end
