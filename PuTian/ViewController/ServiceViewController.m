//
//  ServiceViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "ServiceViewController.h"
#import "ChatWebView.h"

#import "UserInfo.h"

@interface ServiceViewController ()<ChatWebViewDelegate>

@property (nonatomic,assign) BOOL isLoadView;
@property (nonatomic,assign) BOOL isLoadWebView;

@property (nonatomic,strong) ChatWebView *webView;

@end

@implementation ServiceViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.navigationItem.title=@"客服";
        self.tabBarItem.title=@"客服";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_icon_service"];
    }
    return self;
}

-(void)loadWebView
{
    if(self.isLoadView)
    {
        if(self.isLoadWebView)
        {
            if(![UserInfo sharedInstance].isLogin)
            {
                _webView.hidden=YES;
                self.isLoadWebView=NO;
                [MBProgressHUDManager showTextWithTitle:@"您还没有登录" inView:self.view];
            }
            else
            {
                if(![Common hasNetworkFlags])
                {
                    _webView.hidden=YES;
                    self.isLoadWebView=NO;
                    [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
                }
                else
                {
                    if(_webView && _webView.hidden)
                    {
                        _webView.hidden=NO;
                        NSString *urlString=[[NSString alloc] initWithFormat:@"%@/index.php?g=portal&m=index&a=chat&uid=%d",URL_Background,[UserInfo sharedInstance].userid];
                        [_webView loadWithUrl:urlString];
                    }
                }
            }
        }
        else
        {
            if([UserInfo sharedInstance].isLogin)
            {
                if([Common hasNetworkFlags])
                {
                    NSString *urlString=[[NSString alloc] initWithFormat:@"%@/index.php?g=portal&m=index&a=chat&uid=%d",URL_Background,[UserInfo sharedInstance].userid];
                    if(_webView==nil)
                    {
                        _webView=[[ChatWebView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.viewHeight) andMyTarget:self andUrl:urlString andActivityFlag:YES];
                        _webView.backgroundColor=[UIColor whiteColor];
                        [self.view addSubview:_webView];
                    }
                    else
                    {
                        _webView.hidden=NO;
                        [_webView loadWithUrl:urlString];
                    }
                }
                else
                {
                    [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
                }
            }
            else
            {
                [MBProgressHUDManager showTextWithTitle:@"您还没有登录" inView:self.view];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    if([UserInfo sharedInstance].isLogin)
    {
        if([Common hasNetworkFlags])
        {
            NSString *urlString=[[NSString alloc] initWithFormat:@"%@/index.php?g=portal&m=index&a=chat&uid=%d&rnd=123",URL_Background,[UserInfo sharedInstance].userid];
            _webView=[[ChatWebView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.viewHeight) andMyTarget:self andUrl:urlString andActivityFlag:YES];
            _webView.backgroundColor=[UIColor whiteColor];
            [self.view addSubview:_webView];
        }
        else
        {
            [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
        }
    }
    else
    {
        [MBProgressHUDManager showTextWithTitle:@"您还没有登录" inView:self.view];
    }
    
    self.isLoadView=YES;
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

#pragma mark - ChatWebViewDelegate
-(void)chatWebViewDidFinishLoad:(UIWebView *)webView
{
    self.isLoadWebView=YES;
}

@end
