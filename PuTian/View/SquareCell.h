//
//  SquareCell.h
//  PuTian
//
//  Created by guofeng on 15/10/10.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebImage.h"

@class SquareCell;

@protocol SquareCellDelegate <NSObject>

@optional
-(void)squareCellWillDelete:(SquareCell *)cell;

@end

@interface SquareCell : UICollectionViewCell

@property (nonatomic,assign) id<SquareCellDelegate> delegate;

@property (nonatomic,strong) MyWebImage *imageView;
@property (nonatomic,strong) UILabel *lblTitle;

-(void)setMinusButtonVisible:(BOOL)visible;
-(void)setRightLineVisible:(BOOL)visible;
-(void)setAddImageViewRect;
-(void)restoreImageViewRect;

@end
