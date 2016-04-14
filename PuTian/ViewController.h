//
//  ViewController.h
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ViewController : BaseViewController

/** 当没有数据时重新加载 */
-(void)reloadWhenNoData;
-(void)reloadWhenLongInterval;

@end

