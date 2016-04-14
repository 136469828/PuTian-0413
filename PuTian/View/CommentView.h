//
//  CommentView.h
//  PuTian
//
//  Created by guofeng on 15/10/13.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentView;

@protocol CommentViewDelegate <NSObject>

@optional
-(void)commentViewDidClose:(CommentView *)commentView;
-(void)commentViewDidSubmit:(CommentView *)commentView;

@end

@interface CommentView : UIView

@property (nonatomic,assign) id<CommentViewDelegate> delegate;

/** 评分 */
@property (nonatomic,readonly) NSInteger grade;
/** 1:好评;2:中评;3:差评 */
@property (nonatomic,readonly) NSInteger gradeType;
/** 评论 */
@property (nonatomic,readonly) NSString *comment;

@end
