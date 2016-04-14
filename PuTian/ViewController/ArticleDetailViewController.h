//
//  ArticleDetailViewController.h
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class ArticleInfo;

@interface ArticleDetailViewController : BaseViewController

/** 1:妈祖故乡;2:本地资讯;3:莆田娱乐; */
@property (nonatomic,assign) NSInteger term_id;

@property (nonatomic,strong) ArticleInfo *articleInfo;

@end
