//
//  AddSquareViewController.m
//  PuTian
//
//  Created by guofeng on 15/10/17.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "AddSquareViewController.h"
#import "AddSquareCell.h"
#import "PTWebViewController.h"

#import "SquareInfoList.h"

@interface AddSquareViewController ()<UITableViewDataSource,UITableViewDelegate,AddSquareDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *listDefault;
@property (nonatomic,strong) NSMutableArray *listRemoved;
@property (nonatomic,strong) NSMutableArray *listRemovedIndex;
@property (nonatomic,strong) NSMutableArray *listAdd;

@end

@implementation AddSquareViewController

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
    
    self.navigationItem.title=@"添加广场";
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameSquareInfoList object:nil];
    if(_infoList)
    {
        [MBProgressHUDManager showIndicatorWithTitle:@"正在加载" inView:self.view];
        
        [_infoList loadAllData];
    }
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameNavigationControllerDidShowViewController])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    else if([notification.name isEqualToString:kNotificationNameSquareInfoList])
    {
        if(notification.object==_infoList)
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
                    if(_infoList.listAll.count>0)
                    {
                        [_tableView reloadData];
                    }
                }
                else
                {
                    if(hasNetworkFlags)
                        [MBProgressHUDManager showWrongWithTitle:@"获取数据失败了" inView:self.view];
                    else
                        [MBProgressHUDManager showWrongWithTitle:@"未连接网络" inView:self.view];
                }
            }
        }
    }
}

-(void)openSquare:(Square *)model
{
    if(model.link_id>0)
    {
        if([model.link_url isNotNilOrEmptyString])
        {
            PTWebViewController *webVC=[[PTWebViewController alloc] init];
            webVC.urlString=model.link_url;
            webVC.navigationItem.title=model.link_name;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    if(_infoList)
    {
        [_infoList disposeRequestAll];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameNavigationControllerDidShowViewController object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameSquareInfoList object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - AddSquareDelegate
-(void)addSquareCell:(AddSquareCell *)cell didClickAddButton:(BOOL)isChecked
{
    if(cell.model)
    {
        Square *model=cell.model;
        
        int index=-1;
        for(int i=0;i<_listDefault.count;i++)
        {
            Square *m=[_listDefault objectAtIndex:i];
            if(m.link_id==model.link_id)
            {
                index=i;
                break;
            }
        }
        
        int indexAtDefault=-1;
        [_infoList list:_listOriginal isContains:model atIndex:&indexAtDefault];
        
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
    return AddSquareCellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_infoList.listAll.count>indexPath.row)
    {
        Square *model=[_infoList.listAll objectAtIndex:indexPath.row];
        [self openSquare:model];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_infoList)return _infoList.listAll.count;
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gAddSquareCellIdentifier=@"gAddSquareCellIdentifier";
    AddSquareCell *cell=[tableView dequeueReusableCellWithIdentifier:gAddSquareCellIdentifier];
    if(cell==nil)
    {
        cell=[[AddSquareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gAddSquareCellIdentifier frame:CGRectMake(0, 0, tableView.width, AddSquareCellHeight)];
        cell.delegate=self;
    }
    
    if(_infoList && _infoList.listAll.count>indexPath.row)
    {
        Square *model=[_infoList.listAll objectAtIndex:indexPath.row];
        cell.model=model;
        cell.title=model.link_name;
        
        BOOL isChecked=NO;
        if(_listDefault.count>0)
        {
            for(Square *m in _listDefault)
            {
                if(m.link_id==model.link_id)
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
