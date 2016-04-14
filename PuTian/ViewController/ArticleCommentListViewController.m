//
//  ArticleCommentListViewController.m
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "ArticleCommentListViewController.h"
#import "PullToRefreshTableView.h"
#import "CommentCell.h"
#import "ArticleCommentView.h"

#import "CommentInfoList.h"
#import "CommentInfo.h"
#import "UserInfo.h"

#import "VideoInfo.h"
#import "ArticleInfo.h"

@interface ArticleCommentListViewController ()<UITableViewDataSource,UITableViewDelegate,ArticleCommentViewDelegate>

@property (nonatomic,strong) PullToRefreshTableView *tableView;

@property (nonatomic,strong) CommentInfoList *infoList;

@property (nonatomic,strong) ArticleCommentView *commentView;
@property (nonatomic,strong) CommentInfo *submitComment;

@end

@implementation ArticleCommentListViewController

-(void)showCommentView
{
    if(![UserInfo sharedInstance].isLogin)
    {
        [self pushLoginViewController];
        return;
    }
    
    if(_commentView==nil)
    {
        _commentView=[[ArticleCommentView alloc] initWithFrame:self.view.bounds];
        _commentView.delegate=self;
        [self.view addSubview:_commentView];
    }
}

-(void)initRightBarButton
{
    UIBarButtonItem *button=[[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStyleDone target:self action:@selector(commentTouchUp)];
    self.navigationItem.rightBarButtonItem=button;
    
}
-(void)commentTouchUp
{
    [self showCommentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"用户评价";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameCommentInfoList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameVideoInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameArticleInfo object:nil];
    
    _infoList=[[CommentInfoList alloc] init];
    _infoList.notificationName=kNotificationNameCommentInfoList;
    _infoList.post_id=_post_id;
    _infoList.commentType=_commentType;
    
    if([UserInfo sharedInstance].isLogin)
        [self initRightBarButton];
    
    _tableView=[[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.view.height-self.marginTop)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    if(self.isWriteComment)
        [self showCommentView];
    
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
            BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
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
                if(!hasNetworkFlags)
                {
                    [MBProgressHUDManager showWrongWithTitle:@"没有网络连接" inView:self.view];
                }
            }
            
            if(!isLoadAll)
                [_tableView restoreState];
        }
    }
    else if([notification.name isEqualToString:kNotificationNameVideoInfo])
    {
        if(notification.object==self.object)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            NSInteger nType=[[userInfo objectForKey:kNotificationTypeKey] integerValue];
            
            if(succeed)
            {
                switch(nType)
                {
                    case 2: //评论
                        [MBProgressHUDManager hideMBProgressInView:self.view];
                        if(_commentView)
                        {
                            [_commentView removeFromSuperview];
                            self.commentView=nil;
                        }
                        [MBProgressHUDManager showSuccessWithTitle:@"发布成功" inView:self.view];
                        
                        if(_submitComment)
                        {
                            [_infoList insertCommentInfoToList:_submitComment atIndex:0];
                            self.submitComment=nil;
                            
                            [_tableView reloadData];
                        }
                        break;
                    case 3: //收藏
                        
                        break;
                }
            }
            else
            {
                switch(nType)
                {
                    case 2:
                    {
                        [MBProgressHUDManager hideMBProgressInView:self.view];
                        
                        if(hasNetworkFlags)
                            [MBProgressHUDManager showWrongWithTitle:@"发布失败" inView:self.view];
                        else
                            [MBProgressHUDManager showWrongWithTitle:@"没有网络连接" inView:self.view];
                    }
                        break;
                    case 3:
                        
                        break;
                }
            }
        }
    }
    else if([notification.name isEqualToString:kNotificationNameArticleInfo])
    {
        if(notification.object==self.object)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            NSInteger nType=[[userInfo objectForKey:kNotificationTypeKey] integerValue];
            
            if(succeed)
            {
                switch(nType)
                {
                    case 2: //评论
                        [MBProgressHUDManager hideMBProgressInView:self.view];
                        if(_commentView)
                        {
                            [_commentView removeFromSuperview];
                            self.commentView=nil;
                        }
                        [MBProgressHUDManager showSuccessWithTitle:@"发布成功" inView:self.view];
                        
                        if(_submitComment)
                        {
                            [_infoList insertCommentInfoToList:_submitComment atIndex:0];
                            self.submitComment=nil;
                            
                            [_tableView reloadData];
                        }
                        break;
                }
            }
            else
            {
                switch(nType)
                {
                    case 2:
                    {
                        [MBProgressHUDManager hideMBProgressInView:self.view];
                        
                        if(hasNetworkFlags)
                            [MBProgressHUDManager showWrongWithTitle:@"发布失败" inView:self.view];
                        else
                            [MBProgressHUDManager showWrongWithTitle:@"没有网络连接" inView:self.view];
                    }
                        break;
                }
            }
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
    [_infoList disposeRequest];
    
    if(self.commentType==1)
    {
        ArticleInfo *model=self.object;
        [model disposeRequest];
    }
    else if(self.commentType==3)
    {
        VideoInfo *model=self.object;
        [model disposeRequest];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameCommentInfoList object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameVideoInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameArticleInfo object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ArticleCommentViewDelegate
-(void)articleCommentViewDidSubmit:(ArticleCommentView *)commentView
{
    [MBProgressHUDManager showIndicatorWithTitle:@"正在提交" inView:self.view];
    
    if(_submitComment)self.submitComment=nil;
    
    _submitComment=[[CommentInfo alloc] init];
    _submitComment.grade=commentView.grade;
    if(_submitComment.grade<2)
        _submitComment.gradeType=3;
    else if(_submitComment.grade<5)
        _submitComment.gradeType=2;
    else
        _submitComment.gradeType=1;
    _submitComment.comment=commentView.comment;
    _submitComment.date=[NSDate date];
    _submitComment.userNickName=[UserInfo sharedInstance].nickname;
    
    if(self.commentType==1)
    {
        ArticleInfo *model=self.object;
        if(model.uid==0)
            model.uid=[UserInfo sharedInstance].userid;
        [model comment:_submitComment];
    }
    else if(self.commentType==3)
    {
        VideoInfo *model=self.object;
        if(model.uid==0)
            model.uid=[UserInfo sharedInstance].userid;
        [model comment:_submitComment];
    }
}
-(void)articleCommentViewDidClose:(ArticleCommentView *)commentView
{
    if(_commentView)
    {
        [_commentView removeFromSuperview];
        self.commentView=nil;
    }
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
    static NSString *gArticleCommentListCellIdentifier=@"gArticleCommentListCellIdentifier";
    CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:gArticleCommentListCellIdentifier];
    if(cell==nil)
    {
        cell=[[CommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:gArticleCommentListCellIdentifier frame:CGRectMake(0, 0, tableView.width, CommentCellHeight)];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if(_infoList.list.count>indexPath.row)
    {
        CommentInfo *model=[_infoList.list objectAtIndex:indexPath.row];
        if ([model.userNickName isEqualToString:@""])
        {
            cell.userNickName = @"匿名";
        }
        else
        {
            cell.userNickName=model.userNickName;
        }
        cell.grade=model.grade;
        cell.date=model.date;
        cell.comment=model.comment;
    }
    
    return cell;
}

@end
