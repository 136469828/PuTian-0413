//
//  PTWebViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/11.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "PTWebViewController.h"
#import "MyWebView.h"

@interface PTWebViewController ()<MyWebViewDelegate>



@end

@implementation PTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    _webView=[[MyWebView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.viewHeightWhenTabBarHided) andMyTarget:self andUrl:_urlString andActivityFlag:YES];
    _webView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MyWebViewDelegate
-(void)webViewDidFinishLoad:(MyWebView *)webView
{
    if([_delegate respondsToSelector:@selector(webViewControllerRequestDidFinished:)])
    {
        [_delegate webViewControllerRequestDidFinished:self];
    }
}
-(void)webViewDidScroll:(MyWebView *)webView
{
    if([_delegate respondsToSelector:@selector(webViewControllerViewDidScroll:)])
    {
        [_delegate webViewControllerViewDidScroll:self];
    }
}

@end
