//
//  MetroButton.h
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MetroButton;

@protocol MetroButtonDelegate <NSObject>

-(void)metroButtonDidClick:(MetroButton *)button;

@end

@interface MetroButton : UIButton

@property (nonatomic,assign) id<MetroButtonDelegate> delegate;

-(void)metroTouchDown:(MetroButton *)button;
-(void)metroTouchUpInside:(MetroButton *)button;
-(void)metroTouchUpOutside:(MetroButton *)button;
-(void)metroTouchCancel:(MetroButton *)button;

@end
