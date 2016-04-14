//
//  AddSquareViewController.h
//  PuTian
//
//  Created by guofeng on 15/10/17.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class SquareInfoList;

@interface AddSquareViewController : BaseViewController

@property (nonatomic,strong) SquareInfoList *infoList;

@property (nonatomic,weak) NSArray *listOriginal;

@property (nonatomic,strong) void (^ willDismissBlock)(NSArray *listAdd,NSMutableArray *listRemovedIndex);

@end
