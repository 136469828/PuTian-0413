//
//  LinyLabel.m
//  PuTian
//
//  Created by guofeng on 15/9/8.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "LinyLabel.h"

@interface LinyLabel()

@property (nonatomic,strong) UIView *line;

@end

@implementation LinyLabel

-(void)setLinyColor:(UIColor *)color
{
    _line.backgroundColor=color;
}

-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        _line=[[UIView alloc] initWithFrame:CGRectMake(0, (self.height-1)/2.0, self.width, 1)];
        _line.backgroundColor=[UIColor blackColor];
        _line.hidden=YES;
        [self addSubview:_line];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    _line.frame=CGRectMake(0, (self.height-_line.height)/2.0, self.width, _line.height);
    
    if(_line.hidden && [self.text isNotNilOrEmptyString])_line.hidden=NO;
}

@end
