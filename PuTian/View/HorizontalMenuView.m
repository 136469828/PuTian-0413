//
//  HorizontalMenuView.m
//  MeiXiaoZhu
//
//  Created by DBY on 14-9-10.
//  Copyright (c) 2014年 MXZ. All rights reserved.
//

#import "HorizontalMenuView.h"

#define HorizontalMenuTitleLabelTag 999

@interface HorizontalMenuView()
{
    /** 菜单内容数量 */
    NSInteger _colCount;
    
    /** 当前选中的菜单按钮 */
    UIButton *_selectedButton;
    
    /** 选中按钮的底部线条标志 */
    UIView *_selectedBottomLine;
    
    /** 滑动视图 */
    UIScrollView *_scrollView;
    
    /** 内容装载容器 */
    UIView *_contentView;
    
    /** 菜单间距 */
    float _marginLeft;
}

@end

@implementation HorizontalMenuView

-(void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor=selectedColor;
    
    if(_selectedBottomLine)_selectedBottomLine.backgroundColor=selectedColor;
}

- (id)initWithFrame:(CGRect)frame isShowTopLine:(BOOL)isShowTopLine isShowBottomLine:(BOOL)isShowBottomLine
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor whiteColor];
        
        _allowsScroll=YES;
        
        _marginLeft=0.0;
        
        self.fontSize=15.0;
        
        self.gapWidth=30.0;
        
        self.normalColor=[UIColor blackColor];
        _selectedColor=[[UIColor alloc] initWithRed:255.0/255 green:102.0/255 blue:153.0/255 alpha:1.0];
        
        _scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled=NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        [self addSubview:_scrollView];
        
        _contentView=[[UIView alloc] initWithFrame:_scrollView.bounds];
        [_scrollView addSubview:_contentView];
        
        if(isShowTopLine)
        {
            UIView *lineTop=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
            lineTop.backgroundColor=[UIColor lightGrayColor];
            [self addSubview:lineTop];
        }
        
        if(isShowBottomLine)
        {
            UIView *lineBottom=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
            lineBottom.backgroundColor=[UIColor lightGrayColor];
            [self addSubview:lineBottom];
        }
        
        _selectedBottomLine=[[UIView alloc] initWithFrame:CGRectMake(7, frame.size.height-2, 0, 1.5)];
        _selectedBottomLine.backgroundColor=_selectedColor;
        [_scrollView addSubview:_selectedBottomLine];
    }
    return self;
}

-(void)reloadData
{
    _colCount=0;
    _selectedButton=nil;
    _selectedIndex=0;
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _scrollView.contentOffset=CGPointMake(0, 0);
    _selectedBottomLine.frame=CGRectMake(_selectedBottomLine.x, _selectedBottomLine.y, 0, _selectedBottomLine.height);
    
    if([_dataSource respondsToSelector:@selector(horizontalMenuViewColumnCount:)])
    {
        _colCount=[_dataSource horizontalMenuViewColumnCount:self];
        if(_colCount>0 && [_dataSource respondsToSelector:@selector(horizontalMenuView:menuAtIndex:)])
        {
            float btnWidth=0;
            if(!_allowsScroll)
            {
                btnWidth=(_contentView.width-(_colCount+1)*_marginLeft)/_colCount;
            }
            
            UIFont *selectedFont=[UIFont boldSystemFontOfSize:self.fontSize];
            UIButton *btn=nil;
            UILabel *lbl=nil;
            for(int i=0;i<_colCount;i++)
            {
                NSString *menuName=[_dataSource horizontalMenuView:self menuAtIndex:i];
                if(menuName)
                {
                    if(_allowsScroll)
                    {
                        NSDictionary *attr=[[NSDictionary alloc] initWithObjectsAndKeys:selectedFont, NSFontAttributeName, nil];
                        CGSize size=[menuName sizeWithAttributes:attr];
                        btnWidth=size.width+self.gapWidth;
                    }
                    
                    CGRect frame;
                    if(btn)
                        frame=CGRectMake(btn.x+btn.width+_marginLeft, 0, btnWidth, _contentView.height);
                    else
                        frame=CGRectMake(_marginLeft, 0, btnWidth, _contentView.height);
                    btn=[[UIButton alloc] initWithFrame:frame];
                    btn.tag=i+1;
                    btn.exclusiveTouch=YES;
                    [btn addTarget:self action:@selector(menuTouchUp:) forControlEvents:UIControlEventTouchUpInside];
                    [_contentView addSubview:btn];
                    
                    lbl=[[UILabel alloc] initWithFrame:btn.bounds];
                    lbl.backgroundColor=[UIColor clearColor];
                    lbl.textColor=_normalColor;
                    lbl.font=selectedFont;
                    lbl.textAlignment=NSTextAlignmentCenter;
                    lbl.tag=HorizontalMenuTitleLabelTag;
                    lbl.text=menuName;
                    lbl.transform=CGAffineTransformScale(lbl.transform, 0.9, 0.9);
                    [btn addSubview:lbl];
                    
                    if(i==0)
                        [self menuTouchUp:btn];
                }
            }
            
            if(btn && _allowsScroll)
            {
                _contentView.frame=CGRectMake(_contentView.x, _contentView.y, btn.x+btn.width+_marginLeft, _contentView.height);
                _scrollView.contentSize=_contentView.frame.size;
            }
        }
    }
}

-(void)menuTouchUp:(UIButton *)button
{
    if(button==_selectedButton)return;
    
    UILabel *lbl=nil;
    CGAffineTransform newTransform;
    if(_selectedButton)
    {
        lbl=(UILabel *)[_selectedButton viewWithTag:HorizontalMenuTitleLabelTag];
        lbl.textColor=_normalColor;
        newTransform=CGAffineTransformScale(lbl.transform, 0.9, 0.9);
        lbl.transform=newTransform;
    }
    
    lbl=(UILabel *)[button viewWithTag:HorizontalMenuTitleLabelTag];
    lbl.textColor=_selectedColor;
    newTransform=CGAffineTransformConcat(lbl.transform,CGAffineTransformInvert(lbl.transform));
    
    _selectedButton=button;
    
    _selectedIndex=button.tag-1;
    
    if(button.x+button.width+_marginLeft+_contentView.x>_scrollView.contentOffset.x+_scrollView.width)
    {
        _scrollView.contentOffset=CGPointMake(button.x+button.width+_marginLeft+_contentView.x-_scrollView.width, _scrollView.contentOffset.y);
    }
    else if(button.x-_marginLeft+_contentView.x<_scrollView.contentOffset.x)
    {
        _scrollView.contentOffset=CGPointMake(button.x-_marginLeft+_contentView.x, _scrollView.contentOffset.y);
    }
    
    CGRect lineRect=_selectedBottomLine.frame;
    lineRect.origin.x=button.x;
    lineRect.size.width=button.width;
    
    [UIView animateWithDuration:0.2 animations:^
     {
         lbl.transform=newTransform;
         _selectedBottomLine.frame=lineRect;
     }];
    
    if([_delegate respondsToSelector:@selector(horizontalMenuView:didSelectMenuAtIndex:)])
        [_delegate horizontalMenuView:self didSelectMenuAtIndex:button.tag-1];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    [self reloadData];
}

@end
