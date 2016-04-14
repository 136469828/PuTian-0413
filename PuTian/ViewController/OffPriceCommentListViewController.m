//
//  OffPriceCommentListViewController.m
//  PuTian
//
//  Created by guofeng on 15/10/17.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "OffPriceCommentListViewController.h"
#import "PullToRefreshTableView.h"
#import "CommentCell.h"

#import "CommentInfoList.h"
#import "CommentInfo.h"

@interface OffPriceCommentListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) PullToRefreshTableView *tableView;

@property (nonatomic,strong) CommentInfoList *infoList;

@end

@implementation OffPriceCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"用户评论";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameCommentInfoList object:nil];
    
    _infoList=[[CommentInfoList alloc] init];
    _infoList.notificationName=kNotificationNameCommentInfoList;
    _infoList.post_id=_productid;
    _infoList.commentType=2;
    
    _tableView=[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.view.height-self.marginTop)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
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

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameCommentInfoList])
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
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
    return CommentCellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoList.list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gOffPriceCommentListCellIdentifier=@"gOffPriceCommentListCellIdentifier";
    CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:gOffPriceCommentListCellIdentifier];
    if(cell==nil)
    {
        cell=[[CommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:gOffPriceCommentListCellIdentifier frame:CGRectMake(0, 0, tableView.width, CommentCellHeight)];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if(_infoList.list.count>indexPath.row)
    {
        CommentInfo *model=[_infoList.list objectAtIndex:indexPath.row];
        cell.userNickName=model.userNickName;
        cell.grade=model.grade;
        cell.date=model.date;
        cell.comment=model.comment;
    }
    
    return cell;
}

@end
