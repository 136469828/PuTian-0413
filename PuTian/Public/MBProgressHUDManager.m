//
//  MBProgressHUDManager.m
//  CandyShine
//
//  Created by huangfulei on 14-2-23.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "MBProgressHUDManager.h"

@implementation MBProgressHUDManager

+(void)showCenterTextWithTitle:(NSString *)title inView:(UIView *)view
{
    [MBProgressHUDManager hideMBProgressInView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

+ (void)showTextWithTitle:(NSString *)title inView:(UIView *)view {
    //CGFloat offsetY = [view isKindOfClass:[UIWindow class]] ? 94:74;
    CGFloat offsetY=30;
    if(view.height>=kScreenSize.height)
        offsetY=94;
    [MBProgressHUDManager hideMBProgressInView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    UIFont *font=[UIFont systemFontOfSize:13.0];
    NSDictionary *attr=[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    if([title sizeWithAttributes:attr].width>169)
        font=[UIFont systemFontOfSize:10.0];
    hud.labelFont = font;
    hud.labelText = title;
    hud.yOffset = -view.height/2 + offsetY;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

+ (void)showTextWithTitle:(NSString *)title inView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completion {
    //CGFloat offsetY = [view isKindOfClass:[UIWindow class]] ?  94:74;
    CGFloat offsetY=30;
    if(view.height>=kScreenSize.height)
        offsetY=94;
    [MBProgressHUDManager hideMBProgressInView:view];
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.yOffset = -view.height/2 + offsetY;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES whileExecutingBlock:nil completionBlock:completion];
}

+ (void)showIndicatorWithTitle:(NSString *)title inView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = title;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
}

+(void)showSuccessWithTitle:(NSString *)title inView:(UIView *)view
{
    [MBProgressHUDManager hideMBProgressInView:view];
    
    UIImageView *iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gou"]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView=iv;
    hud.labelText = title;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

+(void)showWrongWithTitle:(NSString *)title inView:(UIView *)view
{
    [MBProgressHUDManager hideMBProgressInView:view];
    
    UIImageView *iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wrong"]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView=iv;
    hud.labelText = title;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

+ (void)hideMBProgressInView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:NO];
}

@end
