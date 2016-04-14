//
//  RegistViewController.h
//  PuTian
//
//  Created by guofeng on 15/9/17.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RegistViewController : BaseViewController

/** 注册回调 */
@property (nonatomic,strong) void (^ registCallback)(BOOL succeed);

@end
