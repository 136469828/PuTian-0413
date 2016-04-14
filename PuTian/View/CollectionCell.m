//
//  CollectionCell.m
//  PuTian
//
//  Created by guofeng on 15/10/14.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "CollectionCell.h"
#import "MyWebImage.h"

@interface CollectionCell()

@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@property (nonatomic,strong) MyWebImage *showImageView;

@property (nonatomic,strong) UILabel *lblTitle;

@property (nonatomic,strong) UILabel *lblIntroduce;

@property (nonatomic,strong) UILabel *lblDate;

@end

@implementation CollectionCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.frame=frame;
        self.contentView.frame=self.bounds;
        
        _dateFormatter=[[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm";
        
        _showImageView=[[MyWebImage alloc] initWithFrame:CGRectMake(10, 10, frame.size.height-20, frame.size.height-20)];
        _showImageView.clipsToBounds=YES;
        _showImageView.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_showImageView];
        
        _lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(_showImageView.x+_showImageView.width+5, _showImageView.y, frame.size.width-_showImageView.x*2-_showImageView.width-5, 20)];
        _lblTitle.font=[UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:_lblTitle];
        
        _lblIntroduce=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.x, _lblTitle.y+_lblTitle.height+5, _lblTitle.width, 40)];
        _lblIntroduce.numberOfLines=0;
        _lblIntroduce.font=[UIFont systemFontOfSize:12.0];
        _lblIntroduce.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblIntroduce];
        
        _lblDate=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.x, _showImageView.y+_showImageView.height-18, _lblTitle.width, 18)];
        _lblDate.font=[UIFont systemFontOfSize:11.0];
        _lblDate.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblDate];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.height-0.5, self.contentView.width, 0.5)];
        line.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:line];
    }
    return self;
}

/** 设置展示图 */
-(void)setShowImageUrl:(NSString *)showImageUrl
{
    _showImageUrl=showImageUrl;
    
    [_showImageView setImageWithUrl:showImageUrl callback:nil];
}
/** 设置title颜色 */
-(void)setTitleColor:(UIColor *)color
{
    _lblTitle.textColor=color;
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
-(void)setDate:(NSDate *)date
{
    _date=date;
    
    if(date)
        _lblDate.text=[_dateFormatter stringFromDate:date];
    else
        _lblDate.text=@"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
