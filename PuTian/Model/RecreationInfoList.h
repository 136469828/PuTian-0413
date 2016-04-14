//
//  RecreationInfoList.h
//  PuTian
//
//  Created by guofeng on 15/9/15.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleInfo.h"

/** 莆田娱乐 */
@interface RecreationInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;
@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,assign) NSInteger channelid;

@property (nonatomic,readonly) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,readonly) NSInteger recordCount;
@property (nonatomic,readonly) NSInteger pageCount;
/** 莆田娱乐列表(ArticleInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadDataWithSlideType:(SlideType)slideType keywords:(NSString *)keywords;
-(void)clearList;
-(void)disposeRequest;

@end
