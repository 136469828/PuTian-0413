//
//  CouponsDownload.h
//  PuTian
//
//  Created by guofeng on 15/9/19.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponsDownload : NSObject

@property (nonatomic,strong) NSString *notificationName;

@property (nonatomic,assign) NSInteger userid;

@property (nonatomic,assign) NSInteger productid;

@property (nonatomic,strong) NSString *orderNo;

-(void)downloadWithCount:(NSInteger)count;
-(void)disposeRequest;

@end
