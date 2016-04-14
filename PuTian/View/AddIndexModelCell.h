//
//  AddIndexModelCell.h
//  PuTian
//
//  Created by guofeng on 15/10/16.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddIndexModelCell;

#define AddIndexModelCellHeight 60.0

@protocol AddIndexModelDelegate <NSObject>

-(void)addIndexModelCell:(AddIndexModelCell *)cell didClickAddButton:(BOOL)isChecked;

@end

@interface AddIndexModelCell : UITableViewCell

@property (nonatomic,assign) id<AddIndexModelDelegate> delegate;
@property (nonatomic,weak) id model;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign) BOOL isChecked;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end
