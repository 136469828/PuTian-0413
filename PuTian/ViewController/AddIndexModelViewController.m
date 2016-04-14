//
//  AddIndexModelViewController.m
//  PuTian
//
//  Created by guofeng on 15/10/16.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "AddIndexModelViewController.h"
#import "AddIndexModelCell.h"
#import "OffPriceViewController.h"
#import "MazuViewController.h"
#import "LocalInfoViewController.h"
#import "RecreationViewController.h"
#import "VideoViewController.h"
#import "WobiViewController.h"
#import "LoginViewController.h"
#import "PTWebViewController.h"

#import "IndexModelList.h"
#import "UserInfo.h"

@interface AddIndexModelViewController ()<UITableViewDataSource,UITableViewDelegate,AddIndexModelDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *listDefault;
@property (nonatomic,strong) NSMutableArray *listRemoved;
@property (nonatomic,strong) NSMutableArray *listRemovedIndex;
@property (nonatomic,strong) NSMutableArray *listAdd;

@end

@implementation AddIndexModelViewController

-(void)leftButtonTouchUp
{
    if(_willDismissBlock)
    {
        self.willDismissBlock(_listAdd, _listRemovedIndex);
        self.willDismissBlock=nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameNavigationControllerDidShowViewController object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"添加首页模块";
    
    _listDefault=[[NSMutableArray alloc] init];
    _listRemoved=[[NSMutableArray alloc] init];
    _listRemovedIndex=[[NSMutableArray alloc] init];
    _listAdd=[[NSMutableArray alloc] init];
    
    if(_listOriginal && _listOriginal.count>0)
        [_listDefault addObjectsFromArray:_listOriginal];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.marginTop+1, self.view.width, self.viewHeightWhenTabBarHided-1) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameIndexModelList object:nil];
    if(_modelList)
    {
        [MBProgressHUDManager showIndicatorWithTitle:@"正在加载" inView:self.view];
        
        [_modelList loadAllData];
    }
}

-(void)openModel:(IndexModel *)model
{
    switch(model.sign)
    {
        case IndexModelTypeYouhui: //商家优惠
        {
            OffPriceViewController *offpriceVC=[[OffPriceViewController alloc] init];
            offpriceVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:offpriceVC animated:YES];
        }
            break;
        case IndexModelTypeMazu: //妈祖故乡
        {
            MazuViewController *mazuVC=[[MazuViewController alloc] init];
            mazuVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:mazuVC animated:YES];
        }
            break;
        case IndexModelTypeShipin: //莆田视频
        {
            VideoViewController *videoVC=[[VideoViewController alloc] init];
            videoVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:videoVC animated:YES];
        }
            break;
        case IndexModelTypeYule: //莆田娱乐
        {
            RecreationViewController *recreationVC=[[RecreationViewController alloc] init];
            recreationVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:recreationVC animated:YES];
        }
            break;
        case IndexModelTypeWobi: //沃币中心
        {
            if([UserInfo sharedInstance].isLogin)
            {
                WobiViewController *wobiVC=[[WobiViewController alloc] init];
                wobiVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:wobiVC animated:YES];
            }
            else
            {
                LoginViewController *loginVC=[[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case IndexModelTypeZixun: //本地资讯
        {
            LocalInfoViewController *localInfoVC=[[LocalInfoViewController alloc] init];
            localInfoVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:localInfoVC animated:YES];
        }
            break;
//        case 5: //微店进驻
//        {
//            PTWebViewController *webVC=[[PTWebViewController alloc] init];
//            webVC.hidesBottomBarWhenPushed=YES;
//            webVC.navigationItem.title=@"微店进驻";
//            webVC.urlString=@"http://m.taobao.com";
//            [self.navigationController pushViewController:webVC animated:YES];
//        }
//            break;
//        case 8: //车易行
//        {
//            PTWebViewController *webVC=[[PTWebViewController alloc] init];
//            webVC.hidesBottomBarWhenPushed=YES;
//            webVC.navigationItem.title=@"车易行";
//            webVC.urlString=@"http://auto.sina.cn/?from=wap";
//            [self.navigationController pushViewController:webVC animated:YES];
//        }
//            break;
        default:
        {
            PTWebViewController *webVC=[[PTWebViewController alloc] init];
            webVC.hidesBottomBarWhenPushed=YES;
            webVC.navigationItem.title=model.modelName;
            webVC.urlString=model.url;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameNavigationControllerDidShowViewController])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    else if([notification.name isEqualToString:kNotificationNameIndexModelList])
    {
        if(notification.object==_modelList)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            NSInteger nType=[[userInfo objectForKey:kNotificationTypeKey] integerValue];
            
            if(nType==2)
            {
                [MBProgressHUDManager hideMBProgressInView:self.view];
                
                if(succeed)
                {
                    if(_modelList.listAll.count>0)
                    {
                        [_tableView reloadData];
                    }
                }
                else
                {
                    NSString *msg=@"加载数据失败";
                    if(!hasNetworkFlags)
                        msg=@"没有网络连接";
                    [MBProgressHUDManager showWrongWithTitle:msg inView:self.view];
                }
            }
        }
    }
}

-(void)dealloc
{
    if(_modelList)
    {
        [_modelList disposeRequestAll];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameNavigationControllerDidShowViewController object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameIndexModelList object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - AddIndexModelDelegate
-(void)addIndexModelCell:(AddIndexModelCell *)cell didClickAddButton:(BOOL)isChecked
{
    if(cell.model)
    {
        IndexModel *model=cell.model;
        
        int index=-1;
        for(int i=0;i<_listDefault.count;i++)
        {
            IndexModel *m=[_listDefault objectAtIndex:i];
            if(m.modelid==model.modelid)
            {
                index=i;
                break;
            }
        }
        
        int indexAtDefault=-1;
        [_modelList list:_listOriginal isContains:model atIndex:&indexAtDefault];
        
        if(isChecked)
        {
            if(index<0)
            {
                [_listDefault addObject:model];
            }
            if(indexAtDefault<0 && ![_listAdd containsObject:model])
            {
                [_listAdd addObject:model];
            }
            if([_listRemoved containsObject:model])
            {
                int removedIndex=[_listRemoved indexOfObject:model];
                if(_listRemovedIndex.count>removedIndex)
                    [_listRemovedIndex removeObjectAtIndex:removedIndex];
                
                [_listRemoved removeObject:model];
            }
        }
        else
        {
            if(index>=0)
            {
                [_listDefault removeObjectAtIndex:index];
            }
            if([_listAdd containsObject:model])
            {
                [_listAdd removeObject:model];
            }
            if(indexAtDefault>=0)
            {
                if(![_listRemoved containsObject:model])
                    [_listRemoved addObject:model];
                
                NSNumber *numIndex=[[NSNumber alloc] initWithInt:indexAtDefault];
                if(![_listRemovedIndex containsObject:numIndex])
                    [_listRemovedIndex addObject:numIndex];
            }
        }
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AddIndexModelCellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_modelList.listAll.count>indexPath.row)
    {
        IndexModel *model=[_modelList.listAll objectAtIndex:indexPath.row];
        [self openModel:model];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_modelList)return _modelList.listAll.count;
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gAddIndexModelCellIdentifier=@"gAddIndexModelCellIdentifier";
    AddIndexModelCell *cell=[tableView dequeueReusableCellWithIdentifier:gAddIndexModelCellIdentifier];
    if(cell==nil)
    {
        cell=[[AddIndexModelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gAddIndexModelCellIdentifier frame:CGRectMake(0, 0, tableView.width, AddIndexModelCellHeight)];
        cell.delegate=self;
    }
    
    if(_modelList && _modelList.listAll.count>indexPath.row)
    {
        IndexModel *model=[_modelList.listAll objectAtIndex:indexPath.row];
        cell.model=model;
        cell.title=model.modelName;
        
        BOOL isChecked=NO;
        if(_listDefault.count>0)
        {
            for(IndexModel *m in _listDefault)
            {
                if(m.modelid==model.modelid)
                {
                    isChecked=YES;
                    break;
                }
            }
        }
        cell.isChecked=isChecked;
    }
    
    return cell;
}

@end
