//
//  MazuInfo.h
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentInfo;

@interface ArticleInfo : NSObject

@property (nonatomic,strong) NSString *notificationName;
/** 1:妈祖故乡;2:本地资讯;3:莆田娱乐; */
@property (nonatomic,assign) NSInteger term_id;
/** 评论者id、收藏者id */
@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,assign) NSInteger articleid;
/** 图片url */
@property (nonatomic,strong) NSString *imageUrl;
/** title */
@property (nonatomic,strong) NSString *title;
/** excerpt */
@property (nonatomic,strong) NSString *excerpt;
/** 页面url */
@property (nonatomic,strong) NSString *urlString;
/** 是否已收藏 */
@property (nonatomic,assign) BOOL isCollect;
/** 评论总数 */
@property (nonatomic,strong) NSString *comment_count;

/** 上传时间 */
@property (nonatomic,strong) NSString *post_date;
/** 阅读总数 */
@property (nonatomic,strong) NSString *post_hits;
/** 加载数据(type:1) */
-(void)loadData;
/** 提交评论(type:2) */
-(void)comment:(CommentInfo *)comment;
/** 收藏(type:3) */
-(void)collect:(BOOL)flag;

-(void)disposeRequest;

@end
