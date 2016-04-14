//
//  OffPriceDetailViewController.h
//  PuTian
//
//  Created by guofeng on 15/9/9.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface OffPriceDetailViewController : BaseViewController

/** 1:商家优惠;2:我的优惠券 */
@property (nonatomic,assign) NSInteger sender;
@property (nonatomic,assign) NSInteger productid;



-(instancetype)initWithObject:(id)obj;
@end
