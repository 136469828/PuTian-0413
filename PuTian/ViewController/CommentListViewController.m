//
//  CommentListViewController.m
//  PuTian
//
//  Created by guofeng on 15/10/14.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "CommentListViewController.h"
#import "HorizontalMenuView.h"
#import "PullToRefreshTableView.h"
#import "MyYouhuiCommentCell.h"
#import "MyArticleCommentCell.h"

#import "UserInfo.h"
#import "CommentInfo.h"
#import "CommentInfoList.h"

@interface CommentListViewController ()<UITableViewDataSource,UITableViewDelegate,HorizontalMenuDataSource,HorizontalMenuDelegate>

@property (nonatomic,strong) HorizontalMenuView *horizontalMenuView;

@property (nonatomic,strong) PullToRefreshTableView *tbYouHui;
@property (nonatomic,strong) PullToRefreshTableView *tbMaZu;
@property (nonatomic,strong) PullToRefreshTableView *tbYuLe;
@property (nonatomic,strong) PullToRefreshTableView *tbZiXun;
@property (nonatomic,strong) PullToRefreshTableView *tbShiPin;

/** 商家优惠 */
@property (nonatomic,strong) CommentInfoList *youhuiList;
/** 妈祖故乡 */
@property (nonatomic,strong) CommentInfoList *mazuList;
/** 莆田娱乐 */
@property (nonatomic,strong) CommentInfoList *yuleList;
/** 本地资讯 */
@property (nonatomic,strong) CommentInfoList *zixunList;
/** 莆田视频 */
@property (nonatomic,strong) CommentInfoList *shipinList;

@end

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"我的评论";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameCommentInfoList object:nil];
    
    UserInfo *userInfo=[UserInfo sharedInstance];
    
    _youhuiList=[[CommentInfoList alloc] init];
    _youhuiList.notificationName=kNotificationNameCommentInfoList;
    _youhuiList.userid=userInfo.userid;
    _youhuiList.commentType=2;
    
    
    _mazuList=[[CommentInfoList alloc] init];
    _mazuList.notificationName=kNotificationNameCommentInfoList;
    _mazuList.userid=userInfo.userid;
    _mazuList.commentType=1;
    _mazuList.term_id=1;
    
    
    _yuleList=[[CommentInfoList alloc] init];
    _yuleList.notificationName=kNotificationNameCommentInfoList;
    _yuleList.userid=userInfo.userid;
    _yuleList.commentType=1;
    _yuleList.term_id=3;
    
    
    _zixunList=[[CommentInfoList alloc] init];
    _zixunList.notificationName=kNotificationNameCommentInfoList;
    _zixunList.userid=userInfo.userid;
    _zixunList.commentType=1;
    _zixunList.term_id=2;
    
    
    _shipinList=[[CommentInfoList alloc] init];
    _shipinList.notificationName=kNotificationNameCommentInfoList;
    _shipinList.userid=userInfo.userid;
    _shipinList.commentType=3;
    
    
    
    _horizontalMenuView=[[HorizontalMenuView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, 35) isShowTopLine:YES isShowBottomLine:YES];
    _horizontalMenuView.dataSource=self;
    _horizontalMenuView.delegate=self;
    _horizontalMenuView.gapWidth=30;
    _horizontalMenuView.normalColor=[UIColor colorWithWhite:0.5 alpha:1.0];
    _horizontalMenuView.selectedColor=kNavigationBarBackgroundColor;
    [self.view addSubview:_horizontalMenuView];
    
    _tbYouHui=[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, _horizontalMenuView.y+_horizontalMenuView.height, self.view.width, self.view.height-_horizontalMenuView.y-_horizontalMenuView.height)];
    _tbYouHui.dataSource=self;
    _tbYouHui.delegate=self;
    _tbYouHui.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tbYouHui];
    
    _tbMaZu=[[PullToRefreshTableView alloc] initWithFrame:_tbYouHui.frame];
    _tbMaZu.dataSource=self;
    _tbMaZu.delegate=self;
    _tbMaZu.hidden=YES;
    _tbMaZu.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tbMaZu];
    
    _tbYuLe=[[PullToRefreshTableView alloc] initWithFrame:_tbYouHui.frame];
    _tbYuLe.dataSource=self;
    _tbYuLe.delegate=self;
    _tbYuLe.hidden=YES;
    _tbYuLe.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tbYuLe];
    
    _tbZiXun=[[PullToRefreshTableView alloc] initWithFrame:_tbYouHui.frame];
    _tbZiXun.dataSource=self;
    _tbZiXun.delegate=self;
    _tbZiXun.hidden=YES;
    _tbZiXun.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tbZiXun];
    
    _tbShiPin=[[PullToRefreshTableView alloc] initWithFrame:_tbYouHui.frame];
    _tbShiPin.dataSource=self;
    _tbShiPin.delegate=self;
    _tbShiPin.hidden=YES;
    _tbShiPin.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tbShiPin];
    
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameCommentInfoList])
    {
        NSDictionary *userInfo=notification.userInfo;
        SlideType slideType=(SlideType)[[userInfo objectForKey:kNotificationSlideTypeKey] integerValue];
        BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
        NSInteger requestCount=[[userInfo objectForKey:kNotificationContentKey] integerValue];
        
        BOOL isLoadAll=NO;
        CommentInfoList *dataSource=nil;
        PullToRefreshTableView *tableView=nil;
        if(notification.object==_youhuiList)
        {
            dataSource=_youhuiList;
            tableView=_tbYouHui;
        }
        else if(notification.object==_mazuList)
        {
            dataSource=_mazuList;
            tableView=_tbMaZu;
        }
        else if(notification.object==_yuleList)
        {
            dataSource=_yuleList;
            tableView=_tbYuLe;
        }
        else if(notification.object==_zixunList)
        {
            dataSource=_zixunList;
            tableView=_tbZiXun;
        }
        else if(notification.object==_shipinList)
        {
            dataSource=_shipinList;
            tableView=_tbShiPin;
        }
        
        if(succeed && tableView)
        {
            if(requestCount>0)
            {
                [self insertRowsWithDataSource:dataSource count:requestCount slideType:slideType toTableView:tableView];
                
                NSInteger pageIndex=[[userInfo objectForKey:kNotificationPageIndexKey] integerValue];
                if(pageIndex==dataSource.pageCount)
                {
                    isLoadAll=YES;
                    [tableView didAllLoaded];
                }
            }
            else
            {
                if(slideType==SlideTypeDown || slideType==SlideTypeNormal)
                {
                    [tableView reloadData];
                }
            }
        }
        
        if(!isLoadAll)
            [tableView restoreState];
    }
}

-(void)insertRowsWithDataSource:(CommentInfoList *)dataSource count:(NSInteger)count slideType:(SlideType)slideType toTableView:(PullToRefreshTableView *)tableView
{
    if(dataSource.list && dataSource.list.count>=count)
    {
        if(slideType==SlideTypeNormal || slideType==SlideTypeDown)
        {
            [tableView reloadData];
        }
        else
        {
            NSMutableArray *arrIndexPath=[[NSMutableArray alloc] init];
            NSInteger listCount=dataSource.list.count;
            for(int i=listCount-count;i<listCount;i++)
            {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                [arrIndexPath addObject:indexPath];
            }
            [tableView beginUpdates];
            [tableView insertRowsAtIndexPaths:arrIndexPath withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_youhuiList disposeRequest];
    [_mazuList disposeRequest];
    [_yuleList disposeRequest];
    [_zixunList disposeRequest];
    [_shipinList disposeRequest];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameCommentInfoList object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - HorizontalMenuDelegate
-(void)horizontalMenuView:(HorizontalMenuView *)menuView didSelectMenuAtIndex:(NSInteger)index
{
    _tbYouHui.hidden=YES;
    _tbMaZu.hidden=YES;
    _tbYuLe.hidden=YES;
    _tbZiXun.hidden=YES;
    _tbShiPin.hidden=YES;
    
    switch(index)
    {
        case 0: //商家优惠
            _tbYouHui.hidden=NO;
            if(_youhuiList.list.count==0)
            {
                [_tbYouHui showLoading];
                [_youhuiList loadDataWithSlideType:SlideTypeDown];
            }
            break;
        case 1: //妈祖故乡
            _tbMaZu.hidden=NO;
            if(_mazuList.list.count==0)
            {
                [_tbMaZu showLoading];
                [_mazuList loadDataWithSlideType:SlideTypeDown];
            }
            break;
        case 2: //莆田娱乐
            _tbYuLe.hidden=NO;
            if(_yuleList.list.count==0)
            {
                [_tbYuLe showLoading];
                [_yuleList loadDataWithSlideType:SlideTypeDown];
            }
            break;
        case 3: //本地资讯
            _tbZiXun.hidden=NO;
            if(_zixunList.list.count==0)
            {
                [_tbZiXun showLoading];
                [_zixunList loadDataWithSlideType:SlideTypeDown];
            }
            break;
        case 4: //莆田视频
            _tbShiPin.hidden=NO;
            if(_shipinList.list.count==0)
            {
                [_tbShiPin showLoading];
                [_shipinList loadDataWithSlideType:SlideTypeDown];
            }
            break;
    }
}

#pragma mark - HorizontalMenuDataSource
-(NSInteger)horizontalMenuViewColumnCount:(HorizontalMenuView *)menuView
{
    return 5;
}
-(NSString *)horizontalMenuView:(HorizontalMenuView *)menuView menuAtIndex:(NSInteger)index
{
    switch(index)
    {
        case 0:return @"商家优惠";
        case 1:return @"妈祖故乡";
        case 2:return @"莆田娱乐";
        case 3:return @"本地资讯";
        case 4:return @"莆田视频";
    }
    return nil;
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    PullToRefreshTableView *tableView=[self tableViewWithScrollView:scrollView dataSource:nil];
    if(tableView)[tableView tableViewDidDragging];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CommentInfoList *dataSource=nil;
    PullToRefreshTableView *tableView=[self tableViewWithScrollView:scrollView dataSource:&dataSource];
    if(tableView)
    {
        SlideType slideType = (SlideType)[tableView tableViewDidEndDragging];
        
        //  slideType用来判断执行的拖动是下拉还是上拖，如果数据正在加载，则返回DO_NOTHING
        if (slideType != SlideTypeNormal)
        {
            [dataSource loadDataWithSlideType:slideType];
        }
    }
}
-(PullToRefreshTableView *)tableViewWithScrollView:(UIScrollView *)scrollView dataSource:(CommentInfoList **)dataSource
{
    PullToRefreshTableView *tableView=nil;
    
    if(scrollView==_tbYouHui)
    {
        tableView=_tbYouHui;
        if(dataSource)*dataSource=_youhuiList;
    }
    else if(scrollView==_tbMaZu)
    {
        tableView=_tbMaZu;
        if(dataSource)*dataSource=_mazuList;
    }
    else if(scrollView==_tbYuLe)
    {
        tableView=_tbYuLe;
        if(dataSource)*dataSource=_yuleList;
    }
    else if(scrollView==_tbZiXun)
    {
        tableView=_tbZiXun;
        if(dataSource)*dataSource=_zixunList;
    }
    else if(scrollView==_tbShiPin)
    {
        tableView=_tbShiPin;
        if(dataSource)*dataSource=_shipinList;
    }
    
    return tableView;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tbYouHui)
        return MyYouhuiCommentCellHeight;
    return MyArticleCommentCellHeight;
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
    if(tableView==_tbYouHui)
        return _youhuiList.list.count;
    if(tableView==_tbMaZu)
        return _mazuList.list.count;
    if(tableView==_tbYuLe)
        return _yuleList.list.count;
    if(tableView==_tbZiXun)
        return _zixunList.list.count;
    if(tableView==_tbShiPin)
        return _shipinList.list.count;
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *youhuiCommentCellIdentifier=@"youhuiCommentCellIdentifier";
    static NSString *mazuCommentCellIdentifier=@"mazuCommentCellIdentifier";
    static NSString *yuleCommentCellIdentifier=@"yuleCommentCellIdentifier";
    static NSString *zixunCommentCellIdentifier=@"zixunCommentCellIdentifier";
    static NSString *shipinCommentCellIdentifier=@"shipinCommentCellIdentifier";
    UITableViewCell *tableViewCell=nil;
    if(tableView==_tbYouHui)
    {
        MyYouhuiCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:youhuiCommentCellIdentifier];
        if(cell==nil)
        {
            cell=[[MyYouhuiCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:youhuiCommentCellIdentifier frame:CGRectMake(0, 0, tableView.width, MyYouhuiCommentCellHeight)];
        }
        if(_youhuiList.list.count>indexPath.row)
        {
            CommentInfo *info=[_youhuiList.list objectAtIndex:indexPath.row];
            cell.showImageUrl=info.url;
            cell.title=info.post_title;
            cell.date=info.date;
            cell.gradeType=info.gradeType;
            cell.grade=info.grade;
            cell.comment=info.comment;
        }
        tableViewCell=cell;
    }
    else if(tableView==_tbMaZu)
    {
        MyArticleCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:mazuCommentCellIdentifier];
        if(cell==nil)
        {
            cell=[[MyArticleCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mazuCommentCellIdentifier frame:CGRectMake(0, 0, tableView.width, MyArticleCommentCellHeight)];
        }
        if(_mazuList.list.count>indexPath.row)
        {
            CommentInfo *info=[_mazuList.list objectAtIndex:indexPath.row];
            cell.showImageUrl=info.url;
            cell.title=info.post_title;
            cell.date=info.date;
            cell.comment=info.comment;
        }
        tableViewCell=cell;
    }
    else if(tableView==_tbYuLe)
    {
        MyArticleCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:yuleCommentCellIdentifier];
        if(cell==nil)
        {
            cell=[[MyArticleCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:yuleCommentCellIdentifier frame:CGRectMake(0, 0, tableView.width, MyArticleCommentCellHeight)];
        }
        if(_yuleList.list.count>indexPath.row)
        {
            CommentInfo *info=[_yuleList.list objectAtIndex:indexPath.row];
            cell.showImageUrl=info.url;
            cell.title=info.post_title;
            cell.date=info.date;
            cell.comment=info.comment;
        }
        tableViewCell=cell;
    }
    else if(tableView==_tbZiXun)
    {
        MyArticleCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:zixunCommentCellIdentifier];
        if(cell==nil)
        {
            cell=[[MyArticleCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:zixunCommentCellIdentifier frame:CGRectMake(0, 0, tableView.width, MyArticleCommentCellHeight)];
        }
        if(_zixunList.list.count>indexPath.row)
        {
            CommentInfo *info=[_zixunList.list objectAtIndex:indexPath.row];
            cell.showImageUrl=info.url;
            cell.title=info.post_title;
            cell.date=info.date;
            cell.comment=info.comment;
        }
        tableViewCell=cell;
    }
    else if(tableView==_tbShiPin)
    {
        MyArticleCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:shipinCommentCellIdentifier];
        if(cell==nil)
        {
            cell=[[MyArticleCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:shipinCommentCellIdentifier frame:CGRectMake(0, 0, tableView.width, MyArticleCommentCellHeight)];
        }
        if(_shipinList.list.count>indexPath.row)
        {
            CommentInfo *info=[_shipinList.list objectAtIndex:indexPath.row];
            cell.showImageUrl=info.url;
            cell.title=info.post_title;
            cell.date=info.date;
            cell.comment=info.comment;
        }
        tableViewCell=cell;
    }
    
    return tableViewCell;
}

@end
