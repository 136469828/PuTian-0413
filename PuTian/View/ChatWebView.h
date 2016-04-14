//
//  ChatWebView.h
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatWebView;

@protocol ChatWebViewDelegate <NSObject>

@optional
-(void)chatWebViewDidStartLoad:(ChatWebView *)webView;
-(void)chatWebViewDidFinishLoad:(ChatWebView *)webView;
-(void)chatWebViewDidScroll:(ChatWebView *)webView;
-(void)chatWebView:(ChatWebView *)webView didFailLoadWithError:(NSError *)error;
-(BOOL)chatWebView:(ChatWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

@interface ChatWebView : UIWebView<UIWebViewDelegate>
{
    BOOL _flagActivity;
    UIActivityIndicatorView *activity;
}

@property (nonatomic,assign) id<ChatWebViewDelegate> myDelegate;
@property (nonatomic,strong) NSString *strUrl;
@property (nonatomic,assign) BOOL isAutoWidth;
@property (nonatomic,assign) BOOL disallowZoom;

- (id)initWithFrame:(CGRect)frame andMyTarget:(id)target andUrl:(NSString *)urlString andActivityFlag:(BOOL)flagActivity;
- (id)initWithFrame:(CGRect)frame andMyTarget:(id)target andUrl:(NSString *)urlString andBGAlpha:(float)alpha;

-(void)loadEmptyPage;
-(void)loadWithUrl:(NSString *)urlString;
-(void)loadWithFilePath:(NSString *)filePath;

@end
