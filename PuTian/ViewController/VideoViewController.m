//
//  VideoViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/16.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "VideoViewController.h"
#import "EScrollerView.h"
#import "MyWebView.h"
#import "PTWebViewController.h"
#import "MyWebButton.h"
#import "MyWebImage.h"
#import "VideoSearchViewController.h"
#import "ArticleCommentListViewController.h"
#import "WebViewBottomBar.h"
#import "VideoDetailViewController.h"

#import "AdvertInfoList.h"
#import "HotVideoInfoList.h"
#import "VideoChannelInfoList.h"
#import "CommentInfo.h"
#import "UserInfo.h"

@interface VideoViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,EScrollerViewDelegate,PTWebViewDelegate,WebViewBottomBarDelegate>

@property (nonatomic,strong) UITextField *txtSearch;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) EScrollerView *viewAD;
@property (nonatomic,strong) UIView *viewHot;
@property (nonatomic,strong) UIView *viewRandom;
@property (nonatomic,strong) UIView *viewChannel;

@property (nonatomic,strong) WebViewBottomBar *webViewBottomBar;

@property (nonatomic,strong) AdvertInfoList *adInfoList;
@property (nonatomic,strong) HotVideoInfoList *hotVideoList;
@property (nonatomic,strong) HotVideoInfoList *randomVideoList;
@property (nonatomic,strong) VideoChannelInfoList *channelList;

@property (nonatomic,weak) PTWebViewController *currentWebView;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"视频";
    
    UIView *searchView=[[UIView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, 32)];
    searchView.layer.borderColor=[UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    searchView.layer.borderWidth=1;
    searchView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:searchView];
    
    UIColor *color=[[UIColor alloc] initWithRed:254.0/255 green:153.0/255 blue:39.0/255 alpha:1.0];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(1, 1, 60, searchView.height-2)];
    lbl.backgroundColor=color;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.font=[UIFont systemFontOfSize:15.0];
    lbl.text=@"影视";
    [searchView addSubview:lbl];
    
    UIButton *btnSearch=[[UIButton alloc] initWithFrame:CGRectMake(searchView.width-35, (searchView.height-30)/2.0, 30, 30)];
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"offprice_btn_search"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(searchTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:btnSearch];
    
    _txtSearch=[[UITextField alloc] initWithFrame:CGRectMake(lbl.x+lbl.width+5, 0, btnSearch.x-lbl.x-lbl.width-10, searchView.height)];
    _txtSearch.placeholder=@"搜索关键字";
    _txtSearch.returnKeyType=UIReturnKeySearch;
    _txtSearch.delegate=self;
    _txtSearch.font=[UIFont systemFontOfSize:15.0];
    _txtSearch.autocorrectionType=UITextAutocorrectionTypeNo;
    [searchView addSubview:_txtSearch];
    
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, searchView.y+searchView.height+1, self.view.width, self.view.height-searchView.y-searchView.height-1)];
    [self.view addSubview:_scrollView];
    
    float adWidth=320*[Common ratioWidthScreenWidthTo320];
    float adHeight=134.152634*[Common ratioWidthScreenWidthTo320];
    _viewAD=[[EScrollerView alloc] initWithFrame:CGRectMake(0, 0, adWidth, adHeight) isShowTitle:YES];
    _viewAD.delegate=self;
    [_scrollView addSubview:_viewAD];
    
    [self initContainers];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameAdvertInfoList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameHotVideoInfoList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameVideoChannelInfoList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameVideoInfo object:nil];
    
    _adInfoList=[[AdvertInfoList alloc] init];
    _adInfoList.type=AdvertTypeVideo;
    _adInfoList.notificationName=kNotificationNameAdvertInfoList;
    [_adInfoList loadData];
    
    _hotVideoList=[[HotVideoInfoList alloc] init];
    _hotVideoList.notificationName=kNotificationNameHotVideoInfoList;
    _hotVideoList.type=0;
    _hotVideoList.uid=[UserInfo sharedInstance].userid;
    [_hotVideoList loadData];
    
    _randomVideoList=[[HotVideoInfoList alloc] init];
    _randomVideoList.notificationName=kNotificationNameHotVideoInfoList;
    _randomVideoList.type=1;
    _randomVideoList.uid=[UserInfo sharedInstance].userid;
    [_randomVideoList loadData];
    
    _channelList=[[VideoChannelInfoList alloc] init];
    _channelList.notificationName=kNotificationNameVideoChannelInfoList;
    [_channelList loadData];
}

-(void)initContainers
{
    _viewHot=[[UIView alloc] initWithFrame:CGRectMake(0, _viewAD.y+_viewAD.height, _scrollView.width, 100)];
    [_scrollView addSubview:_viewHot];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
    lbl.font=[UIFont systemFontOfSize:15.0];
    lbl.text=@"今日焦点";
    [_viewHot addSubview:lbl];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, lbl.y+lbl.height+3, _viewHot.width, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [_viewHot addSubview:line];
    
    _viewRandom=[[UIView alloc] initWithFrame:CGRectMake(0, _viewHot.y+_viewHot.height, _scrollView.width, 100)];
    [_scrollView addSubview:_viewRandom];
    
    lbl=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
    lbl.font=[UIFont systemFontOfSize:15.0];
    lbl.text=@"随机视频";
    [_viewRandom addSubview:lbl];
    
    line=[[UIView alloc] initWithFrame:CGRectMake(0, lbl.y+lbl.height+3, _viewRandom.width, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [_viewRandom addSubview:line];
    
    _viewChannel=[[UIView alloc] initWithFrame:CGRectMake(0, _viewRandom.y+_viewRandom.height, _scrollView.width, 100)];
    [_scrollView addSubview:_viewChannel];
    
    lbl=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
    lbl.font=[UIFont systemFontOfSize:15.0];
    lbl.text=@"热门频道";
    [_viewChannel addSubview:lbl];
    
    line=[[UIView alloc] initWithFrame:CGRectMake(0, lbl.y+lbl.height+3, _viewChannel.width, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [_viewChannel addSubview:line];
    
    _scrollView.contentSize=CGSizeMake(_scrollView.width, _viewChannel.y+_viewChannel.height);
}
-(void)loadHotVideoView
{
    if(_hotVideoList.list.count>0)
    {
        float marginLeft=2,marginTop=10;
        float width=(_viewHot.width-marginLeft)/2.0;
        float height=width/2;
        float lblHeight=18,lblMarginTop=3;
        
        [_viewHot.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
        lbl.font=[UIFont systemFontOfSize:15.0];
        lbl.text=@"今日焦点";
        [_viewHot addSubview:lbl];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, lbl.y+lbl.height+3, _viewHot.width, 0.5)];
        line.backgroundColor=[UIColor lightGrayColor];
        [_viewHot addSubview:line];
        
        float top=line.y+line.height+3;
        MyWebButton *btn=nil;
        lbl=nil;
        for(int i=0;i<_hotVideoList.list.count;i++)
        {
            VideoInfo *info=[_hotVideoList.list objectAtIndex:i];
            btn=[[MyWebButton alloc] initWithFrame:CGRectMake((width+marginLeft)*(i%2), top+(height+marginTop+lblHeight*2+lblMarginTop*2)*(i/2), width, height)];
            btn.tag=i;
            btn.exclusiveTouch=YES;
            btn.clipsToBounds=YES;
            btn.imageView.contentMode=UIViewContentModeScaleAspectFill;
            [btn setImageWithUrl:info.thumbimg callback:nil];
            [btn addTarget:self action:@selector(hotVideoTouchUp:) forControlEvents:UIControlEventTouchUpInside];
            [_viewHot addSubview:btn];
            
            lbl=[[UILabel alloc] initWithFrame:CGRectMake(btn.x+10, btn.y+btn.height+lblMarginTop, width-10, lblHeight)];
            lbl.font=[UIFont systemFontOfSize:13.0];
            lbl.text=info.videoName;
            [_viewHot addSubview:lbl];
            
            if([info.title isNotNilOrEmptyString])
            {
                lbl=[[UILabel alloc] initWithFrame:CGRectMake(lbl.x, lbl.y+lbl.height+lblMarginTop, lbl.width, lblHeight)];
                lbl.font=[UIFont systemFontOfSize:11.0];
                lbl.text=info.title;
                lbl.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
                [_viewHot addSubview:lbl];
            }
        }
        
        line=[[UIView alloc] initWithFrame:CGRectMake(0, btn.y+btn.height+lblHeight*2+lblMarginTop*2+10, _viewHot.width, 8)];
        line.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0];
        [_viewHot addSubview:line];
        
        _viewHot.height=line.y+line.height;
        _viewRandom.y=_viewHot.y+_viewHot.height;
        _viewChannel.y=_viewRandom.y+_viewRandom.height;
        
        _scrollView.contentSize=CGSizeMake(_scrollView.width, _viewChannel.y+_viewChannel.height);
    }
}
-(void)loadRandomVideoView
{
    if(_randomVideoList.list.count>0)
    {
        float marginLeft=2,marginTop=10;
        float width=(_viewRandom.width-marginLeft)/2.0;
        float height=width/2;
        float lblHeight=18,lblMarginTop=3;
        
        [_viewRandom.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
        lbl.font=[UIFont systemFontOfSize:15.0];
        lbl.text=@"随机视频";
        [_viewRandom addSubview:lbl];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, lbl.y+lbl.height+3, _viewRandom.width, 0.5)];
        line.backgroundColor=[UIColor lightGrayColor];
        [_viewRandom addSubview:line];
        
        float top=line.y+line.height+3;
        MyWebButton *btn=nil;
        lbl=nil;
        for(int i=0;i<_randomVideoList.list.count;i++)
        {
            VideoInfo *info=[_randomVideoList.list objectAtIndex:i];
            btn=[[MyWebButton alloc] initWithFrame:CGRectMake((width+marginLeft)*(i%2), top+(height+marginTop+lblHeight*2+lblMarginTop*2)*(i/2), width, height)];
            btn.tag=i;
            btn.exclusiveTouch=YES;
            btn.clipsToBounds=YES;
            btn.imageView.contentMode=UIViewContentModeScaleAspectFill;
            [btn setImageWithUrl:info.thumbimg callback:nil];
            [btn addTarget:self action:@selector(randomVideoTouchUp:) forControlEvents:UIControlEventTouchUpInside];
            [_viewRandom addSubview:btn];
            
            lbl=[[UILabel alloc] initWithFrame:CGRectMake(btn.x+10, btn.y+btn.height+lblMarginTop, width-10, lblHeight)];
            lbl.font=[UIFont systemFontOfSize:13.0];
            lbl.text=info.videoName;
            [_viewRandom addSubview:lbl];
            
            if([info.title isNotNilOrEmptyString])
            {
                lbl=[[UILabel alloc] initWithFrame:CGRectMake(lbl.x, lbl.y+lbl.height+lblMarginTop, lbl.width, lblHeight)];
                lbl.font=[UIFont systemFontOfSize:11.0];
                lbl.text=info.title;
                lbl.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
                [_viewRandom addSubview:lbl];
            }
        }
        
        line=[[UIView alloc] initWithFrame:CGRectMake(0, btn.y+btn.height+lblHeight*2+lblMarginTop*2+10, _viewHot.width, 8)];
        line.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0];
        [_viewRandom addSubview:line];
        
        _viewRandom.height=line.y+line.height;
        _viewChannel.y=_viewRandom.y+_viewRandom.height;
        
        _scrollView.contentSize=CGSizeMake(_scrollView.width, _viewChannel.y+_viewChannel.height);
    }
}
-(void)loadChannelView
{
    if(_channelList.list.count>0)
    {
        float top=0;
        float left=25;
        float iconWidth=40;
        float iconMarginLeft=20;
        float iconEdge=5;
        int col=4;
        [self calcIconCountWithTotalWidth:_scrollView.width-2*left width:iconWidth baseMarginLeft:(320-4*iconWidth-2*left)/3.0 count:&col marginLeft:&iconMarginLeft];
        
        float btnWidth=iconWidth+iconMarginLeft;
        float lblWidth=btnWidth,lblHeight=18,lblMarginTop=5;
        float btnHeight=iconWidth+lblMarginTop+lblHeight;
        float btnMarginTop=15;
        
        [_viewChannel.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 20)];
        lbl.font=[UIFont systemFontOfSize:15.0];
        lbl.text=@"热门频道";
        [_viewChannel addSubview:lbl];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, lbl.y+lbl.height+3, _viewChannel.width, 0.5)];
        line.backgroundColor=[UIColor lightGrayColor];
        [_viewChannel addSubview:line];
        
        top=line.y+line.height+10;
        UIButton *btn=nil;
        for(int i=0;i<_channelList.list.count;i++)
        {
            VideoChannelInfo *info=[_channelList.list objectAtIndex:i];
            btn=[[UIButton alloc] initWithFrame:CGRectMake(left-iconMarginLeft/2+btnWidth*(i%col), top+(btnHeight+btnMarginTop)*(i/col), btnWidth, btnHeight)];
            btn.tag=i;
            btn.exclusiveTouch=YES;
            btn.clipsToBounds=YES;
            [btn addTarget:self action:@selector(channelTouchUp:) forControlEvents:UIControlEventTouchUpInside];
            [_viewChannel addSubview:btn];
            
            MyWebImage *webImg=[[MyWebImage alloc] initWithFrame:CGRectMake((btnWidth-iconWidth)/2.0+iconEdge, iconEdge, iconWidth-2*iconEdge, iconWidth-2*iconEdge)];
            webImg.contentMode=UIViewContentModeScaleAspectFit;
            [webImg setImageWithUrl:info.picurl callback:nil];
            [btn addSubview:webImg];
            
            lbl=[[UILabel alloc] initWithFrame:CGRectMake(0, webImg.y+webImg.height+lblMarginTop, lblWidth, lblHeight)];
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.font=[UIFont systemFontOfSize:13.0];
            lbl.text=info.channelName;
            [btn addSubview:lbl];
        }
        
        _viewChannel.height=btn.y+btn.height+btnMarginTop;
        _scrollView.contentSize=CGSizeMake(_scrollView.width, _viewChannel.y+_viewChannel.height);
    }
}
-(void)calcIconCountWithTotalWidth:(float)totalWidth width:(float)width baseMarginLeft:(float)marginLeft count:(int *)pcount marginLeft:(float *)pmargin
{
    int maxCount=totalWidth/width;
    for(int i=maxCount;i>0;i--)
    {
        float tmpmargin=marginLeft;
        if(i==1)
            tmpmargin=totalWidth-width;
        else
            tmpmargin=(totalWidth-i*width)/(i-1);
        
        if(tmpmargin>=marginLeft)
        {
            if(pcount)*pcount=i;
            if(pmargin)*pmargin=tmpmargin;
            break;
        }
    }
}

-(void)searchTouchUp
{
    NSString *keywords=[_txtSearch.text trim];
    if(![keywords isNotNilOrEmptyString])
    {
        [MBProgressHUDManager showTextWithTitle:@"请输入关键字" inView:self.view];
        return;
    }
    
    VideoSearchViewController *searchVC=[[VideoSearchViewController alloc] init];
    searchVC.keywords=keywords;
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)hotVideoTouchUp:(MyWebButton *)button
{
    if(_hotVideoList.list.count>button.tag)
    {
        VideoInfo *info=[_hotVideoList.list objectAtIndex:button.tag];
        if([info.linkurl isNotNilOrEmptyString])
        {
            VideoDetailViewController *videoDetailVC=[[VideoDetailViewController alloc] init];
            videoDetailVC.videoInfo=info;
            videoDetailVC.navigationItem.title=info.videoName;
            [self.navigationController pushViewController:videoDetailVC animated:YES];
        }
    }
}
-(void)randomVideoTouchUp:(MyWebButton *)button
{
    if(_randomVideoList.list.count>button.tag)
    {
        VideoInfo *info=[_randomVideoList.list objectAtIndex:button.tag];
        if([info.linkurl isNotNilOrEmptyString])
        {
            VideoDetailViewController *videoDetailVC=[[VideoDetailViewController alloc] init];
            videoDetailVC.videoInfo=info;
            videoDetailVC.navigationItem.title=info.videoName;
            [self.navigationController pushViewController:videoDetailVC animated:YES];
        }
    }
}
-(void)channelTouchUp:(UIButton *)button
{
    if(_channelList.list.count>button.tag)
    {
        VideoChannelInfo *info=[_channelList.list objectAtIndex:button.tag];
        if([info.channelid isNotNilOrEmptyString])
        {
            VideoSearchViewController *searchVC=[[VideoSearchViewController alloc] init];
            searchVC.channelid=info.channelid;
            [self.navigationController pushViewController:searchVC animated:YES];
        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_adInfoList disposeRequest];
    [_hotVideoList disposeRequest];
    [_channelList disposeRequest];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameAdvertInfoList object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameHotVideoInfoList object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameVideoChannelInfoList object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameVideoInfo object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameAdvertInfoList])
    {
        if(notification.object==_adInfoList)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            if(succeed)
            {
//                [_viewAD fillAdvertData:_adInfoList];
                [_viewAD fillAdvertData:_adInfoList ImgStr:nil];
                
                [_viewAD startAutoPlayWithInterval:3];
            }
            else
            {
                if(!hasNetworkFlags)
                    [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
            }
        }
    }
    else if([notification.name isEqualToString:kNotificationNameHotVideoInfoList])
    {
        if(notification.object==_hotVideoList)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            if(succeed)
            {
                [self loadHotVideoView];
            }
        }
        else if(notification.object==_randomVideoList)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            if(succeed)
            {
                [self loadRandomVideoView];
            }
        }
    }
    else if([notification.name isEqualToString:kNotificationNameVideoChannelInfoList])
    {
        if(notification.object==_channelList)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            if(succeed)
            {
                [self loadChannelView];
            }
        }
    }
    else if([notification.name isEqualToString:kNotificationNameVideoInfo])
    {
        if(notification.object==self.currentWebView.object)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            NSInteger nType=[[userInfo objectForKey:kNotificationTypeKey] integerValue];
            
            if(succeed)
            {
                switch(nType)
                {
                    case 2: //评论
//                        [MBProgressHUDManager hideMBProgressInView:self.view];
//                        if(_commentView)
//                        {
//                            [_commentView removeFromSuperview];
//                            self.commentView=nil;
//                        }
//                        [MBProgressHUDManager showSuccessWithTitle:@"发布成功" inView:self.view];
                        
                        
                        break;
                    case 3: //收藏
                    {
                        NSString *msg=@"";
                        VideoInfo *model=self.currentWebView.object;
                        if(model.isCollect)
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
                        //[MBProgressHUDManager hideMBProgressInView:self.view];
                        break;
                    case 3:
                    {
                        NSString *msg=@"";
                        VideoInfo *model=self.currentWebView.object;
                        if(model.isCollect)
                        {
                            msg=@"取消成功";
                        }
                        else
                        {
                            msg=@"收藏成功";
                        }
                        [MBProgressHUDManager showWrongWithTitle:msg inView:self.view];
                    }
                        break;
                }
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - EScrollerViewDelegate
-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    if(_adInfoList.list.count>index-1)
    {
        AdvertInfo *info=[_adInfoList.list objectAtIndex:index-1];
        if([info.ad_clickurl isNotNilOrEmptyString])
        {
            PTWebViewController *webVC=[[PTWebViewController alloc] init];
            webVC.urlString=info.ad_clickurl;
            webVC.navigationItem.title=info.ad_name;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

#pragma mark - PTWebViewDelegate
-(void)webViewControllerRequestDidFinished:(PTWebViewController *)controller
{
    [self initWebViewBottomBar];
    
    CGSize contentSize=controller.webView.scrollView.contentSize;
    controller.webView.scrollView.contentSize=CGSizeMake(contentSize.width, contentSize.height+_webViewBottomBar.height+10);
    
    self.currentWebView=controller;
    
    _webViewBottomBar.y=controller.webView.height-_webViewBottomBar.height;
    [controller.webView addSubview:_webViewBottomBar];
}
-(void)webViewControllerViewDidScroll:(PTWebViewController *)controller
{
    if(_webViewBottomBar)
    {
        if(_webViewBottomBar.superview==controller.webView || _webViewBottomBar.superview==controller.webView.scrollView)
        {
            float tmp=controller.webView.scrollView.contentOffset.y+controller.webView.scrollView.height;
            if(tmp>=controller.webView.scrollView.contentSize.height)
            {
                if(_webViewBottomBar.superview!=controller.webView.scrollView)
                {
                    [_webViewBottomBar removeFromSuperview];
                    
                    _webViewBottomBar.y=controller.webView.scrollView.contentSize.height-_webViewBottomBar.height;
                    [controller.webView.scrollView addSubview:_webViewBottomBar];
                }
            }
            else
            {
                if(_webViewBottomBar.superview==controller.webView.scrollView)
                {
                    [_webViewBottomBar removeFromSuperview];
                    
                    _webViewBottomBar.y=controller.webView.height-_webViewBottomBar.height;
                    [controller.webView addSubview:_webViewBottomBar];
                }
            }
        }
    }
}

#pragma mark - WebViewBottomBarDelegate
-(void)webViewBottomBarDidClickComment:(WebViewBottomBar *)bar
{
    if(![UserInfo sharedInstance].isLogin)
    {
        [self pushLoginViewController];
        return;
    }
    
    VideoInfo *model=self.currentWebView.object;
    ArticleCommentListViewController *commentListVC=[[ArticleCommentListViewController alloc] init];
    commentListVC.object=model;
    commentListVC.post_id=model.videoid;
    commentListVC.commentType=3;
    commentListVC.isWriteComment=YES;
    [self.navigationController pushViewController:commentListVC animated:YES];
}
-(void)webViewBottomBarDidClickShowComment:(WebViewBottomBar *)bar
{
    VideoInfo *model=self.currentWebView.object;
    ArticleCommentListViewController *commentListVC=[[ArticleCommentListViewController alloc] init];
    commentListVC.object=model;
    commentListVC.post_id=model.videoid;
    commentListVC.commentType=3;
    commentListVC.isWriteComment=NO;
    [self.navigationController pushViewController:commentListVC animated:YES];
}
-(void)webViewBottomBarDidClickCollect:(WebViewBottomBar *)bar
{
    if(![UserInfo sharedInstance].isLogin)
    {
        [self pushLoginViewController];
        return;
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *keywords=[_txtSearch.text trim];
    if(![keywords isNotNilOrEmptyString])
    {
        [MBProgressHUDManager showTextWithTitle:@"请输入关键字" inView:self.view];
        return YES;
    }
    [textField resignFirstResponder];
    
    VideoSearchViewController *searchVC=[[VideoSearchViewController alloc] init];
    searchVC.keywords=keywords;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(_txtSearch.isFirstResponder)
    {
        [_txtSearch resignFirstResponder];
        return YES;
    }
    return NO;
}

@end
