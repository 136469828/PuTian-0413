//
//  AlertTextFieldView.h
//  PuTian
//
//  Created by guofeng on 15/10/16.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertTextFieldView;

@protocol AlertTextFieldDelegate <NSObject>

-(void)alertTextFieldView:(AlertTextFieldView *)alert text:(NSString *)text;

@optional
-(void)alertTextFieldViewDidCancel:(AlertTextFieldView *)alert;

@end

@interface AlertTextFieldView : UIView

@property (nonatomic,assign) id<AlertTextFieldDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andText:(NSString *)text andPlaceholder:(NSString *)placeholder cancelButton:(BOOL)needs andKeyboardType:(UIKeyboardType)keyboardType;

@end
