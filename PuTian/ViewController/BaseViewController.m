//
//  BaseViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(float)navigationHeight
{
    return self.navigationController.navigationBar.frame.size.height;
}
-(float)tabBarHeight
{
    return self.tabBarController.tabBar.frame.size.height;
}
-(float)marginTop
{
    return [Common marginTop]+self.navigationHeight;
}

-(float)viewHeight
{
    return self.view.frame.size.height-self.navigationHeight-self.tabBarHeight-[Common marginTop];
}
-(float)viewHeightWhenTabBarHided
{
    return self.view.frame.size.height-self.navigationHeight-[Common marginTop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)initNavigationBackButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title  style:UIBarButtonItemStylePlain  target:self  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

-(void)initNavigationLeftButton:(NSInteger)btnSign
{
    if(self.navigationController && self.navigationController.viewControllers.count >= 2)
    {
        NSString *imgName=@"";
        switch(btnSign)
        {
            case 1:imgName=@"arrow_back1";break;
        }
        
        UIImage *image=[UIImage imageNamed:imgName];
        
        
//        CGRect frame = CGRectMake(0, 0, 88, 44);
//        UIButton *button=[[UIButton alloc] initWithFrame:frame];
//        button.imageEdgeInsets=UIEdgeInsetsMake(0, -80, 0, 0);
//        [button setImage:image forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(leftButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] initWithCustomView:button];
//        self.navigationItem.leftBarButtonItem=barButton;
        
        
        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonTouchUp)];
        self.navigationItem.leftBarButtonItem=barButton;
    }
}
-(void)leftButtonTouchUp
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pushLoginViewController
{
    LoginViewController *loginVC=[[LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
