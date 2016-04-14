//
//  IndexModelCell.h
//  PuTian
//
//  Created by guofeng on 15/10/9.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWebImage.h"

@class IndexModelCell;

@protocol IndexModelCellDelegate <NSObject>

@optional
-(void)indexModelCellWillDelete:(IndexModelCell *)cell;

@end

@interface IndexModelCell : UICollectionViewCell

@property (nonatomic,assign) id<IndexModelCellDelegate> delegate;

@property (nonatomic,strong) MyWebImage *imageView;
@property (nonatomic,strong) UILabel *lblTitle;

-(void)setMinusButtonVisible:(BOOL)visible;
-(void)setRightLineVisible:(BOOL)visible;
-(void)setAddImageViewRect;
-(void)restoreImageViewRect;

@end
