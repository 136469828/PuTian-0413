//
//  AccountSettingsViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/18.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "AccountSettingsViewController.h"
#import "ModifyPasswordViewController.h"
#import "AlertTextFieldView.h"

#import "UserInfo.h"

@interface AccountSettingsViewController ()<UITableViewDataSource,UITableViewDelegate,AlertTextFieldDelegate>

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) AlertTextFieldView *alertTextView;

@end

@implementation AccountSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"账号设置";
    
    _userInfo=[UserInfo sharedInstance];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.marginTop+1, self.view.width, self.viewHeight-1) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameUserInfo object:nil];
}

-(void)logoutTouchUp
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"确定要退出登录吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            if(nType==6)
            {
                [_tableView reloadData];
                
                [MBProgressHUDManager hideMBProgressInView:self.view];
                [MBProgressHUDManager showSuccessWithTitle:@"修改昵称成功" inView:self.view];
            }
        }
        else
        {
            if(nType==6)
            {
                [MBProgressHUDManager hideMBProgressInView:self.view];
                
                NSString *msg=@"修改昵称失败";
                if(!hasNetworkFlags)msg=@"没有网络连接";
                [MBProgressHUDManager showWrongWithTitle:msg inView:self.view];
            }
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameUserInfo object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - AlertTextFieldDelegate
-(void)alertTextFieldView:(AlertTextFieldView *)alert text:(NSString *)text
{
    NSString *nickname=[text trim];
    if(![nickname isNotNilOrEmptyString])
    {
        [MBProgressHUDManager showCenterTextWithTitle:@"昵称不能为空" inView:self.view];
        return;
    }
    
    if(_alertTextView)
    {
        [_alertTextView removeFromSuperview];
        self.alertTextView=nil;
    }
    
    if(![nickname isEqualToString:_userInfo.nickname])
    {
        [MBProgressHUDManager showIndicatorWithTitle:@"正在提交" inView:self.view];
        
        [_userInfo modifyUserInfoWithNickName:nickname];
    }
}
-(void)alertTextFieldViewDidCancel:(AlertTextFieldView *)alert
{
    if(_alertTextView)
    {
        [_alertTextView removeFromSuperview];
        self.alertTextView=nil;
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        //退出登录
        [_userInfo logout];
        
        if(_callback)
        {
            _callback(YES);
            self.callback=nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 100)];
    
    float height=40*[Common ratioWidthScreenWidthTo320];
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(20, (100-height)/2.0, tableView.width-40, height)];
    btn.layer.cornerRadius=3;
    btn.backgroundColor=kNavigationBarBackgroundColor;
    btn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [btn setTitle:@"注销账号" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(logoutTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    
    return footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(indexPath.row)
    {
        case 1:
        {
            UIWindow *window=[UIApplication sharedApplication].keyWindow;
            _alertTextView=[[AlertTextFieldView alloc] initWithFrame:window.bounds andTitle:@"修改昵称" andText:_userInfo.nickname andPlaceholder:@"输入昵称" cancelButton:YES andKeyboardType:UIKeyboardTypeDefault];
            _alertTextView.delegate=self;
            [window addSubview:_alertTextView];
        }
            break;
        case 2:
        {
            ModifyPasswordViewController *modifyPwdVC=[[ModifyPasswordViewController alloc] init];
            [self.navigationController pushViewController:modifyPwdVC animated:YES];
        }
            break;
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *accountSettingsCellIdentifier=@"accountSettingsCellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:accountSettingsCellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:accountSettingsCellIdentifier];
    }
    else
    {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if(indexPath.section==0)
    {
        cell.frame=CGRectMake(0, 0, tableView.width, 44);
        cell.contentView.frame=cell.bounds;
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font=[UIFont systemFontOfSize:15.0];
        
        switch(indexPath.row)
        {
            case 0:
                cell.textLabel.text=@"手机号";
                cell.detailTextLabel.text=_userInfo.loginId;
                break;
            case 1:
                cell.textLabel.text=@"昵称";
                cell.detailTextLabel.text=_userInfo.nickname;
                break;
            case 2:
                cell.textLabel.text=@"修改密码";
                break;
        }
    }
    
    return cell;
}

@end
