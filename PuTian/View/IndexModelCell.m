//
//  IndexModelCell.m
//  PuTian
//
//  Created by guofeng on 15/10/9.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "IndexModelCell.h"

@interface IndexModelCell()

@property (nonatomic,strong) UIColor *backgroundNormal;
@property (nonatomic,strong) UIColor *backgroundHigh;

@property (nonatomic,strong) UIButton *btnMinus;

@property (nonatomic,strong) UIView *lineRight;
@property (nonatomic,strong) UIView *lineBottom;

@end

@implementation IndexModelCell

-(void)setMinusButtonVisible:(BOOL)visible
{
    _btnMinus.hidden=!visible;
}
-(void)setRightLineVisible:(BOOL)visible
{
    _lineRight.hidden=!visible;
}
-(void)setAddImageViewRect
{
    float centerX=self.width/2;
    float centerY=self.height/2;
    if(_imageView.center.x!=centerX || _imageView.center.y!=centerY)
        _imageView.center=CGPointMake(centerX, centerY);
}
-(void)restoreImageViewRect
{
    float centerX=self.width/2;
    float centerY=self.height/2-15;
    if(_imageView.center.x!=centerX || _imageView.center.y!=centerY)
        _imageView.center=CGPointMake(centerX, centerY);
}

-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        self.backgroundNormal=[UIColor whiteColor];
        self.backgroundHigh=[UIColor colorWithWhite:0.92 alpha:1.0];
        
        self.backgroundColor=self.backgroundNormal;
        
        _imageView=[[MyWebImage alloc] initWithFrame:CGRectMake(0, 0, self.width*3/10.0, self.height*3/10.0)];
        _imageView.center=CGPointMake(self.width/2, self.height/2-15);
        [self addSubview:_imageView];
        
        _lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.y+_imageView.height+15, self.width, 15)];
        _lblTitle.textAlignment=NSTextAlignmentCenter;
        _lblTitle.font=[UIFont systemFontOfSize:13.0];
        _lblTitle.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self addSubview:_lblTitle];
        
        _btnMinus=[[UIButton alloc] initWithFrame:CGRectMake(self.width-30, 0, 30, 30)];
        _btnMinus.hidden=YES;
        UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake((_btnMinus.width-15)/2.0, (_btnMinus.height-15)/2.0, 15, 15)];
        iv.image=[UIImage imageNamed:@"index_minus"];
        [_btnMinus addSubview:iv];
        [_btnMinus addTarget:self action:@selector(minusTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnMinus];
        
        _lineRight=[[UIView alloc] initWithFrame:CGRectMake(self.width-0.5, 0, 0.5, self.height)];
        _lineRight.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1.0];
        _lineRight.hidden=YES;
        [self addSubview:_lineRight];
        
        _lineBottom=[[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        _lineBottom.backgroundColor=[UIColor colorWithWhite:0.85 alpha:1.0];
        [self addSubview:_lineBottom];
    }
    return self;
}

-(void)minusTouchUp
{
    if([_delegate respondsToSelector:@selector(indexModelCellWillDelete:)])
    {
        [_delegate indexModelCellWillDelete:self];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted ? self.backgroundHigh : self.backgroundNormal;
}

@end
