//
//  VideoSearchViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/18.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "VideoSearchViewController.h"
#import "PullToRefreshTableView.h"
#import "VideoCell.h"
#import "VideoDetailViewController.h"

#import "VideoInfoList.h"

@interface VideoSearchViewController ()<UITableViewDataSource,UITableViewDelegate,VideoCellDelegate>

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) PullToRefreshTableView *tableView;

@property (nonatomic,strong) VideoInfoList *infoList;

@end

@implementation VideoSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"视频";
    
    _cellHeight=self.view.width/4+57;
    
    _tableView=[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, self.marginTop+1, self.view.width, self.viewHeightWhenTabBarHided-1)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameVideoInfoList object:nil];
    
    _infoList=[[VideoInfoList alloc] init];
    _infoList.notificationName=kNotificationNameVideoInfoList;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^
                   {
                       [NSThread sleepForTimeInterval:0.1];
                       dispatch_sync(dispatch_get_main_queue(), ^
                                     {
                                         [_tableView showLoading];
                                         [_infoList loadDataWithSlideType:SlideTypeNormal keywords:_keywords channel:_channelid];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameVideoInfoList object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameVideoInfoList])
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
        [_infoList loadDataWithSlideType:slideType keywords:_keywords channel:_channelid];
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_infoList && _infoList.list.count>0)
        return (_infoList.list.count-1)/2+1;
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *searchVideoCellIdentifier=@"searchVideoCellIdentifier";
    VideoCell *cell=nil;
    if(tableView==_tableView)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:searchVideoCellIdentifier];
        if(cell==nil)
        {
            cell=[[VideoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:searchVideoCellIdentifier frame:CGRectMake(0, 0, tableView.width, _cellHeight)];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.delegate=self;
        }
        else
        {
            [cell clean];
        }
        
        
        if(_infoList && _infoList.list.count>indexPath.row*2)
        {
            VideoInfo *info=[_infoList.list objectAtIndex:indexPath.row*2];
            [cell setShowImage1Url:info.thumbimg index:indexPath.row*2];
            [cell setTitle1:info.videoName];
            [cell setIntroduce1:info.title];
            
            if(_infoList.list.count>indexPath.row*2+1)
            {
                info=[_infoList.list objectAtIndex:indexPath.row*2+1];
                [cell setShowImage2Url:info.thumbimg index:indexPath.row*2+1];
                [cell setTitle2:info.videoName];
                [cell setIntroduce2:info.title];
            }
        }
    }
    
    return cell;
}

#pragma mark - VideoCellDelegate
-(void)videoCell:(VideoCell *)cell didClickAtIndex:(NSInteger)index
{
    if(_infoList.list.count>index)
    {
        VideoInfo *info=[_infoList.list objectAtIndex:index];
        if([info.linkurl isNotNilOrEmptyString])
        {
            VideoDetailViewController *videoDetailVC=[[VideoDetailViewController alloc] init];
            videoDetailVC.videoInfo=info;
            videoDetailVC.navigationItem.title=info.videoName;
            [self.navigationController pushViewController:videoDetailVC animated:YES];
        }
    }
}

@end
