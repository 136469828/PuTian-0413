//
//  ModifyPasswordViewController.m
//  PuTian
//
//  Created by guofeng on 15/10/15.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "ModifyPasswordViewController.h"

#import "UserInfo.h"

@interface ModifyPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *txtPwdOld;
@property (nonatomic,strong) UITextField *txtPwdNew;
@property (nonatomic,strong) UITextField *txtPwdNew2;
@property (nonatomic,weak) UITextField *currentText;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"修改密码";
    
    UIColor *tmpcolor=[[UIColor alloc] initWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    
    float defaultCellHeight=40;
    float defaultMarginLeft=15;
    float defaultFontSize=15;
    
    UIView *border=[[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.width-20, defaultCellHeight*3)];
    border.layer.borderColor=tmpcolor.CGColor;
    border.layer.borderWidth=1;
    border.layer.cornerRadius=5;
    
    _txtPwdOld=[[UITextField alloc] initWithFrame:CGRectMake(defaultMarginLeft, 0, border.width-2*defaultMarginLeft, defaultCellHeight)];
    _txtPwdOld.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _txtPwdOld.placeholder=@"输入原始密码";
    _txtPwdOld.font=[UIFont systemFontOfSize:defaultFontSize];
    _txtPwdOld.returnKeyType=UIReturnKeyNext;
    _txtPwdOld.secureTextEntry=YES;
    _txtPwdOld.delegate=self;
    [border addSubview:_txtPwdOld];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, _txtPwdOld.y+_txtPwdOld.height-1, border.width, 1)];
    line.backgroundColor=tmpcolor;
    [border addSubview:line];
    
    _txtPwdNew=[[UITextField alloc] initWithFrame:CGRectMake(defaultMarginLeft, line.y+line.height, border.width-2*defaultMarginLeft, defaultCellHeight)];
    _txtPwdNew.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _txtPwdNew.placeholder=@"输入新密码";
    _txtPwdNew.font=[UIFont systemFontOfSize:defaultFontSize];
    _txtPwdNew.returnKeyType=UIReturnKeyNext;
    _txtPwdNew.secureTextEntry=YES;
    _txtPwdNew.delegate=self;
    [border addSubview:_txtPwdNew];
    
    line=[[UIView alloc] initWithFrame:CGRectMake(0, _txtPwdNew.y+_txtPwdNew.height-1, border.width, 1)];
    line.backgroundColor=tmpcolor;
    [border addSubview:line];
    
    _txtPwdNew2=[[UITextField alloc] initWithFrame:CGRectMake(defaultMarginLeft, line.y+line.height, border.width-2*defaultMarginLeft, defaultCellHeight)];
    _txtPwdNew2.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _txtPwdNew2.placeholder=@"确认新密码";
    _txtPwdNew2.font=[UIFont systemFontOfSize:defaultFontSize];
    _txtPwdNew2.returnKeyType=UIReturnKeyDone;
    _txtPwdNew2.secureTextEntry=YES;
    _txtPwdNew2.delegate=self;
    [border addSubview:_txtPwdNew2];
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(border.x, border.y+border.height+20, border.width, 40)];
    btn.layer.cornerRadius=3;
    btn.backgroundColor=kNavigationBarBackgroundColor;
    btn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [btn setTitle:@"提 交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(modifyTouchUp) forControlEvents:UIControlEventTouchUpInside];
    
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.viewHeightWhenTabBarHided)];
    scrollView.contentSize=CGSizeMake(scrollView.width, scrollView.height+1);
    [scrollView addSubview:border];
    [scrollView addSubview:btn];
    [self.view addSubview:scrollView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameUserInfo object:nil];
}

-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    if(_currentText)
    {
        [_currentText resignFirstResponder];
        _currentText=nil;
    }
}

-(void)modifyTouchUp
{
    NSString *oldPwd=[_txtPwdOld.text trim];
    NSString *newPwd=[_txtPwdNew.text trim];
    NSString *newPwd2=[_txtPwdNew2.text trim];
    
    NSString *msg=@"";
    if(![oldPwd isNotNilOrEmptyString])
        msg=@"请输入原始密码";
    else if(![newPwd isNotNilOrEmptyString])
        msg=@"请输入新密码";
    else if(![newPwd isEqualToString:newPwd2])
        msg=@"新密码与确认密码输入不一致";
    if([msg isNotNilOrEmptyString])
    {
        [MBProgressHUDManager showTextWithTitle:msg inView:self.view];
        return;
    }
    
    if(_currentText)
    {
        [_currentText resignFirstResponder];
        _currentText=nil;
    }
    
    [MBProgressHUDManager showIndicatorWithTitle:@"正在提交" inView:self.view];
    
    [[UserInfo sharedInstance] modifyPassword:newPwd oldPassword:oldPwd];
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
            if(nType==7)
            {
                [MBProgressHUDManager hideMBProgressInView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            if(nType==7)
            {
                [MBProgressHUDManager hideMBProgressInView:self.view];
                
                NSString *msg=@"修改密码失败";
                if(!hasNetworkFlags)msg=@"没有网络连接";
                [MBProgressHUDManager showWrongWithTitle:msg inView:self.view];
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

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_txtPwdOld)
    {
        [_txtPwdNew becomeFirstResponder];
        _currentText=_txtPwdNew;
    }
    if(textField==_txtPwdNew)
    {
        [_txtPwdNew2 becomeFirstResponder];
        _currentText=_txtPwdNew2;
    }
    else
    {
        [textField resignFirstResponder];
        _currentText=nil;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentText=textField;
}

@end
