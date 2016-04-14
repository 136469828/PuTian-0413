//
//  ChatWebView.m
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "ChatWebView.h"

@implementation ChatWebView

-(void)activityControl:(NSString *)cmd
{
    if([cmd isEqualToString:@"1"])
    {
        if(activity)
        {
            if(activity.hidden)
            {
                activity.hidden=NO;
            }
            if(!activity.isAnimating)
            {
                [activity startAnimating];
            }
            
            [activity.superview bringSubviewToFront:activity];
        }
    }
    else
    {
        if(activity)
        {
            if(activity.isAnimating)
            {
                [activity stopAnimating];
            }
            if(!activity.hidden)
            {
                activity.hidden=YES;
            }
        }
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if([_myDelegate respondsToSelector:@selector(chatWebView:shouldStartLoadWithRequest:navigationType:)])
    {
        return [_myDelegate chatWebView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if(_flagActivity)
    {
        [self activityControl:@"1"];
    }
    if([_myDelegate respondsToSelector:@selector(chatWebViewDidStartLoad:)])
    {
        [_myDelegate chatWebViewDidStartLoad:self];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *meta=nil;
    if(_disallowZoom)
    {
        meta=@"document.getElementsByName(\"viewport\")[0].content = \"initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no";
    }
    if(_isAutoWidth)
    {
        if(meta)
        {
            meta=[NSString stringWithFormat:@"%@,width=%f\"",meta,webView.frame.size.width];
        }
        else
        {
            meta=[NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f\"", webView.frame.size.width];
        }
    }
    if(meta)
    {
        [webView stringByEvaluatingJavaScriptFromString:meta];
    }
    if(_flagActivity)
    {
        [self activityControl:@"0"];
    }
    if([_myDelegate respondsToSelector:@selector(chatWebViewDidFinishLoad:)])
    {
        [_myDelegate chatWebViewDidFinishLoad:self];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(_flagActivity)
    {
        [self activityControl:@"0"];
    }
    if([_myDelegate respondsToSelector:@selector(chatWebView:didFailLoadWithError:)])
    {
        [_myDelegate chatWebView:self didFailLoadWithError:error];
    }
}

-(void)loadWebView
{
    [self loadHTMLString:@"" baseURL:nil];
    NSURL *url=[[NSURL alloc] initWithString:_strUrl];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [self loadRequest:request];
}

-(void)loadEmptyPage
{
    [self loadHTMLString:@"" baseURL:nil];
}

//加载
-(void)loadWithUrl:(NSString *)urlString
{
    if(urlString)
    {
        self.strUrl=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if(_flagActivity)
        {
            [self activityControl:@"1"];
        }
        [self loadWebView];
    }
}

//加载本地文件
-(void)loadWithFilePath:(NSString *)filePath
{
    NSURL *url=[NSURL fileURLWithPath:filePath];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
    [self loadRequest:request];
}

- (id)initWithFrame:(CGRect)frame andMyTarget:(id)target andUrl:(NSString *)urlString andBGAlpha:(float)alpha
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _myDelegate=target;
        _flagActivity=YES;
        
        if([urlString isNotNilOrEmptyString])
        {
            self.strUrl=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        [self loadUIWithBGAlpha:alpha];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andMyTarget:(id)target andUrl:(NSString *)urlString andActivityFlag:(BOOL)flagActivity
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _myDelegate=target;
        _flagActivity=flagActivity;
        
        if([urlString isNotNilOrEmptyString])
        {
            self.strUrl=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        [self loadUIWithBGAlpha:0];
    }
    return self;
}

-(void)loadUIWithBGAlpha:(float)alpha
{
    activity=nil;
    if(_flagActivity)
    {
        activity=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        activity.center=CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        activity.color=[UIColor blackColor];
        activity.hidden=YES;
        [self addSubview:activity];
    }
    
    self.delegate=self;
    
    if([_strUrl isNotNilOrEmptyString])
    {
        if(_flagActivity)
        {
            [self activityControl:@"1"];
        }
        [self loadWebView];
    }
}

-(void)removeFromSuperview
{
    [self stopLoading];
    [self loadHTMLString:@"" baseURL:nil];
    self.delegate=nil;
    self.strUrl=nil;
    
    [super removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
