//
//  CouponsDownloadViewController.h
//  PuTian
//
//  Created by guofeng on 15/9/14.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CouponsDownloadViewController : BaseViewController

@property (nonatomic,strong) void (^ dismissEventBlock)();
@property (nonatomic,assign) NSInteger productid;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,assign) float price;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger inventory;

@end
