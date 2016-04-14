//
//  VideoChannelInfoList.h
//  PuTian
//
//  Created by guofeng on 15/9/18.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 热门频道 */
@interface VideoChannelInfo : NSObject

/** 频道id */
@property (nonatomic,strong) NSString *channelid;
/** 频道名 */
@property (nonatomic,strong) NSString *channelName;
/** 图片url */
@property (nonatomic,strong) NSString *picurl;

@end

/** 热门频道列表 */
@interface VideoChannelInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;

/** 频道列表(VideoChannelInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadData;
-(void)disposeRequest;

@end
