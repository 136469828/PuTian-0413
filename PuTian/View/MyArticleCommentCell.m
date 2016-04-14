//
//  MyArticleCommentCell.m
//  PuTian
//
//  Created by guofeng on 15/10/14.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "MyArticleCommentCell.h"
#import "MyWebImage.h"

@interface MyArticleCommentCell()

@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@property (nonatomic,strong) MyWebImage *showImageView;
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UILabel *lblDate;
@property (nonatomic,strong) UILabel *lblComment;

@end

@implementation MyArticleCommentCell

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
        
        _lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(_showImageView.x+_showImageView.width+5, _showImageView.y, frame.size.width-_showImageView.x*2-_showImageView.width-5, 18)];
        _lblTitle.font=[UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:_lblTitle];
        
        _lblComment=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.x, _lblTitle.y+_lblTitle.height+10, _lblTitle.width, 15)];
        _lblComment.font=[UIFont systemFontOfSize:12.0];
        _lblComment.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblComment];
        
        UIFont *dateFont=[UIFont systemFontOfSize:11.0];
        NSString *tmpstr=@"2015-10-13 15:32";
        CGSize dateStringSize=[tmpstr sizeWithAttributes:@{NSFontAttributeName:dateFont}];
        _lblDate=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.x, _lblComment.y+_lblComment.height+10, dateStringSize.width+10, 18)];
        _lblDate.font=dateFont;
        _lblDate.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblDate];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.height-0.5, self.contentView.width, 0.5)];
        line.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:line];
    }
    return self;
}

-(void)setShowImageUrl:(NSString *)showImageUrl
{
    _showImageUrl=showImageUrl;
    
    [_showImageView setImageWithUrl:showImageUrl callback:nil];
}
-(void)setTitle:(NSString *)title
{
    _title=title;
    
    _lblTitle.text=title;
}
-(void)setDate:(NSDate *)date
{
    _date=date;
    
    if(date)
        _lblDate.text=[_dateFormatter stringFromDate:date];
    else
        _lblDate.text=@"";
}
-(void)setComment:(NSString *)comment
{
    _comment=comment;
    
    _lblComment.text=comment;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
