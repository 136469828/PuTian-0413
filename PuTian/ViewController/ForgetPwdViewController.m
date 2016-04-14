//
//  ForgetPwdViewController.m
//  PuTian
//
//  Created by guofeng on 15/10/28.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "UserInfo.h"

@interface ForgetPwdViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger countdown;

@property (nonatomic,strong) UITextField *txtLoginId;
@property (nonatomic,strong) UITextField *txtVerifyCode;
@property (nonatomic,strong) UITextField *txtPwd;
@property (nonatomic,strong) UIButton *btnVerifyCode;

@property (nonatomic,weak) UITextField *currentText;

@property (nonatomic,strong) UserInfo *userInfo;

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.navigationItem.title=@"重新设置密码";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.viewHeightWhenTabBarHided)];
    scrollView.contentSize=CGSizeMake(scrollView.width, scrollView.height+1);
    [self.view addSubview:scrollView];
    
    float left=20;
    float width=self.view.width-2*left;
    float height=40*[Common ratioWidthScreenWidthTo320];
    
    UIColor *colorBorder=[[UIColor alloc] initWithRed:198.0/255 green:198.0/255 blue:198.0/255 alpha:1.0];
    UIColor *colorVerifyCode=[[UIColor alloc] initWithRed:253.0/255 green:253.0/255 blue:253.0/255 alpha:1.0];
    
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
    _txtLoginId.delegate=self;
    [border addSubview:_txtLoginId];
    
    border=[[UIView alloc] initWithFrame:CGRectMake(left, border.y+border.height+10, (width-10)*0.6, height)];
    border.layer.cornerRadius=5;
    border.layer.borderWidth=1;
    border.layer.borderColor=colorBorder.CGColor;
    [scrollView addSubview:border];
    
    _txtVerifyCode=[[UITextField alloc] initWithFrame:CGRectMake(15, 0, border.width-30, height)];
    _txtVerifyCode.borderStyle=UITextBorderStyleNone;
    _txtVerifyCode.placeholder=@"输入验证码";
    _txtVerifyCode.keyboardType=UIKeyboardTypeNumberPad;
    _txtVerifyCode.autocorrectionType=UITextAutocorrectionTypeNo;
    _txtVerifyCode.font=font;
    _txtVerifyCode.delegate=self;
    [border addSubview:_txtVerifyCode];
    
    _btnVerifyCode=[[UIButton alloc] initWithFrame:CGRectMake(border.x+border.width+10, border.y, (width-10)*0.4, height)];
    _btnVerifyCode.layer.cornerRadius=5;
    _btnVerifyCode.layer.borderWidth=1;
    _btnVerifyCode.layer.borderColor=colorBorder.CGColor;
    _btnVerifyCode.backgroundColor=colorVerifyCode;
    _btnVerifyCode.titleLabel.font=font;
    [_btnVerifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_btnVerifyCode setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0] forState:UIControlStateNormal];
    [_btnVerifyCode setTitleColor:[UIColor colorWithWhite:0.7 alpha:1.0] forState:UIControlStateHighlighted];
    [_btnVerifyCode addTarget:self action:@selector(verifyCodeTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_btnVerifyCode];
    
    border=[[UIView alloc] initWithFrame:CGRectMake(left, border.y+border.height+10, width, height)];
    border.layer.cornerRadius=5;
    border.layer.borderWidth=1;
    border.layer.borderColor=colorBorder.CGColor;
    [scrollView addSubview:border];
    
    _txtPwd=[[UITextField alloc] initWithFrame:CGRectMake(15, 0, width-30, height)];
    _txtPwd.borderStyle=UITextBorderStyleNone;
    _txtPwd.placeholder=@"密码";
    _txtPwd.autocorrectionType=UITextAutocorrectionTypeNo;
    _txtPwd.font=font;
    _txtPwd.secureTextEntry=YES;
    _txtPwd.delegate=self;
    [border addSubview:_txtPwd];
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(left, border.y+border.height+20, width, height)];
    btn.layer.cornerRadius=3;
    btn.backgroundColor=kNavigationBarBackgroundColor;
    btn.titleLabel.font=font;
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(submitTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameUserInfo object:nil];
    
    _userInfo=[UserInfo sharedInstance];
}

-(void)timerEvent
{
    if(self.countdown>0)
    {
        _countdown--;
        NSString *tmpstr=[[NSString alloc] initWithFormat:@"%d秒后重发",_countdown];
        [_btnVerifyCode setTitle:tmpstr forState:UIControlStateNormal];
    }
    else
    {
        [self disposeTimer];
        
        _btnVerifyCode.userInteractionEnabled=YES;
        [_btnVerifyCode setTitle:@"重新获取" forState:UIControlStateNormal];
    }
}
-(void)disposeTimer
{
    if(_timer)
    {
        if(_timer.isValid)
            [_timer invalidate];
        self.timer=nil;
    }
}

-(void)verifyCodeTouchUp
{
    if(![Common hasNetworkFlags])
    {
        [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
        return;
    }
    
    NSString *mobile=[_txtLoginId.text trim];
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
    

    
    [self disposeTimer];
    
    self.countdown=60;
    _btnVerifyCode.userInteractionEnabled=NO;
    [_btnVerifyCode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.countdown] forState:UIControlStateNormal];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    
    [_userInfo requestVerifyCodeForForgetPwd];
    
    
}
-(void)submitTouchUp
{
    if(![Common hasNetworkFlags])
    {
        [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
        return;
    }
    
    NSString *mobile=[_txtLoginId.text trim];
    NSString *verifyCode=[_txtVerifyCode.text trim];
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
    else if(![verifyCode isNotNilOrEmptyString])
    {
        [MBProgressHUDManager showTextWithTitle:@"请输入验证码" inView:self.view];
        return;
    }
    else if(![pwd isNotNilOrEmptyString])
    {
        [MBProgressHUDManager showTextWithTitle:@"请输入密码" inView:self.view];
        return;
    }
    
    [MBProgressHUDManager showIndicatorWithTitle:@"正在提交" inView:self.view];
    
    [_userInfo resetPassword:pwd mobile:mobile verifyCode:verifyCode];
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
                case 9: //获取验证码
                    
                    break;
                case 10: //重新设置密码
                    [MBProgressHUDManager hideMBProgressInView:self.view];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
            }
        }
        else
        {
            switch(nType)
            {
                case 9: //获取验证码
                    if(!hasNetworkFlags)
                    {
                        [self disposeTimer];
                        _btnVerifyCode.userInteractionEnabled=YES;
                        [_btnVerifyCode setTitle:@"重新获取" forState:UIControlStateNormal];
                        
                        [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
                    }
                    break;
                case 10: //重新设置密码
                {
                    [MBProgressHUDManager hideMBProgressInView:self.view];
                    
                    NSString *hint=@"提交失败";
                    if(hasNetworkFlags)
                    {
                        NSString *message=[dicUserInfo objectForKey:kNotificationMessageKey];
                        if([message isNotNilOrEmptyString])
                        {
                            if([message rangeOfString:@"验证码错误"].location!=NSNotFound)
                                hint=@"验证码错误";
                            else if([message rangeOfString:@"未注册"].location!=NSNotFound)
                                hint=@"手机号码还未注册";
                        }
                    }
                    else
                    {
                        hint=@"未连接网络";
                    }
                    [MBProgressHUDManager showWrongWithTitle:hint inView:self.view];
                }
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
    if(_currentText && _currentText.isFirstResponder)
    {
        [_currentText resignFirstResponder];
        return YES;
    }
    return NO;
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentText=textField;
}

@end
