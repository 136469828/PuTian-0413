//
//  AddIndexModelCell.m
//  PuTian
//
//  Created by guofeng on 15/10/16.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "AddIndexModelCell.h"

@interface AddIndexModelCell()

@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UIButton *btnAdd;

@end

@implementation AddIndexModelCell

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
        
//        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.height-0.5, self.contentView.width, 0.5)];
//        line.backgroundColor=[UIColor colorWithWhite:0.8 alpha:1.0];
//        [self.contentView addSubview:line];
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
    
    if([_delegate respondsToSelector:@selector(addIndexModelCell:didClickAddButton:)])
    {
        [_delegate addIndexModelCell:self didClickAddButton:_isChecked];
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
