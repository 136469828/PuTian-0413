//
//  AddIndexModelViewController.h
//  PuTian
//
//  Created by guofeng on 15/10/16.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class IndexModelList;

@interface AddIndexModelViewController : BaseViewController

@property (nonatomic,strong) IndexModelList *modelList;

@property (nonatomic,weak) NSArray *listOriginal;

@property (nonatomic,strong) void (^ willDismissBlock)(NSArray *listAdd,NSMutableArray *listRemovedIndex);

@end
