//
//  PTWebViewController.h
//  PuTian
//
//  Created by guofeng on 15/9/11.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class PTWebViewController,MyWebView;

@protocol PTWebViewDelegate <NSObject>

@optional
-(void)webViewControllerViewDidLoad:(PTWebViewController *)controller;
-(void)webViewControllerRequestDidFinished:(PTWebViewController *)controller;
-(void)webViewControllerViewDidScroll:(PTWebViewController *)controller;

@end

@interface PTWebViewController : BaseViewController

@property (nonatomic,readonly) MyWebView *webView;

@property (nonatomic,assign) id<PTWebViewDelegate> delegate;

@property (nonatomic,strong) NSString *urlString;

@property (nonatomic,assign) id object;

@end
