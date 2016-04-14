//
//  ArticleCommentView.h
//  PuTian
//
//  Created by guofeng on 15/10/21.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleCommentView;

@protocol ArticleCommentViewDelegate <NSObject>

@optional
-(void)articleCommentViewDidClose:(ArticleCommentView *)commentView;
-(void)articleCommentViewDidSubmit:(ArticleCommentView *)commentView;

@end

@interface ArticleCommentView : UIView

@property (nonatomic,assign) id<ArticleCommentViewDelegate> delegate;

/** 评分 */
@property (nonatomic,readonly) NSInteger grade;
/** 评论 */
@property (nonatomic,readonly) NSString *comment;

@end
