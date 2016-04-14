//
//  PTImagePickerController.m
//  PuTian
//
//  Created by guofeng on 15/10/15.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "PTImagePickerController.h"

@interface PTImagePickerController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIView *activityBG;
@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property (nonatomic,strong) UILabel *lblHint;

@end

@implementation PTImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate=self;
    self.allowsEditing=YES;
}

-(void)showHint
{
    if(_activityBG==nil)
    {
        _activityBG=[[UIView alloc] initWithFrame:self.view.bounds];
        _activityBG.backgroundColor=[UIColor blackColor];
        _activityBG.alpha=0.7;
        [self.view addSubview:_activityBG];
        
        _activity=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _activity.center=self.view.center;
        _activity.transform=CGAffineTransformScale(_activity.transform, 1.5, 1.5);
        [_activity startAnimating];
        [self.view addSubview:_activity];
        
        _lblHint=[[UILabel alloc] initWithFrame:CGRectMake(0, _activity.frame.origin.y+_activity.frame.size.height+3, self.view.frame.size.width, 20)];
        _lblHint.backgroundColor=[UIColor clearColor];
        _lblHint.font=[UIFont systemFontOfSize:16.0];
        _lblHint.textColor=[UIColor whiteColor];
        _lblHint.textAlignment=NSTextAlignmentCenter;
        _lblHint.text=@"正在处理";
        [self.view addSubview:_lblHint];
    }
}
-(void)removeHint
{
    if(_activity)
    {
        if(_activity.isAnimating)
            [_activity stopAnimating];
        [_activity removeFromSuperview];
        self.activity=nil;
        [_lblHint removeFromSuperview];
        self.lblHint=nil;
        [_activityBG removeFromSuperview];
        self.activityBG=nil;
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

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=nil;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"])
    {
        if(self.allowsEditing)
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        else
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if([_mydelegate respondsToSelector:@selector(imagePicker:didPickImage:)])
        [_mydelegate imagePicker:self didPickImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if([_mydelegate respondsToSelector:@selector(imagePickerWillExit:)])
        [_mydelegate imagePickerWillExit:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
