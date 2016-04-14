//
//  WebViewBottomBar.h
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WebViewBottomBarHeight 40.0

@class WebViewBottomBar;

@protocol WebViewBottomBarDelegate <NSObject>

@optional
-(void)webViewBottomBarDidClickComment:(WebViewBottomBar *)bar;
-(void)webViewBottomBarDidClickShowComment:(WebViewBottomBar *)bar;
-(void)webViewBottomBarDidClickShowShare:(WebViewBottomBar *)bar;
-(void)webViewBottomBarDidClickCollect:(WebViewBottomBar *)bar;

@end

@interface WebViewBottomBar : UIView

@property (nonatomic,assign) id<WebViewBottomBarDelegate> delegate;

/** 是否已收藏 */
@property (nonatomic,assign) BOOL isCollect;

@end
