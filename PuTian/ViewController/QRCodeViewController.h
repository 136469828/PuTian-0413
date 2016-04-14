//
//  QRCodeViewController.h
//  PuTian
//
//  Created by guofeng on 15/9/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class QRCodeViewController;

@protocol QRCodeVCDelegate <NSObject>

-(void)QRCodeViewControllerDidScanUrl:(QRCodeViewController *)controller;

@end

@interface QRCodeViewController : BaseViewController

@property (nonatomic,assign) id<QRCodeVCDelegate> delegate;
@property (nonatomic,copy) NSString *urlString;

@end
