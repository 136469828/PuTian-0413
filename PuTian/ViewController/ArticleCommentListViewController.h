//
//  ArticleCommentListViewController.h
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ArticleCommentListViewController : BaseViewController

/** 是否评论 */
@property (nonatomic,assign) BOOL isWriteComment;
/** 文章id、视频id */
@property (nonatomic,assign) NSInteger post_id;
/** 评论对象类别(1:文章;2:商家优惠;3:视频;) */
@property (nonatomic,assign) NSInteger commentType;

@property (nonatomic,assign) id object;

@end
