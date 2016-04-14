//
//  RecreationChannelList.h
//  PuTian
//
//  Created by guofeng on 15/10/21.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecreationChannel : NSObject

@property (nonatomic,assign) NSInteger channelid;
@property (nonatomic,strong) NSString *channelName;
@property (nonatomic,strong) NSString *introduce;
@property (nonatomic,strong) NSString *iconUrl;

@end

@interface RecreationChannelList : NSObject

@property (nonatomic,strong) NSString *notificationName;

/** 娱乐频道列表(RecreationChannel) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadData;
-(void)disposeRequest;

@end
