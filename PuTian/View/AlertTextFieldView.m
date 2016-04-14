//
//  AlertTextFieldView.m
//  PuTian
//
//  Created by guofeng on 15/10/16.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "AlertTextFieldView.h"

@interface AlertTextFieldView()<UITextFieldDelegate>
{
    UITextField *_txt;
}

@end

@implementation AlertTextFieldView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andText:(NSString *)text andPlaceholder:(NSString *)placeholder cancelButton:(BOOL)needs andKeyboardType:(UIKeyboardType)keyboardType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIView *viewBG=[[UIView alloc] initWithFrame:self.bounds];
        viewBG.backgroundColor=[UIColor blackColor];
        viewBG.alpha=0.3;
        [self addSubview:viewBG];
        
        float top=50;
        if(self.frame.size.height>=450)
            top=self.frame.size.height-420;
        UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-280)/2.0, top, 280, 150)];
        contentView.layer.cornerRadius=10;
        contentView.backgroundColor=[UIColor colorWithWhite:0.92 alpha:1.0];
        [self addSubview:contentView];
        
        UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, contentView.frame.size.width, 20)];
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.textAlignment=NSTextAlignmentCenter;
        lblTitle.font=[UIFont systemFontOfSize:17.0];
        lblTitle.text=title;
        [contentView addSubview:lblTitle];
        
        _txt=[[UITextField alloc] initWithFrame:CGRectMake(10, lblTitle.frame.origin.y+lblTitle.frame.size.height+15, contentView.frame.size.width-20, 35)];
        _txt.borderStyle=UITextBorderStyleRoundedRect;
        _txt.text=text;
        _txt.placeholder=placeholder;
        _txt.keyboardType=keyboardType;
        _txt.font=[UIFont systemFontOfSize:15.0];
        [contentView addSubview:_txt];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, _txt.frame.origin.y+_txt.frame.size.height+15, contentView.frame.size.width, 1)];
        line.backgroundColor=[UIColor grayColor];
        [contentView addSubview:line];
        
        UIColor *color=[[UIColor alloc] initWithRed:0 green:122.0/255 blue:255.0/255 alpha:1.0];
        if(needs)
        {
            line=[[UIView alloc] initWithFrame:CGRectMake(contentView.frame.size.width/2.0, line.frame.origin.y+line.frame.size.height, 1, contentView.frame.size.height-line.frame.origin.y-line.frame.size.height)];
            line.backgroundColor=[UIColor grayColor];
            [contentView addSubview:line];
            
            UIButton *btnConfirm=[[UIButton alloc] initWithFrame:CGRectMake(0, line.frame.origin.y, contentView.frame.size.width/2.0, line.frame.size.height)];
            [btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
            [btnConfirm setTitleColor:color forState:UIControlStateNormal];
            [btnConfirm addTarget:self action:@selector(btnConfirm) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:btnConfirm];
            
            UIButton *btnCancel=[[UIButton alloc] initWithFrame:CGRectMake(line.frame.origin.x+line.frame.size.width, line.frame.origin.y, contentView.frame.size.width/2.0, line.frame.size.height)];
            [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
            [btnCancel setTitleColor:color forState:UIControlStateNormal];
            [btnCancel addTarget:self action:@selector(btnCancel) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:btnCancel];
        }
        else
        {
            UIButton *btnConfirm=[[UIButton alloc] initWithFrame:CGRectMake(0, line.frame.origin.y+line.frame.size.height, contentView.frame.size.width, contentView.frame.size.height-line.frame.origin.y-line.frame.size.height)];
            [btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
            [btnConfirm setTitleColor:color forState:UIControlStateNormal];
            [btnConfirm addTarget:self action:@selector(btnConfirm) forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:btnConfirm];
        }
        
        [_txt becomeFirstResponder];
    }
    return self;
}

-(void)btnConfirm
{
    if(_delegate && [_delegate respondsToSelector:@selector(alertTextFieldView:text:)])
        [_delegate alertTextFieldView:self text:_txt.text];
}
-(void)btnCancel
{
    if(_delegate && [_delegate respondsToSelector:@selector(alertTextFieldViewDidCancel:)])
        [_delegate alertTextFieldViewDidCancel:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
