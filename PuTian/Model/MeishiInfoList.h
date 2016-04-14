//
//  MeishiInfoList.h
//  PuTian
//
//  Created by admin on 16/3/28.
//  Copyright © 2016年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleInfo.h"
@interface MeishiInfoList : NSObject
@property (nonatomic,strong) NSString *notificationName;
@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,readonly) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,readonly) NSInteger recordCount;
@property (nonatomic,readonly) NSInteger pageCount;

@property (nonatomic, assign) NSInteger termId;
/** 列表(ArticleInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadDataWithSlideType:(SlideType)slideType;
-(void)clearList;
-(void)disposeRequest;

@end

