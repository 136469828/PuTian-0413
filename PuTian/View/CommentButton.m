//
//  CommentButton.m
//  PuTian
//
//  Created by guofeng on 15/10/13.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "CommentButton.h"

@interface CommentButton()

@property (nonatomic,strong) UIImageView *ivDot;

@end

@implementation CommentButton

-(id)initWithFrame:(CGRect)frame type:(CommentButtonType)type
{
    if(self=[super initWithFrame:frame])
    {
        _type=type;
        
        UIFont *font=[UIFont systemFontOfSize:12.0];
        float dotWidth=19;
        float iconWidth=20,iconHeight=19;
        CGSize wordSize=[@"好评" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        float left=(self.width-dotWidth-iconWidth-wordSize.width)/2.0;
        
        _ivDot=[[UIImageView alloc] initWithFrame:CGRectMake(left, (self.height-dotWidth)/2.0, dotWidth, dotWidth)];
        _ivDot.image=[UIImage imageNamed:@"youhui_yuan_nor"];
        [self addSubview:_ivDot];
        
        UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake(_ivDot.x+_ivDot.width, (self.height-iconHeight)/2.0, iconWidth, iconHeight)];
        [self addSubview:icon];
        
        UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(icon.x+icon.width, (self.height-wordSize.height)/2.0, wordSize.width, wordSize.height)];
        lblTitle.font=font;
        [self addSubview:lblTitle];
        
        switch(type)
        {
            case CommentButtonTypeGood:
                icon.image=[UIImage imageNamed:@"youhui_comment_good"];
                lblTitle.text=@"好评";
                break;
            case CommentButtonTypeMiddle:
                icon.image=[UIImage imageNamed:@"youhui_comment_middle"];
                lblTitle.text=@"中评";
                break;
            case CommentButtonTypeBad:
                icon.image=[UIImage imageNamed:@"youhui_comment_bad"];
                lblTitle.text=@"差评";
                break;
        }
    }
    return self;
}

-(void)setSelection:(BOOL)selection
{
    _selection=selection;
    if(_selection)
        _ivDot.image=[UIImage imageNamed:@"youhui_yuan_pre"];
    else
        _ivDot.image=[UIImage imageNamed:@"youhui_yuan_nor"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
