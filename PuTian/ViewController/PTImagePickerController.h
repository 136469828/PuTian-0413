//
//  PTImagePickerController.h
//  PuTian
//
//  Created by guofeng on 15/10/15.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTImagePickerController;

@protocol PTImagePickerDelegate <NSObject>

-(void)imagePicker:(PTImagePickerController *)picker didPickImage:(UIImage *)image;
-(void)imagePickerWillExit:(PTImagePickerController *)picker;

@end

@interface PTImagePickerController : UIImagePickerController

@property (nonatomic,assign) id<PTImagePickerDelegate> mydelegate;

@end
