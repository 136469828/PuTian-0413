//
//  AddSquareCell.m
//  PuTian
//
//  Created by guofeng on 15/10/17.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "AddSquareCell.h"
#import "MyWebImage.h"

@interface AddSquareCell()

@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UIButton *btnAdd;

@end

@implementation AddSquareCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.frame=frame;
        self.contentView.frame=self.bounds;
        
        _btnAdd=[[UIButton alloc] initWithFrame:CGRectMake(self.contentView.width-self.contentView.height, 0, self.contentView.height, self.contentView.height)];
        [_btnAdd setImage:[UIImage imageNamed:@"index_add2"] forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(addTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnAdd];
        
        _lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, (self.contentView.height-20)/2.0, self.contentView.width-_btnAdd.width-20, 20)];
        _lblTitle.font=[UIFont boldSystemFontOfSize:15.0];
        [self.contentView addSubview:_lblTitle];
        
    }
    return self;
}

-(void)addTouchUp
{
    _isChecked=!_isChecked;
    
    if(_isChecked)
    {
        [_btnAdd setImage:[UIImage imageNamed:@"index_checked"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnAdd setImage:[UIImage imageNamed:@"index_add2"] forState:UIControlStateNormal];
    }
    
    if([_delegate respondsToSelector:@selector(addSquareCell:didClickAddButton:)])
    {
        [_delegate addSquareCell:self didClickAddButton:_isChecked];
    }
}

-(void)setTitle:(NSString *)title
{
    _title=title;
    
    _lblTitle.text=title;
}
-(void)setIsChecked:(BOOL)isChecked
{
    if(_isChecked==isChecked)return;
    
    _isChecked=isChecked;
    
    if(_isChecked)
    {
        [_btnAdd setImage:[UIImage imageNamed:@"index_checked"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnAdd setImage:[UIImage imageNamed:@"index_add2"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
