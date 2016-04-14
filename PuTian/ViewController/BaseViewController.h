//
//  BaseViewController.h
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,readonly) float navigationHeight;
@property (nonatomic,readonly) float tabBarHeight;
@property (nonatomic,readonly) float marginTop;

/** 在viewDidLoad中使用,viewDidLoad后直接用view的高度即可 */
@property (nonatomic,readonly) float viewHeight;
@property (nonatomic,readonly) float viewHeightWhenTabBarHided;

-(void)initNavigationLeftButton:(NSInteger)btnSign;
-(void)leftButtonTouchUp;

-(void)pushLoginViewController;

@end
