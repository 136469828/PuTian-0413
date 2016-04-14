//
//  VideoDetailViewController.h
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class VideoInfo;

@interface VideoDetailViewController : BaseViewController

@property (nonatomic,strong) VideoInfo *videoInfo;

@end
