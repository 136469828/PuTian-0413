//
//  CommentView.m
//  PuTian
//
//  Created by guofeng on 15/10/13.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "CommentView.h"
#import "CommentButton.h"

@interface CommentView()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) CommentButton *cbGood;
@property (nonatomic,strong) CommentButton *cbMiddle;
@property (nonatomic,strong) CommentButton *cbBad;
@property (nonatomic,strong) UITextView *txtComment;
@property (nonatomic,strong) UIButton *btnSubmit;

@end

@implementation CommentView

-(NSString *)comment
{
    return _txtComment.text;
}

-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        UIView *viewBG=[[UIView alloc] initWithFrame:self.bounds];
        viewBG.backgroundColor=[UIColor blackColor];
        viewBG.alpha=0.1;
        [self addSubview:viewBG];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        [viewBG addGestureRecognizer:tap];
        
        _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 260)];
        _contentView.center=self.center;
        _contentView.layer.cornerRadius=3;
        _contentView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_contentView];
        
        tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapGesture:)];
        [_contentView addGestureRecognizer:tap];
        
        UIButton *btnClose=[[UIButton alloc] initWithFrame:CGRectMake(_contentView.width-35, 3, 32, 32)];
        [btnClose setImage:[UIImage imageNamed:@"youhui_btn_x"] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(closeTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btnClose];
        
        float left=10;
        
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(left, 35, 80, 20)];
        lbl.font=[UIFont systemFontOfSize:15.0];
        lbl.text=@"综合评分:";
        [_contentView addSubview:lbl];
        
        UIButton *btn=nil;
        float starLeft=lbl.x+lbl.width;
        float starWidth=20;
        for(int i=1;i<=5;i++)
        {
            btn=[[UIButton alloc] initWithFrame:CGRectMake(starLeft, lbl.y-2, starWidth, starWidth)];
            btn.tag=i;
            [btn setImage:[UIImage imageNamed:@"youhui_star_pre"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(starTouchUp:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:btn];
            
            starLeft+=starWidth+5;
        }
        
        _grade=5;
        _gradeType=1;
        
        float btnWidth=70,btnHeight=25,btnMargin=10;
        _cbGood=[[CommentButton alloc] initWithFrame:CGRectMake(left-3, btn.y+btn.height+15, btnWidth, btnHeight) type:CommentButtonTypeGood];
        _cbGood.selection=YES;
        [_cbGood addTarget:self action:@selector(commentButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cbGood];
        
        _cbMiddle=[[CommentButton alloc] initWithFrame:CGRectMake(_cbGood.x+_cbGood.width+btnMargin, _cbGood.y, btnWidth, btnHeight) type:CommentButtonTypeMiddle];
        [_cbMiddle addTarget:self action:@selector(commentButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cbMiddle];
        
        _cbBad=[[CommentButton alloc] initWithFrame:CGRectMake(_cbMiddle.x+_cbMiddle.width+btnMargin, _cbGood.y, btnWidth, btnHeight) type:CommentButtonTypeBad];
        [_cbBad addTarget:self action:@selector(commentButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cbBad];
        
        _txtComment=[[UITextView alloc] initWithFrame:CGRectMake(left, _cbGood.y+_cbGood.height+10, _contentView.width-2*left, 100)];
        _txtComment.layer.borderColor=[UIColor grayColor].CGColor;
        _txtComment.layer.borderWidth=0.5;
        [_contentView addSubview:_txtComment];
        
        UIColor *color=[[UIColor alloc] initWithRed:255.0/255 green:100.0/255 blue:15.0/255 alpha:1.0];
        _btnSubmit=[[UIButton alloc] initWithFrame:CGRectMake((_contentView.width-200)/2.0, _txtComment.y+_txtComment.height+10, 200, 35)];
        _btnSubmit.layer.cornerRadius=3;
        _btnSubmit.backgroundColor=color;
        _btnSubmit.titleLabel.font=[UIFont systemFontOfSize:15.0];
        [_btnSubmit setTitle:@"发布评论" forState:UIControlStateNormal];
        [_btnSubmit setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_btnSubmit addTarget:self action:@selector(submitTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_btnSubmit];
        
        //键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)tapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    if(_txtComment.isFirstResponder)
        [_txtComment resignFirstResponder];
    else
        [self closeTouchUp];
}
-(void)contentViewTapGesture:(UITapGestureRecognizer *)tap
{
    if(_txtComment.isFirstResponder)
        [_txtComment resignFirstResponder];
}

-(void)starTouchUp:(UIButton *)button
{
    if(button.tag>0 && button.tag<=5)
    {
        _grade=button.tag;
        for(int i=1;i<=button.tag;i++)
        {
            UIButton *btn=(UIButton *)[_contentView viewWithTag:i];
            if([btn isKindOfClass:[UIButton class]])
                [btn setImage:[UIImage imageNamed:@"youhui_star_pre"] forState:UIControlStateNormal];
        }
        for(int i=button.tag+1;i<=5;i++)
        {
            UIButton *btn=(UIButton *)[_contentView viewWithTag:i];
            if([btn isKindOfClass:[UIButton class]])
                [btn setImage:[UIImage imageNamed:@"youhui_star_nor"] forState:UIControlStateNormal];
        }
    }
}

-(void)commentButtonTouchUp:(CommentButton *)button
{
    button.selection=YES;
    switch(button.type)
    {
        case CommentButtonTypeGood:
            _gradeType=1;
            if(_cbMiddle.selection)_cbMiddle.selection=NO;
            if(_cbBad.selection)_cbBad.selection=NO;
            break;
        case CommentButtonTypeMiddle:
            _gradeType=2;
            if(_cbGood.selection)_cbGood.selection=NO;
            if(_cbBad.selection)_cbBad.selection=NO;
            break;
        case CommentButtonTypeBad:
            _gradeType=3;
            if(_cbGood.selection)_cbGood.selection=NO;
            if(_cbMiddle.selection)_cbMiddle.selection=NO;
            break;
    }
}

-(void)closeTouchUp
{
    if([_delegate respondsToSelector:@selector(commentViewDidClose:)])
    {
        [_delegate commentViewDidClose:self];
    }
}

-(void)submitTouchUp
{
    if(_txtComment.isFirstResponder)
        [_txtComment resignFirstResponder];
    
    NSString *text=[_txtComment.text trim];
    if(![text isNotNilOrEmptyString])
    {
        [MBProgressHUDManager showCenterTextWithTitle:@"请输入评论内容" inView:self];
        return;
    }
    
    if([_delegate respondsToSelector:@selector(commentViewDidSubmit:)])
    {
        [_delegate commentViewDidSubmit:self];
    }
}

-(void)removeFromSuperview
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 键盘通知
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    float temp=keyboardRect.size.height-(self.height-_contentView.y-_btnSubmit.y-_btnSubmit.height);
    if(temp>0)
    {
        [UIView animateWithDuration:animationDuration animations:^
         {
             _contentView.center=CGPointMake(_contentView.center.x, _contentView.center.y-temp);
         }];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if(_contentView.center.y!=self.center.y)
    {
        [UIView animateWithDuration:animationDuration animations:^
         {
             _contentView.center=self.center;
         }];
    }
}

@end
