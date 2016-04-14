//
//  VideoCell.m
//  PuTian
//
//  Created by guofeng on 15/9/18.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "VideoCell.h"
#import "MyWebButton.h"

@interface VideoCell()

@property (nonatomic,strong) MyWebButton *showImageView1;
@property (nonatomic,strong) UILabel *lblTitle1;
@property (nonatomic,strong) UILabel *lblIntroduce1;

@property (nonatomic,strong) MyWebButton *showImageView2;
@property (nonatomic,strong) UILabel *lblTitle2;
@property (nonatomic,strong) UILabel *lblIntroduce2;

@end

@implementation VideoCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.frame=frame;
        self.contentView.frame=self.bounds;
        
        float marginLeft=2,marginTop=10;
        float width=(frame.size.width-marginLeft)/2.0;
        float height=width/2;
        float lblHeight=18,lblMarginTop=3;
        
        _showImageView1=[[MyWebButton alloc] initWithFrame:CGRectMake(0, marginTop, width, height)];
        _showImageView1.hidden=YES;
        _showImageView1.clipsToBounds=YES;
        _showImageView1.imageView.contentMode=UIViewContentModeScaleAspectFill;
        [_showImageView1 addTarget:self action:@selector(showImageTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_showImageView1];
        
        //UIColor *color=[[UIColor alloc] initWithRed:9.0/255 green:126.0/255 blue:198.0/255 alpha:1.0];
        _lblTitle1=[[UILabel alloc] initWithFrame:CGRectMake(_showImageView1.x+10, marginTop+height+lblMarginTop, width-10, lblHeight)];
        //_lblTitle.textColor=color;
        _lblTitle1.font=[UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_lblTitle1];
        
        _lblIntroduce1=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle1.x, _lblTitle1.y+_lblTitle1.height+lblMarginTop, _lblTitle1.width, lblHeight)];
        _lblIntroduce1.font=[UIFont systemFontOfSize:11.0];
        _lblIntroduce1.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblIntroduce1];
        
        
        
        _showImageView2=[[MyWebButton alloc] initWithFrame:CGRectMake(_showImageView1.x+width+marginLeft, marginTop, width, height)];
        _showImageView2.hidden=YES;
        _showImageView2.clipsToBounds=YES;
        _showImageView2.imageView.contentMode=UIViewContentModeScaleAspectFill;
        [_showImageView2 addTarget:self action:@selector(showImageTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_showImageView2];
        
        _lblTitle2=[[UILabel alloc] initWithFrame:CGRectMake(_showImageView2.x+10, marginTop+height+lblMarginTop, width-10, lblHeight)];
        _lblTitle2.font=[UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_lblTitle2];
        
        _lblIntroduce2=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle2.x, _lblTitle2.y+_lblTitle2.height+lblMarginTop, _lblTitle2.width, lblHeight)];
        _lblIntroduce2.font=[UIFont systemFontOfSize:11.0];
        _lblIntroduce2.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblIntroduce2];
    }
    return self;
}

-(void)showImageTouchUp:(MyWebButton *)button
{
    if([_delegate respondsToSelector:@selector(videoCell:didClickAtIndex:)])
        [_delegate videoCell:self didClickAtIndex:button.tag];
}

-(void)clean
{
    _showImageView1.hidden=YES;
    _showImageView2.hidden=YES;
    [_showImageView1 setImage:nil forState:UIControlStateNormal];
    [_showImageView2 setImage:nil forState:UIControlStateNormal];
    _lblTitle1.text=@"";
    _lblTitle2.text=@"";
    _lblIntroduce1.text=@"";
    _lblIntroduce2.text=@"";
}

/** 设置展示图 */
-(void)setShowImage1Url:(NSString *)urlString index:(NSInteger)index
{
    _showImageView1.hidden=NO;
    _showImageView1.tag=index;
    [_showImageView1 setImageWithUrl:urlString callback:nil];
}
/** 设置title颜色 */
-(void)setTitle1Color:(UIColor *)color
{
    _lblTitle1.textColor=color;
}
/** 设置title */
-(void)setTitle1:(NSString *)title
{
    _lblTitle1.text=title;
}
/** 设置副标题 */
-(void)setIntroduce1:(NSString *)introduce
{
    _lblIntroduce1.text=introduce;
}

/** 设置展示图 */
-(void)setShowImage2Url:(NSString *)urlString index:(NSInteger)index
{
    _showImageView2.hidden=NO;
    _showImageView2.tag=index;
    [_showImageView2 setImageWithUrl:urlString callback:nil];
}
/** 设置title颜色 */
-(void)setTitle2Color:(UIColor *)color
{
    _lblTitle2.textColor=color;
}
/** 设置title */
-(void)setTitle2:(NSString *)title
{
    _lblTitle2.text=title;
}
/** 设置副标题 */
-(void)setIntroduce2:(NSString *)introduce
{
    _lblIntroduce2.text=introduce;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
