//
//  CommentInfoList.h
//  PuTian
//
//  Created by guofeng on 15/10/13.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentInfo;

@interface CommentInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;

/** 用户id */
@property (nonatomic,assign) NSInteger userid;
/** 评论对象类别(1:文章;2:商家优惠;3:视频;) */
@property (nonatomic,assign) NSInteger commentType;
/** 1:妈祖故乡;2:本地资讯;3:莆田娱乐; */
@property (nonatomic,assign) NSInteger term_id;
/** 评论对象id */
@property (nonatomic,assign) NSInteger post_id;

@property (nonatomic,readonly) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,readonly) NSInteger recordCount;
@property (nonatomic,readonly) NSInteger pageCount;
/** 评论详情列表(CommentInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadDataWithSlideType:(SlideType)slideType;
-(void)insertCommentInfoToList:(CommentInfo *)info atIndex:(NSInteger)index;
-(void)clearList;
-(void)disposeRequest;

@end
