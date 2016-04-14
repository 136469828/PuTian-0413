//
//  WobiViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/18.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "WobiViewController.h"
#import "PullToRefreshTableView.h"

#import "UserInfo.h"
#import "WobiInfoList.h"
#import "WoBiDuanHuanViewController.h"

@interface WobiViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UILabel *lblMobile;
@property (nonatomic,strong) UILabel *lblWobi;
@property (nonatomic,strong) UIButton *btnDuiHuan;
@property (nonatomic,strong) PullToRefreshTableView *tableView;

@property (nonatomic,strong) UserInfo *userInfo;
@property (nonatomic,strong) WobiInfoList *infoList;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end

@implementation WobiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"沃币中心";
    
    _userInfo=[UserInfo sharedInstance];
    
    _dateFormatter=[[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat=@"yyyy年MM月dd日 HH:mm";
    
    float left=10;
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(left, self.marginTop+10, 52, 20)];
    lbl.font=[UIFont systemFontOfSize:15.0];
    lbl.text=@"手机号:";
    [self.view addSubview:lbl];
    
    _lblMobile=[[UILabel alloc] initWithFrame:CGRectMake(lbl.x+lbl.width, lbl.y, 110, 20)];
    _lblMobile.font=[UIFont systemFontOfSize:15.0];
    _lblMobile.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
    _lblMobile.text=_userInfo.loginId;
//    _lblMobile.backgroundColor = [UIColor redColor];
    [self.view addSubview:_lblMobile];
    
    lbl=[[UILabel alloc] initWithFrame:CGRectMake(_lblMobile.x+_lblMobile.width+2, _lblMobile.y, 70, 20)];
    lbl.font=[UIFont systemFontOfSize:15.0];
    lbl.text=@"当前沃币:";
    [self.view addSubview:lbl];
    
    _lblWobi=[[UILabel alloc] initWithFrame:CGRectMake(lbl.x+lbl.width, lbl.y, 100, 20)];
    _lblWobi.font=[UIFont systemFontOfSize:15.0];
    _lblWobi.textColor=kNavigationBarBackgroundColor;
//    _lblWobi.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_lblWobi];
    
    _btnDuiHuan=[[UIButton alloc] initWithFrame:CGRectMake(_lblWobi.x+50, lbl.y, 100, 20)];
    
    [_btnDuiHuan setTitle:@"兑换" forState:UIControlStateNormal];
    [_btnDuiHuan addTarget:self action:@selector(DuiHuan) forControlEvents:UIControlEventTouchUpInside];
    [_btnDuiHuan setTitleColor:kNavigationBarBackgroundColor forState:UIControlStateNormal];
    [_btnDuiHuan setFont:[UIFont systemFontOfSize:15.0]];
    [self.view addSubview:_btnDuiHuan];

    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, _lblWobi.y+_lblWobi.height+5, self.view.width, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    
    _tableView=[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, line.y, self.view.width, self.view.height-line.y-line.height)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameUserInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameWobiInfoList object:nil];
    
    [MBProgressHUDManager showIndicatorWithTitle:@"正在加载" inView:self.view];
    [_userInfo requestUserInfo];
    
    _infoList=[[WobiInfoList alloc] init];
    _infoList.notificationName=kNotificationNameWobiInfoList;
    _infoList.userid=_userInfo.userid;
    
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
-(void)DuiHuan
{
    WoBiDuanHuanViewController *localInfoVC=[[WoBiDuanHuanViewController alloc] init];
    localInfoVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:localInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_infoList disposeRequest];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameUserInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameWobiInfoList object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameUserInfo])
    {
        NSDictionary *dicUserInfo=notification.userInfo;
        BOOL hasNetworkFlags=[[dicUserInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
        BOOL succeed=[[dicUserInfo objectForKey:kNotificationSucceedKey] boolValue];
        NSInteger nType=[[dicUserInfo objectForKey:kNotificationTypeKey] integerValue];
        if(succeed)
        {
            switch(nType)
            {
                case 4: //获取用户详情
                    [MBProgressHUDManager hideMBProgressInView:self.view];
                    // 沃币的数据
                    _lblWobi.text=[@(_userInfo.wobi) stringValue];
                    break;
            }
        }
        else
        {
            switch(nType)
            {
                case 4:
                    [MBProgressHUDManager hideMBProgressInView:self.view];
                    
                    if(hasNetworkFlags)
                        [MBProgressHUDManager showTextWithTitle:@"加载失败" inView:self.view];
                    else
                        [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
                    break;
            }
        }
    }
    else if([notification.name isEqualToString:kNotificationNameWobiInfoList])
    {
        if(notification.object==_infoList)
        {
            NSDictionary *userInfo=notification.userInfo;
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
    return 50;
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
    static NSString *wobiInfoCellIdentifier=@"wobiInfoCellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:wobiInfoCellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:wobiInfoCellIdentifier];
        cell.textLabel.font=[UIFont systemFontOfSize:13.0];
        cell.textLabel.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        cell.textLabel.numberOfLines=0;
    }
    
    if(_infoList.list.count>indexPath.row)
    {
        WobiInfo *info=[_infoList.list objectAtIndex:indexPath.row];
        if(info.createDate)
        {
            NSString *tmpstr=nil;
//            if(info.fktype==2 && [info.orderNo isNotNilOrEmptyString])
//            {
//                tmpstr=[[NSString alloc] initWithFormat:@"%@ 通过 %@ 获得 %d 沃币，\n订单号：%@",[_dateFormatter stringFromDate:info.createDate],info.fktypeName,info.wobi,info.orderNo];
//            }
//            else
//            {
//                tmpstr=[[NSString alloc] initWithFormat:@"%@ 通过 %@ 获得 %d 沃币",[_dateFormatter stringFromDate:info.createDate],info.fktypeName,info.wobi];
//            }
            tmpstr=[[NSString alloc] initWithFormat:@"%@ 通过 %@ 获得 %d 沃币",[_dateFormatter stringFromDate:info.createDate],info.fktypeName,info.wobi];
            cell.textLabel.text=tmpstr;
        }
    }
    
    return cell;
}

@end
