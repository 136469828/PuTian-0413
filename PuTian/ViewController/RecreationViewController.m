//
//  RecreationViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/15.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "RecreationViewController.h"
#import "MazuCell.h"
#import "PullToRefreshTableView.h"
#import "ArticleDetailViewController.h"
#import "RecreationSearchViewController.h"

#import "RecreationInfoList.h"
#import "UserInfo.h"

@interface RecreationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITextField *txtSearch;

@property (nonatomic,strong) PullToRefreshTableView *tableView;

@property (nonatomic,strong) RecreationInfoList *infoList;

@end

@implementation RecreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIView *searchView=[[UIView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, 32)];
    searchView.layer.borderColor=[UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    searchView.layer.borderWidth=1;
    searchView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:searchView];
    
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
    
    _tableView=[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, searchView.y+searchView.height+1, self.view.width, self.view.height-searchView.y-searchView.height-1)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameRecreationInfoList object:nil];
    
    _infoList=[[RecreationInfoList alloc] init];
    _infoList.notificationName=kNotificationNameRecreationInfoList;
    _infoList.uid=[UserInfo sharedInstance].userid;
    _infoList.channelid=_channelid;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^
                   {
                       [NSThread sleepForTimeInterval:0.1];
                       dispatch_sync(dispatch_get_main_queue(), ^
                                     {
                                         [_tableView showLoading];
                                         [_infoList loadDataWithSlideType:SlideTypeNormal keywords:nil];
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
    
    RecreationSearchViewController *searchVC=[[RecreationSearchViewController alloc] init];
    searchVC.channelid=self.channelid;
    searchVC.keywords=keywords;
    searchVC.navigationItem.title=@"莆田娱乐";
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_infoList disposeRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameRecreationInfoList object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameRecreationInfoList])
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
    
    RecreationSearchViewController *searchVC=[[RecreationSearchViewController alloc] init];
    searchVC.channelid=self.channelid;
    searchVC.keywords=keywords;
    searchVC.navigationItem.title=@"莆田娱乐";
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
        [_infoList loadDataWithSlideType:slideType keywords:nil];
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
        articleDetailVC.term_id=3;
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
    static NSString *recreationInfoCellIdentifier=@"recreationInfoCellIdentifier";
    MazuCell *cell=[tableView dequeueReusableCellWithIdentifier:recreationInfoCellIdentifier];
    if(cell==nil)
    {
        cell=[[MazuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recreationInfoCellIdentifier frame:CGRectMake(0, 0, tableView.width, MazuCellHeight)];
//        UIColor *color=[[UIColor alloc] initWithRed:12.0/255 green:127.0/255 blue:18.0/255 alpha:1.0];
//        [cell setTitleColor:color];
    }
    if(_infoList.list.count>indexPath.row)
    {
        ArticleInfo *info=[_infoList.list objectAtIndex:indexPath.row];
        //[cell setShowImage:[UIImage imageNamed:@"index_ad1.jpg"]];
        [cell setShowImageUrl:info.imageUrl];
        [cell setTitle:info.title];
        [cell setIntroduce:info.excerpt];
        if (info.post_hits == nil) {
            info.post_hits = @"0";
        }
        if (info.comment_count == nil) {
            info.comment_count = @"0";
        }
        [cell setDate:info.post_date];
        [cell setOther:[NSString  stringWithFormat:@"阅 %@  评论 %@", info.post_hits,info.comment_count]];
    }
    /*
     if(_infoList.list.count>indexPath.row)
     {
     ArticleInfo *info=[_infoList.list objectAtIndex:indexPath.row];
     //[cell setShowImage:[UIImage imageNamed:@"index_ad1.jpg"]];
     [cell setShowImageUrl:info.imageUrl];
     [cell setTitle:info.title];
     [cell setIntroduce:info.excerpt];
     
     [cell setDate:info.post_date];
     
     
     [cell setOther:[NSString  stringWithFormat:@"阅 %@  评论 %@", info.post_hits,info.comment_count]];
     }

     */
    return cell;
}

@end
