//
//  RecreationChannelListViewController.m
//  PuTian
//
//  Created by guofeng on 15/10/21.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "RecreationChannelListViewController.h"
#import "RecreationChannelCell.h"
#import "RecreationViewController.h"

#import "RecreationChannelList.h"

@interface RecreationChannelListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) RecreationChannelList *channelList;

@end

@implementation RecreationChannelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
//    self.navigationItem.title=@"娱乐频道";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameRecreationChannelList object:nil];
    
    _channelList=[[RecreationChannelList alloc] init];
    _channelList.notificationName=kNotificationNameRecreationChannelList;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.marginTop+1, self.view.width, self.viewHeightWhenTabBarHided-1) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [MBProgressHUDManager showIndicatorWithTitle:@"正在加载" inView:self.view];
    
    [_channelList loadData];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameRecreationChannelList])
    {
        if(notification.object==_channelList)
        {
            [MBProgressHUDManager hideMBProgressInView:self.view];
            
            NSDictionary *userInfo=notification.userInfo;
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            if(succeed)
            {
                [_tableView reloadData];
            }
            else
            {
                [MBProgressHUDManager showWrongWithTitle:@"加载数据失败" inView:self.view];
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
    [_channelList disposeRequest];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameRecreationChannelList object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RecreationChannelCellHeight;
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
    
    RecreationChannelCell *cell=(RecreationChannelCell *)[tableView cellForRowAtIndexPath:indexPath];
    RecreationViewController *recreationVC=[[RecreationViewController alloc] init];
    recreationVC.channelid=cell.channelid;
    recreationVC.navigationItem.title=cell.title;
    [self.navigationController pushViewController:recreationVC animated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _channelList.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gRecreationChannelCellIdentifier=@"gRecreationChannelCellIdentifier";
    RecreationChannelCell *cell=[tableView dequeueReusableCellWithIdentifier:gRecreationChannelCellIdentifier];
    if(cell==nil)
    {
        cell=[[RecreationChannelCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:gRecreationChannelCellIdentifier frame:CGRectMake(0, 0, tableView.width, RecreationChannelCellHeight)];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(_channelList.list.count>indexPath.row)
    {
        RecreationChannel *model=[_channelList.list objectAtIndex:indexPath.row];
        cell.channelid=model.channelid;
        cell.showImageUrl=model.iconUrl;
        cell.title=model.channelName;
        cell.introduce=model.introduce;
    }
    
    return cell;
}

@end
