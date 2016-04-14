//
//  LoginViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/14.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ForgetPwdViewController.h"

#import "UserInfo.h"

@interface LoginViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITextField *txtLoginId;
@property (nonatomic,strong) UITextField *txtPwd;

@property (nonatomic,strong) UserInfo *userInfo;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"登录";
    
//    UIButton *rightButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
//    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(registTouchUp) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.titleLabel.font=[UIFont systemFontOfSize:15.0];
//    rightButton.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, -35);
//    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem=rightItem;
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_regist"] style:UIBarButtonItemStyleDone target:self action:@selector(registTouchUp)];
    self.navigationItem.rightBarButtonItem=barButton;
    
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.viewHeightWhenTabBarHided)];
    scrollView.contentSize=CGSizeMake(scrollView.width, scrollView.height+1);
    [self.view addSubview:scrollView];
    
    float left=20;
    float width=self.view.width-2*left;
    float height=40*[Common ratioWidthScreenWidthTo320];
    
    UIColor *colorBorder=[[UIColor alloc] initWithRed:198.0/255 green:198.0/255 blue:198.0/255 alpha:1.0];
    
    UIFont *font=[UIFont systemFontOfSize:15.0];
    
    UIView *border=[[UIView alloc] initWithFrame:CGRectMake(left, 20, width, height)];
    border.layer.cornerRadius=5;
    border.layer.borderWidth=1;
    border.layer.borderColor=colorBorder.CGColor;
    [scrollView addSubview:border];
    
    _txtLoginId=[[UITextField alloc] initWithFrame:CGRectMake(15, 0, width-30, height)];
    _txtLoginId.borderStyle=UITextBorderStyleNone;
    _txtLoginId.placeholder=@"手机号";
    _txtLoginId.keyboardType=UIKeyboardTypeNumberPad;
    _txtLoginId.autocorrectionType=UITextAutocorrectionTypeNo;
    _txtLoginId.font=font;
    [border addSubview:_txtLoginId];
    
    border=[[UIView alloc] initWithFrame:CGRectMake(left, border.y+border.height+10, width, height)];
    border.layer.cornerRadius=5;
    border.layer.borderWidth=1;
    border.layer.borderColor=colorBorder.CGColor;
    [scrollView addSubview:border];
    
    _txtPwd=[[UITextField alloc] initWithFrame:CGRectMake(15, 0, width-30, height)];
    _txtPwd.borderStyle=UITextBorderStyleNone;
    _txtPwd.placeholder=@"密码";
    _txtPwd.font=font;
    _txtPwd.secureTextEntry=YES;
    [border addSubview:_txtPwd];
    
    UIButton *btnForget=[[UIButton alloc] initWithFrame:CGRectMake(border.x+border.width-70, border.y+border.height+10, 80, 30)];
    btnForget.titleLabel.font=[UIFont systemFontOfSize:12.0];
    [btnForget setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [btnForget setTitleColor:kNavigationBarBackgroundColor forState:UIControlStateNormal];
    [btnForget setTitleColor:kNavigationBarBackgroundColorWithAlpha(0.5) forState:UIControlStateHighlighted];
    [btnForget addTarget:self action:@selector(forgetTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnForget];
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(left, btnForget.y+btnForget.height+10, width, 40)];
    btn.layer.cornerRadius=3;
    btn.backgroundColor=kNavigationBarBackgroundColor;
    btn.titleLabel.font=font;
    [btn setTitle:@"登  录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(loginTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameUserInfo object:nil];
    
    _userInfo=[UserInfo sharedInstance];
    
}

-(void)forgetTouchUp
{
    ForgetPwdViewController *forgetVC=[[ForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

-(void)loginTouchUp
{
    if(![Common hasNetworkFlags])
    {
        [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
        return;
    }
    
    NSString *mobile=[_txtLoginId.text trim];
    NSString *pwd=[_txtPwd.text trim];
    if(![mobile isNotNilOrEmptyString])
    {
        [MBProgressHUDManager showTextWithTitle:@"请输入手机号" inView:self.view];
        return;
    }
    else if(![mobile isMobile])
    {
        [MBProgressHUDManager showTextWithTitle:@"请输入正确的手机号" inView:self.view];
        return;
    }
    else if(![pwd isNotNilOrEmptyString])
    {
        [MBProgressHUDManager showTextWithTitle:@"请输入密码" inView:self.view];
        return;
    }
    
    [MBProgressHUDManager showIndicatorWithTitle:@"正在登录" inView:self.view];
    
    _userInfo.loginId=mobile;
    _userInfo.pwd=pwd;
    [_userInfo login];
}
-(void)registTouchUp
{
    RegistViewController *registVC=[[RegistViewController alloc] init];
    registVC.registCallback=^(BOOL succeed)
    {
        if(succeed)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [self.navigationController pushViewController:registVC animated:YES];
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
                case 3: //登录
                    [MBProgressHUDManager hideMBProgressInView:self.view];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
            }
        }
        else
        {
            switch(nType)
            {
                case 3:
                    [MBProgressHUDManager hideMBProgressInView:self.view];
                    
                    if(hasNetworkFlags)
                        [MBProgressHUDManager showTextWithTitle:@"登录失败" inView:self.view];
                    else
                        [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
                    break;
            }
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(_txtLoginId.isFirstResponder)
    {
        [_txtLoginId resignFirstResponder];
        return YES;
    }
    else if(_txtPwd.isFirstResponder)
    {
        [_txtPwd resignFirstResponder];
        return YES;
    }
    return NO;
}

@end
