//
//  CommentCell.m
//  PuTian
//
//  Created by guofeng on 15/10/13.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell()

@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@property (nonatomic,strong) UILabel *lblUserNickName;
@property (nonatomic,strong) UIImageView *ivGrade;
@property (nonatomic,strong) UILabel *lblDate;
@property (nonatomic,strong) UILabel *lblComment;

@end

@implementation CommentCell

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
        _dateFormatter.dateFormat=@"yy-MM-dd HH:mm";
        
        _lblUserNickName=[[UILabel alloc] initWithFrame:CGRectMake(7, 12, 70, 18)];
        _lblUserNickName.font=[UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_lblUserNickName];
        
        _ivGrade=[[UIImageView alloc] initWithFrame:CGRectMake(_lblUserNickName.x+_lblUserNickName.width+10, _lblUserNickName.y+(_lblUserNickName.height-12)/2.0, 66, 12)];
        [self.contentView addSubview:_ivGrade];
        
        UIFont *dateFont=[UIFont systemFontOfSize:11.0];
        NSString *tmpstr=@"15-10-13 15:32";
        CGSize size=[tmpstr sizeWithAttributes:@{NSFontAttributeName:dateFont}];
        _lblDate=[[UILabel alloc] initWithFrame:CGRectMake(self.contentView.width-size.width-35, 12, size.width+10, 18)];
        _lblDate.font=dateFont;
        _lblDate.textColor=[UIColor colorWithWhite:0.7 alpha:1.0];
        [self.contentView addSubview:_lblDate];
        
        _lblComment=[[UILabel alloc] initWithFrame:CGRectMake(7, _lblUserNickName.y+_lblUserNickName.height+10, self.contentView.width-64, 15)];
        _lblComment.font=[UIFont systemFontOfSize:11.0];
        _lblComment.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblComment];
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.height-0.5, self.contentView.width, 0.5)];
        line.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:line];
    }
    return self;
}

-(void)setUserNickName:(NSString *)userNickName
{
    _lblUserNickName.text=userNickName;
    _userNickName=userNickName;
}
-(void)setGrade:(NSInteger)grade
{
    switch(grade)
    {
        case 1:
            _ivGrade.image=[UIImage imageNamed:@"youhui_star_2"];
            break;
        case 2:
            _ivGrade.image=[UIImage imageNamed:@"youhui_star_4"];
            break;
        case 3:
            _ivGrade.image=[UIImage imageNamed:@"youhui_star_6"];
            break;
        case 4:
            _ivGrade.image=[UIImage imageNamed:@"youhui_star_8"];
            break;
        case 5:
            _ivGrade.image=[UIImage imageNamed:@"youhui_star_10"];
            break;
    }
    _grade=grade;
}
-(void)setDate:(NSDate *)date
{
    if(date)
    {
        _lblDate.text=[_dateFormatter stringFromDate:date];
    }
    else
    {
        _lblDate.text=@"";
    }
    _date=date;
}
-(void)setComment:(NSString *)comment
{
    _lblComment.text=comment;
    _comment=comment;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
