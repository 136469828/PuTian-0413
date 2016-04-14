//
//  CollectionInfoList.h
//  PuTian
//
//  Created by guofeng on 15/10/14.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionInfo : NSObject

@property (nonatomic,assign) NSInteger collectionid;
/** 收藏对象id */
@property (nonatomic,assign) NSInteger post_id;
/** 收藏对象title */
@property (nonatomic,strong) NSString *post_title;
/** 收藏对象简介 */
@property (nonatomic,strong) NSString *post_introduce;
/** 收藏对象展示图url */
@property (nonatomic,strong) NSString *url;
/** 收藏日期 */
@property (nonatomic,strong) NSDate *date;

@end

@interface CollectionInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;

/** 用户id */
@property (nonatomic,assign) NSInteger userid;
/** 收藏对象类别(1:文章;2:商家优惠;3:视频;) */
@property (nonatomic,assign) NSInteger collectType;
/** 1:妈祖故乡;2:本地资讯;3:莆田娱乐; */
@property (nonatomic,assign) NSInteger term_id;
/** 收藏对象id */
@property (nonatomic,assign) NSInteger post_id;

@property (nonatomic,readonly) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,readonly) NSInteger recordCount;
@property (nonatomic,readonly) NSInteger pageCount;
/** 收藏列表(CollectionInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadDataWithSlideType:(SlideType)slideType;
-(void)clearList;
-(void)disposeRequest;

@end
