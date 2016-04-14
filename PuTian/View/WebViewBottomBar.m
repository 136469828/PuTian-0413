//
//  WebViewBottomBar.m
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "WebViewBottomBar.h"

@interface WebViewBottomBar()

@property (nonatomic,strong) UIButton *btnCollect;

@end

@implementation WebViewBottomBar

-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        if(self.height!=WebViewBottomBarHeight)
            self.height=WebViewBottomBarHeight;
        
        UIImageView *barBG=[[UIImageView alloc] initWithFrame:self.bounds];
        barBG.image=[UIImage imageNamed:@"youhui_tabbar_bg"];
        [self addSubview:barBG];
        
        float tmpwidth=40;
        float tmpleft=40;
        float tmpmargin=(self.width-3*tmpleft-4*tmpwidth)/2.0;
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(tmpleft, 0, tmpwidth, tmpwidth)];
        [btn setImage:[UIImage imageNamed:@"youhui_comment_nor"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(commentTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        btn=[[UIButton alloc] initWithFrame:CGRectMake(btn.x+tmpwidth+tmpmargin, 0, tmpwidth-13, tmpwidth-13)];
        [btn setImage:[UIImage imageNamed:@"video_showcomment"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showCommentTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(btn.x-10, btn.y+btn.height, 20+btn.width, 13)];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.font=[UIFont systemFontOfSize:9.5];
        lbl.textColor=[UIColor colorWithWhite:0.4 alpha:1.0];
        lbl.text=@"查看评价";
        lbl.userInteractionEnabled=YES;
        [self addSubview:lbl];
        
        
        btn=[[UIButton alloc] initWithFrame:CGRectMake(btn.x+tmpwidth+tmpmargin, 0, tmpwidth, tmpwidth)];
        [btn setImage:[UIImage imageNamed:@"youhui_share_btn_x"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showShareTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        lbl=[[UILabel alloc] initWithFrame:CGRectMake(btn.x-10, btn.height-12, 20+btn.width, 13)];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.font=[UIFont systemFontOfSize:9.5];
        lbl.textColor=[UIColor colorWithWhite:0.4 alpha:1.0];
        lbl.text=@"分享";
        lbl.userInteractionEnabled=YES;
        [self addSubview:lbl];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCommentTouchUp)];
        [lbl addGestureRecognizer:tap];
        
        _btnCollect=[[UIButton alloc] initWithFrame:CGRectMake(btn.x+tmpwidth+tmpmargin, 0, tmpwidth, tmpwidth)];
        [_btnCollect setImage:[UIImage imageNamed:@"youhui_collect_nor"] forState:UIControlStateNormal];
        [_btnCollect addTarget:self action:@selector(collectTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCollect];
    }
    return self;
}
-(void)setIsCollect:(BOOL)isCollect
{
    _isCollect=isCollect;
    
    if(isCollect)
    {
        [_btnCollect setImage:[UIImage imageNamed:@"youhui_collect_pre"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnCollect setImage:[UIImage imageNamed:@"youhui_collect_nor"] forState:UIControlStateNormal];
    }
}

-(void)commentTouchUp
{
    if([_delegate respondsToSelector:@selector(webViewBottomBarDidClickComment:)])
    {
        [_delegate webViewBottomBarDidClickComment:self];
    }
}
-(void)showCommentTouchUp
{
    if([_delegate respondsToSelector:@selector(webViewBottomBarDidClickShowComment:)])
    {
        [_delegate webViewBottomBarDidClickShowComment:self];
    }
}
-(void)showShareTouchUp
{
    if([_delegate respondsToSelector:@selector(webViewBottomBarDidClickShowShare:)])
    {
        [_delegate webViewBottomBarDidClickShowShare:self];
    }
}
-(void)collectTouchUp
{
    if([_delegate respondsToSelector:@selector(webViewBottomBarDidClickCollect:)])
    {
        [_delegate webViewBottomBarDidClickCollect:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
