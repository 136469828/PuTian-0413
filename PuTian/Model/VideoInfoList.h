//
//  VideoInfoList.h
//  PuTian
//
//  Created by guofeng on 15/9/18.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoInfo.h"

/** 视频列表 */
@interface VideoInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;
@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,readonly) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,readonly) NSInteger recordCount;
@property (nonatomic,readonly) NSInteger pageCount;
/** 优惠信息列表(OffPriceInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadDataWithSlideType:(SlideType)slideType keywords:(NSString *)keywords channel:(NSString *)channelid;
-(void)clearList;
-(void)disposeRequest;

@end
