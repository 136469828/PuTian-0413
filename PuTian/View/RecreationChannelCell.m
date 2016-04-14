//
//  RecreationChannelCell.m
//  PuTian
//
//  Created by guofeng on 15/10/21.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "RecreationChannelCell.h"
#import "MyWebImage.h"

@interface RecreationChannelCell()

@property (nonatomic,strong) MyWebImage *showImageView;

@property (nonatomic,strong) UILabel *lblTitle;

@property (nonatomic,strong) UILabel *lblIntroduce;

@end

@implementation RecreationChannelCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.frame=frame;
        self.contentView.frame=self.bounds;
        
        float lblTitleHeight=18,lblIntroduceHeight=15,lblMarginTop=5;
        
        _showImageView=[[MyWebImage alloc] initWithFrame:CGRectMake(20, (frame.size.height-30)/2.0, 30, 30)];
        _showImageView.clipsToBounds=YES;
        _showImageView.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_showImageView];
        
        _lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(_showImageView.x+_showImageView.width+20, (frame.size.height-lblTitleHeight-lblIntroduceHeight-lblMarginTop)/2.0, frame.size.width-_showImageView.x-_showImageView.width-20, lblTitleHeight)];
        _lblTitle.font=[UIFont boldSystemFontOfSize:15.0];
        _lblTitle.textColor=[UIColor colorWithWhite:0.3 alpha:1.0];
        [self.contentView addSubview:_lblTitle];
        
        _lblIntroduce=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.x, _lblTitle.y+_lblTitle.height+lblMarginTop, _lblTitle.width, lblIntroduceHeight)];
        _lblIntroduce.numberOfLines=0;
        _lblIntroduce.font=[UIFont boldSystemFontOfSize:13.0];
        _lblIntroduce.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblIntroduce];
    }
    return self;
}

/** 设置展示图 */
-(void)setShowImageUrl:(NSString *)showImageUrl
{
    _showImageUrl=showImageUrl;
    
    [_showImageView setImageWithUrl:showImageUrl callback:nil];
}
/** 设置title */
-(void)setTitle:(NSString *)title
{
    _title=title;
    
    _lblTitle.text=title;
}
-(void)setIntroduce:(NSString *)introduce
{
    _introduce=introduce;
    
    _lblIntroduce.text=introduce;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
