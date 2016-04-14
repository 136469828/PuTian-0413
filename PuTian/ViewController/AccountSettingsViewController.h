//
//  AccountSettingsViewController.h
//  PuTian
//
//  Created by guofeng on 15/9/18.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AccountSettingsViewController : BaseViewController

@property (nonatomic,strong) void (^ callback)(BOOL isRefresh);

@end
