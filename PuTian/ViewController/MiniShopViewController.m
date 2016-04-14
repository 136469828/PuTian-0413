//
//  MiniShopViewController.m
//  PuTian
//
//  Created by admin on 16/4/12.
//  Copyright © 2016年 guofeng. All rights reserved.
//

#import "MiniShopViewController.h"
#import "MazuCell.h"
#import "PullToRefreshTableView.h"
#import "ArticleDetailViewController.h"
#import "PTWebViewController.h"

//#import "MeishiInfoList.h"
#import "MiniShopList.h"
#import "UserInfo.h"
@interface MiniShopViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) PullToRefreshTableView *tableView;

@property (nonatomic,strong) MiniShopList *infoList;

@property (nonatomic,strong) UITextField *txtSearch;
@end

@implementation MiniShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    /*
     
     */
    self.view.backgroundColor=[UIColor whiteColor];
    
    _tableView=[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, self.marginTop+1, self.view.width, self.view.height-self.marginTop-1)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameMiniShop object:nil];
    
    _infoList=[[MiniShopList alloc] init];
//    _infoList.termId = self.term_id;
    _infoList.notificationName=kNotificationNameMiniShop;
    _infoList.uid=[UserInfo sharedInstance].userid;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^
                   {
                       [NSThread sleepForTimeInterval:0.1];
                       dispatch_sync(dispatch_get_main_queue(), ^
                                     {
                                         [_tableView showLoading];
                                         [_infoList loadDataWithSlideType:SlideTypeNormal];
                                     });
                   });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_infoList disposeRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameMiniShop object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameMiniShop])
    {
        NSDictionary *userInfo=notification.userInfo;
        BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
        SlideType slideType=(SlideType)[[userInfo objectForKey:kNotificationSlideTypeKey] integerValue];
        BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
        NSInteger requestCount=[[userInfo objectForKey:kNotificationContentKey] integerValue];
        
        BOOL isLoadAll=NO;
        if(succeed)
        {
            if(requestCount>0)
            {
                [self insertRowsWithCount:requestCount andSlideType:slideType];
                
                NSInteger pageIndex=[[userInfo objectForKey:kNotificationPageIndexKey] integerValue];
                if(pageIndex==_infoList.pageCount)
                {
                    isLoadAll=YES;
                    [_tableView didAllLoaded];
                }
            }
            else
            {
                if(slideType==SlideTypeDown || slideType==SlideTypeNormal)
                {
                    [_tableView reloadData];
                }
            }
        }
        else
        {
            if(hasNetworkFlags)
                [MBProgressHUDManager showTextWithTitle:@"获取数据失败了" inView:self.view];
            else
                [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
        }
        
        if(!isLoadAll)
            [_tableView restoreState];
    }
}

-(void)insertRowsWithCount:(NSInteger)count andSlideType:(SlideType)slideType
{
    if(_infoList.list && _infoList.list.count>=count)
    {
        if(slideType==SlideTypeNormal || slideType==SlideTypeDown)
        {
            [_tableView reloadData];
        }
        else
        {
            NSMutableArray *arrIndexPath=[[NSMutableArray alloc] init];
            NSInteger listCount=_infoList.list.count;
            for(int i=listCount-count;i<listCount;i++)
            {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                [arrIndexPath addObject:indexPath];
            }
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:arrIndexPath withRowAnimation:UITableViewRowAnimationNone];
            [_tableView endUpdates];
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

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView tableViewDidDragging];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    SlideType slideType = (SlideType)[_tableView tableViewDidEndDragging];
    
    //  slideType用来判断执行的拖动是下拉还是上拖，如果数据正在加载，则返回DO_NOTHING
    if (slideType != SlideTypeNormal)
    {
        [_infoList loadDataWithSlideType:slideType];
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MazuCellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_infoList.list.count>indexPath.row)
    {
        ArticleInfo *info=[_infoList.list objectAtIndex:indexPath.row];
//        ArticleDetailViewController *articleDetailVC=[[ArticleDetailViewController alloc] init];
//        articleDetailVC.term_id=2;
//        articleDetailVC.articleInfo=info;
//        articleDetailVC.navigationItem.title=info.title;
//        [self.navigationController pushViewController:articleDetailVC animated:YES];
        
        PTWebViewController *webView = [[PTWebViewController alloc] init];
        webView.urlString =info.urlString;
        webView.title = info.title;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoList?_infoList.list.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *localInfoCellIdentifier=@"localInfoCellIdentifier";
    MazuCell *cell=[tableView dequeueReusableCellWithIdentifier:localInfoCellIdentifier];
    if(cell==nil)
    {
        cell=[[MazuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:localInfoCellIdentifier frame:CGRectMake(0, 0, tableView.width, MazuCellHeight)];
    }
    if(_infoList.list.count>indexPath.row)
    {
        ArticleInfo *info=[_infoList.list objectAtIndex:indexPath.row];
        //[cell setShowImage:[UIImage imageNamed:@"index_ad1.jpg"]];
        [cell setShowImageUrl:info.imageUrl];
        [cell setTitle:info.title];
        [cell setIntroduce:info.excerpt];
        
    }
    
    return cell;
}

@end
