//
//  MazuCell.m
//  PuTian
//
//  Created by guofeng on 15/9/9.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "MazuCell.h"
#import "MyWebImage.h"

@interface MazuCell()

@property (nonatomic,strong) MyWebImage *showImageView;
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UILabel *lblIntroduce;
@property (nonatomic,strong) UILabel *lblDate;
@property (nonatomic,strong) UILabel *lblOther;

@end

@implementation MazuCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.frame=frame;
        self.contentView.frame=self.bounds;
        
        _showImageView=[[MyWebImage alloc] initWithFrame:CGRectMake(5, 10, (frame.size.height-20)*4/3.0, frame.size.height-20)];
        _showImageView.clipsToBounds=YES;
        _showImageView.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_showImageView];
        
        _lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(_showImageView.x+_showImageView.width+5, _showImageView.y+5, frame.size.width-_showImageView.x*2-_showImageView.width-5, 20)];
        _lblTitle.font=[UIFont boldSystemFontOfSize:15.0];
        [self.contentView addSubview:_lblTitle];
        
        _lblIntroduce=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.x, _showImageView.y+_showImageView.height-45, _lblTitle.width, 40)];
        _lblIntroduce.numberOfLines=2;
        _lblIntroduce.font=[UIFont systemFontOfSize:13.0];
        _lblIntroduce.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblIntroduce];
        
        _lblDate=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.x, _lblIntroduce.height+18, _lblTitle.width, 40)];
        _lblDate.numberOfLines=2;        
        _lblDate.font=[UIFont systemFontOfSize:10.0];
        _lblDate.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblDate];
        
        _lblOther=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-80, _lblIntroduce.height+18, _lblTitle.width, 40)];
        _lblOther.numberOfLines=2;
        _lblOther.font=[UIFont systemFontOfSize:10.0];
        _lblOther.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblOther];

        
    }
    return self;
}

/** 设置展示图 */
-(void)setShowImageUrl:(NSString *)urlString
{
    [_showImageView setImageWithUrl:urlString callback:nil];
}
-(void)setShowImage:(UIImage *)image
{
    _showImageView.image=image;
}
/** 设置title颜色 */
-(void)setTitleColor:(UIColor *)color
{
    _lblTitle.textColor=color;
}
/** 设置title */
-(void)setTitle:(NSString *)title
{
    _lblTitle.text=title;
}
-(void)setIntroduce:(NSString *)introduce
{
    _lblIntroduce.attributedText=nil;
    if([introduce isNotNilOrEmptyString])
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:introduce];;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:3];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, introduce.length)];
        _lblIntroduce.attributedText = attributedString;
    }
}
-(void)setDate:(NSString *)date
{
    _lblDate.attributedText=nil;
    if([date isNotNilOrEmptyString])
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:date];;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:3];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, date.length)];
        _lblDate.attributedText = attributedString;
    }
}
-(void)setOther:(NSString *)other
{
    _lblOther.attributedText=nil;
    if([other isNotNilOrEmptyString])
    {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:other];;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:3];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, other.length)];
        _lblOther.attributedText = attributedString;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
