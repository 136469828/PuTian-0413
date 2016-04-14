//
//  OffPriceViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/8.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "OffPriceViewController.h"
#import "EScrollerView.h"
#import "PullToRefreshTableView.h"
#import "OffPriceCell.h"
#import "OffPriceSearchViewController.h"
#import "OffPriceDetailViewController.h"

#import "OffPriceInfoList.h"

@interface OffPriceViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,EScrollerViewDelegate>

@property (nonatomic,strong) UIView *contentView1;

@property (nonatomic,strong) UITextField *txtSearch;

@property (nonatomic,strong) EScrollerView *viewAD;

@property (nonatomic,strong) PullToRefreshTableView *tableView;

@property (nonatomic,strong) OffPriceInfoList *infoList;

@end

@implementation OffPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationLeftButton:1];
    
    self.navigationItem.title=@"优惠信息";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    _contentView1=[[UIView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.viewHeightWhenTabBarHided)];
    [self.view addSubview:_contentView1];
    
    UIView *searchView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32)];
    searchView.layer.borderColor=[UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    searchView.layer.borderWidth=1;
    searchView.backgroundColor=[UIColor whiteColor];
    [_contentView1 addSubview:searchView];
    
    UIButton *btnSearch=[[UIButton alloc] initWithFrame:CGRectMake(searchView.width-35, 1, 30, 30)];
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"offprice_btn_search"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(searchTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:btnSearch];
    
    _txtSearch=[[UITextField alloc] initWithFrame:CGRectMake(10, 0, btnSearch.x-20, searchView.height)];
    _txtSearch.placeholder=@"搜索关键字";
    _txtSearch.returnKeyType=UIReturnKeySearch;
    _txtSearch.delegate=self;
    _txtSearch.font=[UIFont systemFontOfSize:15.0];
    _txtSearch.autocorrectionType=UITextAutocorrectionTypeNo;
    [searchView addSubview:_txtSearch];
    
//    UIImage *image=[UIImage imageNamed:@"index_ad1.jpg"];
//    float adWidth=self.view.width;
//    float adHeight=adWidth*image.size.height/image.size.width;
//    _viewAD=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, searchView.y+searchView.height, adWidth, adHeight) ImageArray:[NSArray arrayWithObjects:@"index_ad1.jpg",@"index_ad1.jpg",@"index_ad1.jpg", nil] TitleArray:[NSArray arrayWithObjects:@"",@"",@"", nil]];
//    _viewAD.delegate=self;
//    [_viewAD startAutoPlayWithInterval:3];
//    [_contentView1 addSubview:_viewAD];
    
    //_tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, _viewAD.y+_viewAD.height+1, _contentView1.width, _contentView1.height-_viewAD.y-_viewAD.height-1) style:UITableViewStyleGrouped];
    _tableView=[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, searchView.y+searchView.height+1, _contentView1.width, _contentView1.height-searchView.y-searchView.height-1)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_contentView1 addSubview:_tableView];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameOffPriceInfoList object:nil];
    
    _infoList=[[OffPriceInfoList alloc] init];
    _infoList.notificationName=kNotificationNameOffPriceInfoList;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^
                   {
                       [NSThread sleepForTimeInterval:0.1];
                       dispatch_sync(dispatch_get_main_queue(), ^
                                     {
                                         [_tableView showLoading];
                                         [_infoList loadDataWithSlideType:SlideTypeNormal keywords:@""];
                                     });
                   });
}

-(void)searchTouchUp
{
    NSString *keywords=[_txtSearch.text trim];
    if(![keywords isNotNilOrEmptyString])
    {
        [MBProgressHUDManager showTextWithTitle:@"请输入关键字" inView:self.view];
        return;
    }
    OffPriceSearchViewController *searchVC=[[OffPriceSearchViewController alloc] init];
    searchVC.keywords=keywords;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_infoList disposeRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameOffPriceInfoList object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameOffPriceInfoList])
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

#pragma mark - EScrollerViewDelegate
-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    
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
    
    OffPriceSearchViewController *searchVC=[[OffPriceSearchViewController alloc] init];
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
        [_infoList loadDataWithSlideType:slideType keywords:@""];
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
        
        OffPriceDetailViewController *detailVC=[[OffPriceDetailViewController alloc] initWithObject:info];
        detailVC.sender=1;
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
    static NSString *offpriceCellIdentifier=@"offpriceCellIdentifier";
    OffPriceCell *cell=nil;
    if(tableView==_tableView)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:offpriceCellIdentifier];
        if(cell==nil)
        {
            cell=[[OffPriceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:offpriceCellIdentifier frame:CGRectMake(0, 0, tableView.width, OffPriceCellHeight)];
        }
        if(_infoList.list.count>indexPath.row)
        {
            OffPriceInfo *info=[_infoList.list objectAtIndex:indexPath.row];
            //[cell setShowImage:[UIImage imageNamed:@"index_ad1.jpg"]];
            [cell setShowImageUrl:info.imageUrl];
//            NSLog(@"%@",info.imageUrl);
            [cell setTitle:info.title];
            //[cell setPrice1:info.marketprice andPrice2:info.saleprice];
            [cell setIntroduce:info.introduce];
            [cell setBuyerCount:info.buyerCount];
        }
    }
    
    return cell;
}

@end
