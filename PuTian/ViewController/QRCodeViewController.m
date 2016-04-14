//
//  QRCodeViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "QRCodeViewController.h"
#import "PTWebViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice * device;

@property (strong,nonatomic)AVCaptureDeviceInput * input;

@property (strong,nonatomic)AVCaptureMetadataOutput * output;

@property (strong,nonatomic)AVCaptureSession * session;

@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic,strong) UIImageView *pickBorder;
@property (nonatomic,strong) UIImageView *line;

@property (nonatomic,assign) int num;
@property (nonatomic,assign) BOOL isDown;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationLeftButton:1];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"扫一扫";
    
    _pickBorder = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 220, 220)];
    _pickBorder.center=self.view.center;
    _pickBorder.image = [UIImage imageNamed:@"index_QRCode_pick"];
    [self.view addSubview:_pickBorder];
    
    self.isDown=YES;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(_pickBorder.x, _pickBorder.y, 220, 5)];
    _line.image = [UIImage imageNamed:@"index_QRCode_line"];
    [self.view addSubview:_line];
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    [_output setRectOfInterest:CGRectMake((kScreenSize.height-220)/2.0/kScreenSize.height,((kScreenSize.width-220)/2.0)/kScreenSize.width,220/kScreenSize.height,220/kScreenSize.width)];
    
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    
    _preview.frame =self.view.layer.bounds;
    
    [self.view.layer insertSublayer:_preview atIndex:0];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startTimer];
    
    [_session startRunning];
}

-(void)startTimer
{
    if(_timer)
    {
        if(_timer.isValid)
            [_timer invalidate];
        self.timer=nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
}
-(void)timerEvent
{
    if (self.isDown)
    {
        _num++;
        _line.y=_pickBorder.y+_line.height*_num;
        if (_line.height*_num >= _pickBorder.height)
        {
            self.isDown = NO;
        }
    }
    else
    {
        _num--;
        _line.y=_pickBorder.y+_line.height*_num;
        if (_num == 0)
        {
            self.isDown = YES;
        }
    }
    
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex!=alertView.cancelButtonIndex)
    {
        if(buttonIndex==1)
        {
            PTWebViewController *webVC=[[PTWebViewController alloc] init];
            webVC.urlString=_urlString;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        else if(buttonIndex==2)
        {
            NSURL *url=[[NSURL alloc] initWithString:_urlString];
            [[UIApplication sharedApplication] openURL:url];
            
            [self startTimer];
            [_session startRunning];
        }
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        
        if(_timer)
        {
            if(_timer.isValid)
               [_timer invalidate];
            self.timer=nil;
        }
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        if([stringValue isUrl])
        {
            self.urlString=stringValue;
            
            NSString *msg=[[NSString alloc] initWithFormat:@"确定要打开%@?",stringValue];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"扫描结果" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"App内打开", @"浏览器中打开", nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"扫描结果" message:stringValue delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

@end
