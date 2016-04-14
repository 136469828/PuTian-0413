//
//  UserViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "UserViewController.h"
#import "MyWebButton.h"
#import "LoginViewController.h"
#import "AccountSettingsViewController.h"
#import "WobiViewController.h"
#import "CouponsListViewController.h"
#import "CommentListViewController.h"
#import "CollectListViewController.h"
#import "PTImagePickerController.h"
#import "PTWebViewController.h"
#import "UserInfo.h"
#import "WoBiDiDanViewController.h"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,PTImagePickerDelegate>

@property (nonatomic,assign) BOOL isLoadedView;

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,weak) MyWebButton *portraitBtn;

@property (nonatomic,strong) NSData *uploadPortraitData;

@property (nonatomic,weak) UILabel *lblWobi;

@property (nonatomic,weak) UIButton *btnSignIn;

@end

@implementation UserViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.navigationItem.title=@"个人中心";
        self.tabBarItem.title=@"用户";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_icon_user"];
        
        _userInfo=[UserInfo sharedInstance];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameUserInfo object:nil];
    }
    return self;
}

-(void)appDidFinishLaunching
{
    if(_userInfo.isLogin)
    {
        if(_userInfo.isLoginToday)
            [_userInfo requestUserInfo];
        else
            [_userInfo login];
    }
}
-(void)refresh
{
    if(self.isLoadedView)
    {
        if(_userInfo.isLogin)
        {
            if(_userInfo.isLoginToday)
                [_userInfo requestUserInfo];
            else
                [_userInfo login];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.marginTop+1, self.view.width, self.viewHeight-1) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    if(_userInfo.isLogin)
    {
        if(_userInfo.isLoginToday)
            [_userInfo requestUserInfo];
        else
            [_userInfo login];
    }
    
    self.isLoadedView=YES;
}

-(void)btnLoginTouchUp
{
    LoginViewController *loginVC=[[LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)btnSignInTouchUp
{
    if(_userInfo.isLogin && !_userInfo.isSignIn)
    {
        [_userInfo signIn];
    }
}

-(void)portraitTouchUp
{
    if(_userInfo.isLogin)
    {
        
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
        actionSheet.tag=1;
        [actionSheet showInView:self.view];
    }
    else
    {
        [MBProgressHUDManager showTextWithTitle:@"您还没有登录" inView:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameUserInfo object:nil];
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
                case 1: //获取验证码
                    
                    break;
                case 2: //注册
                    if(self.isLoadedView)
                        [_tableView reloadData];
                    break;
                case 3: //登录
                {
                    if(self.isLoadedView)
                        [_tableView reloadData];
                }
                    break;
                case 4: //用户详情
                    if(_userInfo.isLogin)
                    {
                        if([_userInfo.encryptPwd isEqualToString:_userInfo.encryptPwdFromUserDefaults])
                        {
                            [_userInfo saveUserInfo];
                        }
                        else
                        {
                            [_userInfo logout];
                        }
                    }
                    
                    if(self.isLoadedView)
                        [_tableView reloadData];
                    break;
                case 5: //上传用户头像
                    [MBProgressHUDManager hideMBProgressInView:self.view];
                    [MBProgressHUDManager showSuccessWithTitle:@"上传成功" inView:self.view];
                    
                    if(self.portraitBtn)
                    {
                        if(self.uploadPortraitData)
                        {
                            UIImage *img=[[UIImage alloc] initWithData:self.uploadPortraitData];
                            [self.portraitBtn setBackgroundImage:img forState:UIControlStateNormal];
                            self.uploadPortraitData=nil;
                        }
                    }
                    break;
                case 6: //修改用户信息
                    [_tableView reloadData];
                    break;
                case 8: //签到
                {
                    NSString *tmpstr=[[NSString alloc] initWithFormat:@"沃币：%d",_userInfo.wobi];
                    self.lblWobi.text=tmpstr;
                    [self.btnSignIn setTitle:@"已签到" forState:UIControlStateNormal];
                }
                    break;
            }
        }
        else
        {
            switch(nType)
            {
                case 3:
                {
                    NSString *msg=[dicUserInfo objectForKey:kNotificationMessageKey];
                    if(msg && [msg isEqualToString:@"密码不正确"] && _userInfo.isLogin)
                    {
                        [_userInfo logout];
                        
                        if(self.isLoadedView)
                            [_tableView reloadData];
                    }
                }
                    break;
                case 5:
                    [MBProgressHUDManager hideMBProgressInView:self.view];
                    if(hasNetworkFlags)
                        [MBProgressHUDManager showWrongWithTitle:@"上传失败" inView:self.view];
                    else
                        [MBProgressHUDManager showWrongWithTitle:@"没有网络连接" inView:self.view];
                    self.uploadPortraitData=nil;
                    break;
                case 8:
                    if(hasNetworkFlags)
                        [MBProgressHUDManager showWrongWithTitle:@"签到失败了,请重试" inView:self.view];
                    else
                        [MBProgressHUDManager showWrongWithTitle:@"没有网络连接" inView:self.view];
                    break;
            }
        }
    }
}

-(BOOL)checkLoginState
{
    if(!_userInfo.isLogin)
    {
        LoginViewController *loginVC=[[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        return NO;
    }
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - PTImagePickerDelegate
-(void)imagePicker:(PTImagePickerController *)picker didPickImage:(UIImage *)image
{
    [MBProgressHUDManager showIndicatorWithTitle:@"正在上传头像" inView:self.view];
    NSData *data=UIImageJPEGRepresentation(image, 0.5);
    self.uploadPortraitData=data;
    [_userInfo uploadPortrait:data];
}
-(void)imagePickerWillExit:(PTImagePickerController *)picker
{
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                PTImagePickerController *imagePicker=[[PTImagePickerController alloc] init];
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                imagePicker.mydelegate=self;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            break;
        case 1:
        {
            PTImagePickerController *imagePicker=[[PTImagePickerController alloc] init];
            imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mydelegate=self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0)return 120;
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1)return 10;
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float height=0.5;
    if(section==1)height=10;
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, height)];
    header.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==0)return 10;
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    float height=0.5;
    if(section==0)height=10;
    UIView *footer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, height)];
    footer.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    return footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==0)
    {
        
    }
    else if(indexPath.section==1)
    {
        if(_userInfo.isLogin)
        {
            switch(indexPath.row)
            {
                case 0:
                {
                    AccountSettingsViewController *accountVC=[[AccountSettingsViewController alloc] init];
                    accountVC.hidesBottomBarWhenPushed=YES;
                    accountVC.callback=^(BOOL isRefresh)
                    {
                        if(isRefresh)
                        {
                            [_tableView reloadData];
                        }
                    };
                    [self.navigationController pushViewController:accountVC animated:YES];
                }
                    break;
                case 1:
                {
                    CommentListViewController *commentListVC=[[CommentListViewController alloc] init];
                    commentListVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:commentListVC animated:YES];
                }
                    break;
                case 2:
                {
                    CollectListViewController *collectListVC=[[CollectListViewController alloc] init];
                    collectListVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:collectListVC animated:YES];
                }
                    break;
                case 3:
                {
                    WobiViewController *wobiVC=[[WobiViewController alloc] init];
                    wobiVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:wobiVC animated:YES];
                }
                    break;
                case 4:
                {
                    CouponsListViewController *couponsVC=[[CouponsListViewController alloc] init];
                    couponsVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:couponsVC animated:YES];
                }
                    break;
                case 5:
                {
                    WoBiDiDanViewController *wobididangVC=[[WoBiDiDanViewController alloc] init];
                    
                    [self.navigationController pushViewController:wobididangVC animated:YES];
                }
                    break;
                case 6:
                {
                    PTWebViewController *webVC=[[PTWebViewController alloc] init];
                    webVC.hidesBottomBarWhenPushed=YES;
                    webVC.navigationItem.title=@"分享";
                    webVC.urlString=@"http://viewer.maka.im/k/ORXCZ50R";
                    
                    [self.navigationController pushViewController:webVC animated:YES];
                }
                    break;
            }
        }
        else
        {
            [MBProgressHUDManager showTextWithTitle:@"您还没有登录" inView:self.view];
        }
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)return 1;
    return 7;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userCellIdentifier=@"userCellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:userCellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userCellIdentifier];
    }
    else
    {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            cell.frame=CGRectMake(0, 0, tableView.width, 120);
            cell.contentView.frame=cell.bounds;
            
            BOOL isLogin=_userInfo.isLogin;
            
            MyWebButton *webBtn=nil;
            if(isLogin)
                webBtn=[[MyWebButton alloc] initWithFrame:CGRectMake(15, 9, 70, 70)];
            else
                webBtn=[[MyWebButton alloc] initWithFrame:CGRectMake(15, (cell.height-70)/2.0, 70, 70)];
            webBtn.layer.cornerRadius=35;
            webBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
            webBtn.layer.borderWidth=0.5;
            webBtn.clipsToBounds=YES;
            if(isLogin && [_userInfo.portraitUrl isNotNilOrEmptyString])
            {
                [webBtn setBackgroundImageWithUrl:_userInfo.portraitUrl callback:nil];
            }
            else
            {
                [webBtn setBackgroundImage:[UIImage imageNamed:@"user_portrait_default"] forState:UIControlStateNormal];
            }
            [webBtn addTarget:self action:@selector(portraitTouchUp) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:webBtn];
            
            self.portraitBtn=webBtn;
            
            if(isLogin)
            {
                NSString *tmpstr=nil;
                UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(webBtn.x+webBtn.width+10, webBtn.y, 200, 18)];
                lbl.font=[UIFont systemFontOfSize:13.0];
                if([_userInfo.nickname isNotNilOrEmptyString])
                {
                    tmpstr=[[NSString alloc] initWithFormat:@"昵称：%@",_userInfo.nickname];
                    lbl.text=tmpstr;
                }
                else
                {
                    lbl.text=@"昵称：";
                }
                [cell.contentView addSubview:lbl];
                
                lbl=[[UILabel alloc] initWithFrame:CGRectMake(lbl.x, lbl.y+lbl.height+10, 200, 18)];
                lbl.font=[UIFont systemFontOfSize:13.0];
                tmpstr=[[NSString alloc] initWithFormat:@"手机：%@",_userInfo.loginId];
                lbl.text=tmpstr;
                [cell.contentView addSubview:lbl];
                
                lbl=[[UILabel alloc] initWithFrame:CGRectMake(lbl.x, lbl.y+lbl.height+10, 200, 18)];
                lbl.font=[UIFont systemFontOfSize:13.0];
                tmpstr=[[NSString alloc] initWithFormat:@"沃币：%d",_userInfo.wobi];
                lbl.text=tmpstr;
                [cell.contentView addSubview:lbl];
                
                self.lblWobi=lbl;
                
                UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.width-75, lbl.y-10, 65, 30)];
                btn.layer.cornerRadius=5;
                btn.backgroundColor=kNavigationBarBackgroundColor;
                btn.titleLabel.font=[UIFont systemFontOfSize:13.0];
                if(_userInfo.isSignIn)
                {
                    [btn setTitle:@"已签到" forState:UIControlStateNormal];
                }
                else
                {
                    [btn setTitle:@"签到" forState:UIControlStateNormal];
                }
                [btn setTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(btnSignInTouchUp) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
                
                self.btnSignIn=btn;
                
                lbl=[[UILabel alloc] initWithFrame:CGRectMake(webBtn.x, webBtn.y+webBtn.height+20, tableView.width, 18)];
                lbl.font=[UIFont systemFontOfSize:12.0];
                lbl.textColor=[UIColor colorWithWhite:0.6 alpha:1.0];
                lbl.text=@"*签到获取沃币:每日签到+1,连续签到7天,每日+2";
                [cell.contentView addSubview:lbl];
            }
            else
            {
                UIColor *color=kNavigationBarBackgroundColor;
                UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(webBtn.x+webBtn.width+30, webBtn.y+(webBtn.height-30)/2.0, 80, 30)];
                btn.layer.cornerRadius=btn.height/2;
                btn.layer.borderColor=color.CGColor;
                btn.layer.borderWidth=1;
                btn.titleLabel.font=[UIFont systemFontOfSize:15.0];
                [btn setTitleColor:color forState:UIControlStateNormal];
                [btn setTitle:@"登录" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnLoginTouchUp) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
            }
        }
    }
    else if(indexPath.section==1)
    {
        cell.frame=CGRectMake(0, 0, tableView.width, 44);
        cell.contentView.frame=cell.bounds;
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font=[UIFont systemFontOfSize:15.0];
        switch(indexPath.row)
        {
            case 0:
                cell.textLabel.text=@"账号设置";
                break;
            case 1:
                cell.textLabel.text=@"我的评论";
                break;
            case 2:
                cell.textLabel.text=@"我的收藏";
                break;
            case 3:
                cell.textLabel.text=@"沃币";
                break;
            case 4:
                cell.textLabel.text=@"优惠券";
                break;
            case 5:
                cell.textLabel.text=@"兑换订单";
                break;
            case 6:
                cell.textLabel.text=@"二维码分享";
                break;
        }
    }
    
    return cell;
}

@end
