//
//  MetroButton.m
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "MetroButton.h"

@interface MetroButton()
{
    CGAffineTransform _originalTransform;
}

@property (atomic,assign) BOOL isAnimating;
@property (nonatomic,strong) NSDate *downDate;

@end

@implementation MetroButton

-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        _originalTransform=self.transform;
        
        [self addTarget:self action:@selector(metroTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(metroTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(metroTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(metroTouchCancel:) forControlEvents:UIControlEventTouchCancel];
    }
    return self;
}

-(void)metroTouchDown:(MetroButton *)button
{
    [self zoom];
}
-(void)metroTouchUpInside:(MetroButton *)button
{
    [self restore:YES];
}
-(void)metroTouchUpOutside:(MetroButton *)button
{
    [self restore:NO];
}
-(void)metroTouchCancel:(MetroButton *)button
{
    [self restore:NO];
}

-(void)zoom
{
    if(self.isAnimating)return;
    
    self.isAnimating=YES;
    if(_downDate)
        self.downDate=nil;
    _downDate=[[NSDate alloc] init];
    
    [UIView animateWithDuration:0.1 animations:^
    {
        self.transform=CGAffineTransformScale(_originalTransform, 0.9, 0.9);
    }];
}
-(void)restore:(BOOL)isClicked
{
    NSDate *now=[[NSDate alloc] init];
    if([now timeIntervalSinceDate:_downDate]<0.15)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^
        {
            [NSThread sleepForTimeInterval:0.1];
            dispatch_sync(dispatch_get_main_queue(), ^
            {
                [UIView animateWithDuration:0.1 animations:^
                 {
                     self.transform=CGAffineTransformIdentity;
                 } completion:^(BOOL finished)
                 {
                     self.isAnimating=NO;
                     
                     if(isClicked && [_delegate respondsToSelector:@selector(metroButtonDidClick:)])
                     {
                         [_delegate metroButtonDidClick:self];
                     }
                 }];
            });
        });
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^
        {
            self.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished)
        {
            self.isAnimating=NO;
            
            if(isClicked && [_delegate respondsToSelector:@selector(metroButtonDidClick:)])
            {
                [_delegate metroButtonDidClick:self];
            }
        }];
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
