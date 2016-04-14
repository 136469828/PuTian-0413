//
//  MazuInfoList.h
//  PuTian
//
//  Created by guofeng on 15/9/11.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleInfo.h"

/** 妈祖故乡列表 */
@interface MazuInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;
@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,readonly) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,readonly) NSInteger recordCount;
@property (nonatomic,readonly) NSInteger pageCount;
/** 妈祖故乡列表(ArticleInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadDataWithSlideType:(SlideType)slideType;
-(void)clearList;
-(void)disposeRequest;

@end
