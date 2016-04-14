//
//  ShopInfo.h
//  PuTian
//
//  Created by guofeng on 15/9/12.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 店铺信息 */
@interface ShopInfo : NSObject

@property (nonatomic,strong) NSString *notificationName;

@property (nonatomic,assign) NSInteger shopid;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *businessTime;

-(void)loadData;
-(void)disposeRequest;

@end
