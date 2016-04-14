//
//  ArticleDetailViewController.m
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "MyWebView.h"
#import "ArticleCommentListViewController.h"
#import "WebViewBottomBar.h"

#import "ArticleInfo.h"
#import "CommentInfo.h"
#import "UserInfo.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>

#define disCountDetailURL(atricleid)  [NSString stringWithFormat:@"http://putian.meidp.com/index.php?g=portal&m=index&a=article&id=%d",atricleid]

@interface ArticleDetailViewController ()<MyWebViewDelegate,WebViewBottomBarDelegate>

@property (nonatomic,strong) MyWebView *webView;

@property (nonatomic,strong) WebViewBottomBar *webViewBottomBar;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;



@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSString *urlString=[[NSString alloc] initWithFormat:URL_Article,_articleInfo.articleid];
//    NSString *urlString = @"http://www.youku.com/";
    
    _webView=[[MyWebView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.viewHeightWhenTabBarHided) andMyTarget:self andUrl:urlString andActivityFlag:YES];
    _webView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_webView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameArticleInfo object:nil];
    
    if(_articleInfo)
    {
        _articleInfo.uid=[UserInfo sharedInstance].userid;
        [_articleInfo loadData];
    }
}

-(void)initWebViewBottomBar
{
    if(_webViewBottomBar==nil)
    {
        _webViewBottomBar=[[WebViewBottomBar alloc] initWithFrame:CGRectMake(0, self.view.height-40, self.view.width, 40)];
        _webViewBottomBar.delegate=self;
        [self.view addSubview:_webViewBottomBar];
    }
    else
    {
        if(_webViewBottomBar.superview!=nil)
        {
            [_webViewBottomBar removeFromSuperview];
            _webViewBottomBar.isCollect=NO;
        }
    }
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameArticleInfo])
    {
        if(notification.object==_articleInfo)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            id content=[userInfo objectForKey:kNotificationContentKey];
            NSString *message=[userInfo objectForKey:kNotificationMessageKey];
            NSInteger nType=[[userInfo objectForKey:kNotificationTypeKey] integerValue];
            
            if(succeed)
            {
                switch(nType)
                {
                    case 1:
                        if(_webViewBottomBar)
                        {
                            if(_articleInfo.isCollect)_webViewBottomBar.isCollect=YES;
                        }
                        break;
                    case 2: //评论
                    {
                        if(content!=nil)
                        {
                            NSString *jsFunc=[[NSString alloc] initWithFormat:@"pageFrame.insert(%d);",[content integerValue]];
                            [_webView stringByEvaluatingJavaScriptFromString:jsFunc];
                        }
                    }
                        break;
                    case 3: //收藏
                    {
                        NSString *msg=@"";
                        if(_articleInfo.isCollect)
                        {
                            msg=@"收藏成功";
                            _webViewBottomBar.isCollect=YES;
                        }
                        else
                        {
                            msg=@"取消成功";
                            _webViewBottomBar.isCollect=NO;
                        }
                        [MBProgressHUDManager showSuccessWithTitle:msg inView:self.view];
                    }
                        break;
                }
            }
            else
            {
                switch(nType)
                {
                    case 2:
                        
                        break;
                    case 3:
                    {
                        if([message isNotNilOrEmptyString] && [message rangeOfString:@"已收藏"].location!=NSNotFound)
                        {
                            _articleInfo.isCollect=YES;
                            _webViewBottomBar.isCollect=YES;
                            [MBProgressHUDManager showSuccessWithTitle:@"您已收藏" inView:self.view];
                        }
                        else
                        {
                            if(hasNetworkFlags)
                                [MBProgressHUDManager showWrongWithTitle:@"操作失败" inView:self.view];
                            else
                                [MBProgressHUDManager showWrongWithTitle:@"没有网络连接" inView:self.view];
                        }
                    }
                        break;
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    if(_articleInfo)
    {
        [_articleInfo disposeRequest];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameArticleInfo object:nil];
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
    [self initWebViewBottomBar];
    
    CGSize contentSize=webView.scrollView.contentSize;
    webView.scrollView.contentSize=CGSizeMake(contentSize.width, contentSize.height+_webViewBottomBar.height);
    
    _webViewBottomBar.y=webView.height-_webViewBottomBar.height;
    [webView addSubview:_webViewBottomBar];
    
    if(_articleInfo.isCollect)
        _webViewBottomBar.isCollect=YES;
}
-(void)webViewDidScroll:(MyWebView *)webView
{
//    if(_webViewBottomBar)
//    {
//        if(_webViewBottomBar.superview==webView || _webViewBottomBar.superview==webView.scrollView)
//        {
//            float tmp=webView.scrollView.contentOffset.y+webView.scrollView.height;
//            if(tmp>=webView.scrollView.contentSize.height)
//            {
//                if(_webViewBottomBar.superview!=webView.scrollView)
//                {
//                    [_webViewBottomBar removeFromSuperview];
//                    
//                    _webViewBottomBar.y=webView.scrollView.contentSize.height-_webViewBottomBar.height;
//                    [webView.scrollView addSubview:_webViewBottomBar];
//                }
//            }
//            else
//            {
//                if(_webViewBottomBar.superview==webView.scrollView)
//                {
//                    [_webViewBottomBar removeFromSuperview];
//                    
//                    _webViewBottomBar.y=webView.height-_webViewBottomBar.height;
//                    [webView addSubview:_webViewBottomBar];
//                }
//            }
//        }
//    }
}

#pragma mark - WebViewBottomBarDelegate
-(void)webViewBottomBarDidClickComment:(WebViewBottomBar *)bar
{
    if(![UserInfo sharedInstance].isLogin)
    {
        [self pushLoginViewController];
        return;
    }
    
    ArticleCommentListViewController *commentListVC=[[ArticleCommentListViewController alloc] init];
    commentListVC.object=_articleInfo;
    commentListVC.post_id=_articleInfo.articleid;
    commentListVC.commentType=1;
    commentListVC.isWriteComment=YES;
    [self.navigationController pushViewController:commentListVC animated:YES];
}
-(void)webViewBottomBarDidClickShowComment:(WebViewBottomBar *)bar
{
    ArticleCommentListViewController *commentListVC=[[ArticleCommentListViewController alloc] init];
    commentListVC.object=_articleInfo;
    commentListVC.post_id=_articleInfo.articleid;
    commentListVC.commentType=1;
    commentListVC.isWriteComment=NO;
    [self.navigationController pushViewController:commentListVC animated:YES];
}

/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}

-(void)webViewBottomBarDidClickShowShare:(WebViewBottomBar *)bar
{
    NSLog(@"url :%@",disCountDetailURL(_articleInfo.articleid));
    
    
    NSArray* imageArray = @[_articleInfo.imageUrl];
    //构造分享内容 _articleInfo.title
    NSMutableDictionary *shareParams=[NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:_articleInfo.excerpt
                                     images:imageArray
                                        url:[NSURL URLWithString:disCountDetailURL(_articleInfo.articleid)]
                                      title:_articleInfo.title
                                       type:SSDKContentTypeAuto];
    

    
    NSLog(@"%@ %@",_articleInfo.title,[NSURL URLWithString:disCountDetailURL(_articleInfo.articleid)]);
    __weak ArticleDetailViewController *theController = self;
    
    
    [ShareSDK showShareActionSheet:bar
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state,
                                     SSDKPlatformType platformType,
                                     NSDictionary *userData,
                                     SSDKContentEntity *contentEntity,
                                     NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           //                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                           //                                                                               message:nil
                           //                                                                              delegate:nil
                           //                                                                     cancelButtonTitle:@"确定"
                           //                                                                     otherButtonTitles:nil];
                           //                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
                       [theController showLoadingView:NO];
                   }
                   
               }];
    
    

}
-(void)webViewBottomBarDidClickCollect:(WebViewBottomBar *)bar
{
    if(![UserInfo sharedInstance].isLogin)
    {
        [self pushLoginViewController];
        return;
    }
    
    [_articleInfo collect:!_articleInfo.isCollect];
}

@end
