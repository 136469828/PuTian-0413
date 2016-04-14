//
//  CouponsListViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/19.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "CouponsListViewController.h"
#import "PullToRefreshTableView.h"
#import "OffPriceCell.h"
#import "OffPriceDetailViewController.h"

#import "UserInfo.h"
#import "CouponsList.h"

@interface CouponsListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) PullToRefreshTableView *tableView;

@property (nonatomic,strong) CouponsList *infoList;

@end

@implementation CouponsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"我的优惠券";
    
    _tableView=[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, self.marginTop+1, self.view.width, self.viewHeightWhenTabBarHided-1)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameCouponsList object:nil];
    
    _infoList=[[CouponsList alloc] init];
    _infoList.notificationName=kNotificationNameCouponsList;
    _infoList.userid=[UserInfo sharedInstance].userid;
    
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameCouponsList object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameCouponsList])
    {
        if(notification.object==_infoList)
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
    return OffPriceCellHeight;
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
        OffPriceInfo *info=[_infoList.list objectAtIndex:indexPath.row];
        
        OffPriceDetailViewController *detailVC=[[OffPriceDetailViewController alloc] init];
        detailVC.sender=2;
        detailVC.productid=info.productid;
        [self.navigationController pushViewController:detailVC animated:YES];
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
    static NSString *couponsCellIdentifier=@"couponsCellIdentifier";
    OffPriceCell *cell=nil;
    if(tableView==_tableView)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:couponsCellIdentifier];
        if(cell==nil)
        {
            cell=[[OffPriceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:couponsCellIdentifier frame:CGRectMake(0, 0, tableView.width, OffPriceCellHeight)];
            [cell setGradeVisible:NO];
        }
        if(_infoList.list.count>indexPath.row)
        {
            OffPriceInfo *info=[_infoList.list objectAtIndex:indexPath.row];
            [cell setShowImageUrl:info.imageUrl];
            [cell setTitle:info.title];
            [cell setIntroduce:info.introduce];
            [cell setDownloadCount:info.qty];
        }
    }
    
    return cell;
}

@end
