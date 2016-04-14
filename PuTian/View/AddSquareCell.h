//
//  AddSquareCell.h
//  PuTian
//
//  Created by guofeng on 15/10/17.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddSquareCell;

#define AddSquareCellHeight 60.0

@protocol AddSquareDelegate <NSObject>

-(void)addSquareCell:(AddSquareCell *)cell didClickAddButton:(BOOL)isChecked;

@end

@interface AddSquareCell : UITableViewCell

@property (nonatomic,assign) id<AddSquareDelegate> delegate;
@property (nonatomic,weak) id model;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign) BOOL isChecked;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end
