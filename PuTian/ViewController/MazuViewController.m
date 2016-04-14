//
//  MazuViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/9.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "MazuViewController.h"
#import "MazuCell.h"
#import "PullToRefreshTableView.h"
#import "ArticleDetailViewController.h"

#import "MazuInfoList.h"
#import "UserInfo.h"

@interface MazuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) PullToRefreshTableView *tableView;

@property (nonatomic,strong) MazuInfoList *infoList;

@end

@implementation MazuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.navigationItem.title=@"妈祖故乡";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    _tableView=[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, self.marginTop+1, self.view.width, self.view.height-self.marginTop-1)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];

    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameMazuInfoList object:nil];
    
    _infoList=[[MazuInfoList alloc] init];
    _infoList.notificationName=kNotificationNameMazuInfoList;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameMazuInfoList object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameMazuInfoList])
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
        ArticleDetailViewController *articleDetailVC=[[ArticleDetailViewController alloc] init];
        articleDetailVC.term_id=1;
        articleDetailVC.articleInfo=info;
        articleDetailVC.navigationItem.title=info.title;
        [self.navigationController pushViewController:articleDetailVC animated:YES];
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
    static NSString *mazuCellIdentifier=@"mazuCellIdentifier";
    MazuCell *cell=[tableView dequeueReusableCellWithIdentifier:mazuCellIdentifier];
    if(cell==nil)
    {
        cell=[[MazuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mazuCellIdentifier frame:CGRectMake(0, 0, tableView.width, MazuCellHeight)];
    }
    if(_infoList && indexPath.row<_infoList.list.count)
    {
//        [cell setShowImage:[UIImage imageNamed:@"index_ad1.jpg"]];
//        [cell setTitle:@"第二届我爱妈祖全球儿童画大赛正式启动"];
//        [cell setIntroduce:@"2014年7月2日，由中华妈祖文化交流协会、福建省对外文化交流协会、海峡出版发行集团联合主办，由湄洲妈祖"];
        
        ArticleInfo *info=[_infoList.list objectAtIndex:indexPath.row];
        //[cell setShowImage:[UIImage imageNamed:@"index_ad1.jpg"]];
        [cell setShowImageUrl:info.imageUrl];
        [cell setTitle:info.title];
        [cell setIntroduce:info.excerpt];
        [cell setDate:info.post_date];
       
        
        [cell setOther:[NSString  stringWithFormat:@"阅 %@  评论 %@", info.post_hits,info.comment_count]];

    }
    
    return cell;
}

@end
