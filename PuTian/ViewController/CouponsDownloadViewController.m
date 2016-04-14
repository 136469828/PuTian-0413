//
//  CouponsDownloadViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/14.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "CouponsDownloadViewController.h"
#import "UserInfo.h"
#import "CouponsDownload.h"

@interface CouponsDownloadViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblPrice;
@property (nonatomic,strong) UITextField *txtCount;
@property (nonatomic,strong) UILabel *lblTotalPrice;
@property (nonatomic,strong) UILabel *lblMobile;

@property (nonatomic,strong) CouponsDownload *download;

@end

@implementation CouponsDownloadViewController

-(void)setShopName:(NSString *)shopName
{
    _shopName=shopName;
    
    if(_lblName && [shopName isNotNilOrEmptyString])
    {
        NSString *tmpstr=[[NSString alloc] initWithFormat:@"%@代金券",shopName];
        _lblName.text=tmpstr;
    }
}

-(void)leftButtonTouchUp
{
    if(_dismissEventBlock)
    {
        _dismissEventBlock();
        self.dismissEventBlock=nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.navigationItem.title=@"下载优惠券";
    
    float cellHeight=40;
    UIView *border=[[UIView alloc] initWithFrame:CGRectMake(5, self.marginTop+20, self.view.width-10, cellHeight*3)];
    border.layer.cornerRadius=3;
    border.layer.borderWidth=1;
    border.layer.borderColor=[UIColor grayColor].CGColor;
    border.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:border];
    
    NSString *tmpstr=nil;
    float left=10;
    _lblName=[[UILabel alloc] initWithFrame:CGRectMake(left, 0, 185*[Common ratioWidthScreenWidthTo320], cellHeight)];
    _lblName.font=[UIFont systemFontOfSize:15.0];
    if([_shopName isNotNilOrEmptyString])
    {
        tmpstr=[[NSString alloc] initWithFormat:@"%@代金券",_shopName];
        _lblName.text=tmpstr;
    }
    else
    {
        _lblName.text=@"代金券";
    }
    [border addSubview:_lblName];
    
    _lblPrice=[[UILabel alloc] initWithFrame:CGRectMake(border.width-left*2-150, 0, 150, cellHeight)];
    _lblPrice.textAlignment=NSTextAlignmentRight;
    _lblPrice.font=[UIFont systemFontOfSize:15.0];
    NSInteger iPrice=_price;
    if(iPrice==_price)
        tmpstr=[[NSString alloc] initWithFormat:@"%d元",iPrice];
    else
        tmpstr=[[NSString alloc] initWithFormat:@"%.2f元",_price];
    _lblPrice.text=tmpstr;
    [border addSubview:_lblPrice];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, cellHeight, border.width, 0.5)];
    line.backgroundColor=[UIColor grayColor];
    [border addSubview:line];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(left, cellHeight, 100, cellHeight)];
    lbl.font=[UIFont systemFontOfSize:15.0];
    lbl.text=@"数量";
    [border addSubview:lbl];
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(border.width-left-124, cellHeight+(cellHeight-36)/2.0, 36, 36)];
    btn.layer.borderColor=[UIColor blackColor].CGColor;
    btn.layer.borderWidth=1;
    btn.layer.cornerRadius=3;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"-" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reduceCount) forControlEvents:UIControlEventTouchUpInside];
    [border addSubview:btn];
    
    _txtCount=[[UITextField alloc] initWithFrame:CGRectMake(btn.x+btn.width+1, btn.y, 50, 36)];
    _txtCount.layer.borderWidth=1;
    _txtCount.layer.borderColor=[UIColor grayColor].CGColor;
    _txtCount.textAlignment=NSTextAlignmentCenter;
    _txtCount.font=[UIFont systemFontOfSize:15.0];
    _txtCount.keyboardType=UIKeyboardTypeNumberPad;
    _txtCount.delegate=self;
    [border addSubview:_txtCount];
    
    btn=[[UIButton alloc] initWithFrame:CGRectMake(_txtCount.x+_txtCount.width+1, btn.y, btn.width, btn.height)];
    btn.layer.borderColor=[UIColor blackColor].CGColor;
    btn.layer.borderWidth=1;
    btn.layer.cornerRadius=3;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"+" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addCount) forControlEvents:UIControlEventTouchUpInside];
    [border addSubview:btn];
    
    line=[[UIView alloc] initWithFrame:CGRectMake(0, cellHeight*2, border.width, 0.5)];
    line.backgroundColor=[UIColor grayColor];
    [border addSubview:line];
    
    lbl=[[UILabel alloc] initWithFrame:CGRectMake(left, cellHeight*2, 100, cellHeight)];
    lbl.font=[UIFont systemFontOfSize:15.0];
    lbl.text=@"小计";
    [border addSubview:lbl];
    
    _lblTotalPrice=[[UILabel alloc] initWithFrame:CGRectMake(border.width-left*2-150, cellHeight*2, 150, cellHeight)];
    _lblTotalPrice.textAlignment=NSTextAlignmentRight;
    _lblTotalPrice.font=[UIFont systemFontOfSize:15.0];
    _lblTotalPrice.textColor=[UIColor redColor];
    [border addSubview:_lblTotalPrice];
    
    [self setCouponsCount:_count];
    
    lbl=[[UILabel alloc] initWithFrame:CGRectMake(10, border.y+border.height+10, 200, 20)];
    lbl.font=[UIFont systemFontOfSize:15.0];
    lbl.text=@"您绑定的手机号码";
    [self.view addSubview:lbl];
    
    border=[[UIView alloc] initWithFrame:CGRectMake(5, lbl.y+lbl.height+5, self.view.width-10, cellHeight)];
    border.layer.cornerRadius=3;
    border.layer.borderWidth=1;
    border.layer.borderColor=[UIColor grayColor].CGColor;
    border.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:border];
    
    _lblMobile=[[UILabel alloc] initWithFrame:CGRectMake(left, 0, border.width, border.height)];
    _lblMobile.font=[UIFont systemFontOfSize:15.0];
    if([UserInfo sharedInstance].isLogin)
    {
//        tmpstr=[UserInfo sharedInstance].loginId;
//        if([tmpstr isNotNilOrEmptyString] && tmpstr.length>=11)
//        {
//            NSString *tmpstr2=[[NSString alloc] initWithFormat:@"%@****%@"
//                               ,[tmpstr substringWithRange:NSMakeRange(0, 3)]
//                               ,[tmpstr substringWithRange:NSMakeRange(7, tmpstr.length-7)]];
//            _lblMobile.text=tmpstr2;
//        }
        _lblMobile.text=[UserInfo sharedInstance].loginId;
    }
    [border addSubview:_lblMobile];
    
    btn=[[UIButton alloc] initWithFrame:CGRectMake(5, border.y+border.height+20, self.view.width-10, 40)];
    btn.layer.cornerRadius=3;
    btn.backgroundColor=kNavigationBarBackgroundColor;
    btn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn setTitle:@"下载优惠券" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(downloadTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameCouponsDownload object:nil];
    
    _download=[[CouponsDownload alloc] init];
    _download.notificationName=kNotificationNameCouponsDownload;
    _download.userid=[UserInfo sharedInstance].userid;
    _download.productid=_productid;
}

-(void)reduceCount
{
    NSInteger count=[_txtCount.text integerValue]-1;
    if(count<0)count=0;
    [self setCouponsCount:count];
}
-(void)addCount
{
    NSInteger count=[_txtCount.text integerValue]+1;
    [self setCouponsCount:count];
}
-(void)setCouponsCount:(NSInteger)count
{
    if(count>_inventory)return;
    
    _txtCount.text=[@(count) stringValue];
    
    NSString *text=nil;
    float totalPrice=_price*count;
    NSInteger iPrice=(NSInteger)totalPrice;
    if(iPrice==totalPrice)
        text=[[NSString alloc] initWithFormat:@"%d元",iPrice];
    else
        text=[[NSString alloc] initWithFormat:@"%.2f元",totalPrice];
    _lblTotalPrice.text=text;
}

-(void)downloadTouchUp
{
    NSInteger count=[_txtCount.text integerValue];
    if(count<=0)
    {
        [MBProgressHUDManager showTextWithTitle:@"优惠券数量不能为0" inView:self.view];
        return;
    }
    if(count>_inventory)
    {
        NSString *msg=[[NSString alloc] initWithFormat:@"剩余优惠券已不足%d",count];
        [MBProgressHUDManager showTextWithTitle:msg inView:self.view];
        return;
    }
    
    [MBProgressHUDManager showIndicatorWithTitle:@"正在提交" inView:self.view];
    [_download downloadWithCount:count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_download disposeRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameCouponsDownload object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameCouponsDownload])
    {
        if(notification.object==_download)
        {
            [MBProgressHUDManager hideMBProgressInView:self.view];
            NSDictionary *dicUserInfo=notification.userInfo;
            BOOL hasNetworkFlags=[[dicUserInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
            BOOL succeed=[[dicUserInfo objectForKey:kNotificationSucceedKey] boolValue];
            if(succeed)
            {
                [MBProgressHUDManager showTextWithTitle:@"下载成功" inView:self.view];
                dispatch_async(dispatch_get_global_queue(0, 0), ^
                {
                    [NSThread sleepForTimeInterval:2.0];
                    dispatch_sync(dispatch_get_main_queue(), ^
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                });
            }
            else
            {
                if(hasNetworkFlags)
                    [MBProgressHUDManager showTextWithTitle:@"下载失败了" inView:self.view];
                else
                    [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
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
    if(_txtCount.isFirstResponder)
    {
        [_txtCount resignFirstResponder];
        return YES;
    }
    return NO;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tmpstr=nil;
    if([textField.text isNotNilOrEmptyString])
        tmpstr=[textField.text stringByReplacingCharactersInRange:range withString:string];
    else
        tmpstr=string;
    if([tmpstr integerValue]>_inventory)
        return NO;
    return YES;
}

@end
