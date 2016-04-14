//
//  MyWebView.h
//  CollocationIPAD
//
//  Created by guofeng on 13-4-10.
//
//

#import <UIKit/UIKit.h>

@class MyWebView;

@protocol MyWebViewDelegate <NSObject>

@optional
-(void)webViewDidStartLoad:(MyWebView *)webView;
-(void)webViewDidFinishLoad:(MyWebView *)webView;
-(void)webViewDidScroll:(MyWebView *)webView;
-(void)webView:(MyWebView *)webView didFailLoadWithError:(NSError *)error;
-(BOOL)webView:(MyWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

@interface MyWebView : UIWebView<UIWebViewDelegate>
{
    BOOL _flagActivity;
    UIActivityIndicatorView *activity;
}

@property (nonatomic,assign) id<MyWebViewDelegate> myDelegate;
@property (nonatomic,strong) NSString *strUrl;
@property (nonatomic,assign) BOOL isAutoWidth;
@property (nonatomic,assign) BOOL disallowZoom;

- (id)initWithFrame:(CGRect)frame andMyTarget:(id)target andUrl:(NSString *)urlString andActivityFlag:(BOOL)flagActivity;
- (id)initWithFrame:(CGRect)frame andMyTarget:(id)target andUrl:(NSString *)urlString andBGAlpha:(float)alpha;

-(void)loadEmptyPage;
-(void)loadWithUrl:(NSString *)urlString;
-(void)loadWithFilePath:(NSString *)filePath;

@end
