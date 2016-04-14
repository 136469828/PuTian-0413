//
//  VideoInfo.h
//  PuTian
//
//  Created by guofeng on 15/9/16.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentInfo;

@interface VideoInfo : NSObject

@property (nonatomic,strong) NSString *notificationName;
/** 评论者id、收藏者id */
@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,assign) NSInteger videoid;
@property (nonatomic,strong) NSString *videoName;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign) NSInteger userid;
@property (nonatomic,assign) BOOL isHot;
@property (nonatomic,strong) NSString *thumbimg;
@property (nonatomic,strong) NSString *linkurl;
/** 是否已收藏 */
@property (nonatomic,assign) BOOL isCollect;

/** 加载数据(type:1) */
-(void)loadData;
/** 提交评论(type:2) */
-(void)comment:(CommentInfo *)comment;
/** 收藏(type:3) */
-(void)collect:(BOOL)flag;

-(void)disposeRequest;

@end
