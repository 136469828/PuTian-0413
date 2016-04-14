//
//  HotVideoInfo.h
//  PuTian
//
//  Created by guofeng on 15/9/16.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoInfo.h"

/** 焦点视频，随机视频 */
@interface HotVideoInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;
@property (nonatomic,assign) NSInteger uid;

/** 0:焦点视频;1:随机视频; */
@property (nonatomic,assign) NSInteger type;
/** 视频列表(VideoInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadData;
-(void)disposeRequest;

@end
