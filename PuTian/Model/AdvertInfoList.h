//
//  AdvertInfoList.h
//  PuTian
//
//  Created by guofeng on 15/9/15.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertInfo : NSObject

@property (nonatomic,assign) NSInteger ad_id;
@property (nonatomic,strong) NSString *ad_name;
@property (nonatomic,strong) NSString *ad_content;
@property (nonatomic,strong) NSString *ad_picurl;
@property (nonatomic,strong) NSString *ad_clickurl;

@end

/** 广告栏 */
@interface AdvertInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;

/** 广告类型 */
@property (nonatomic,assign) AdvertType type;
/** 广告栏列表(AdvertInfo) */
@property (nonatomic,readonly) NSArray *list;

-(void)loadData;
-(void)disposeRequest;

@end
