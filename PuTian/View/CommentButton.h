//
//  CommentButton.h
//  PuTian
//
//  Created by guofeng on 15/10/13.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentButton : UIButton

/** 按钮类型 */
@property (nonatomic,readonly) CommentButtonType type;
/** 是否选中 */
@property (nonatomic,assign) BOOL selection;

-(id)initWithFrame:(CGRect)frame type:(CommentButtonType)type;

@end
