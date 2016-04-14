//
//  OffPriceCell.m
//  PuTian
//
//  Created by guofeng on 15/9/8.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "DuiHuanCell.h"
#import "MyWebImage.h"
#import "LinyLabel.h"

#import "UserInfo.h"

@interface DuiHuanCell()

@property (nonatomic,strong) MyWebImage *showImageView;
@property (nonatomic,strong) UILabel *lblTitle;
@property (nonatomic,strong) UILabel *lblIntroduce;
@property (nonatomic,strong) UILabel *lblPrice1Title;
@property (nonatomic,strong) UILabel *lblPrice1;
@property (nonatomic,strong) UILabel *lblPrice2Title;
@property (nonatomic,strong) UILabel *lblPrice2;
@property (nonatomic,strong) UILabel *lblBuyerCount;
@property (nonatomic,strong) UILabel *lblGrade;

@property (nonatomic,strong) UserInfo *userInfo;
@end

@implementation DuiHuanCell

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
//{
//    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
//    {
//        self.frame=frame;
//        self.contentView.frame=self.bounds;
//        
//        _showImageView=[[MyWebImage alloc] initWithFrame:CGRectMake(5, 4, (frame.size.height-8)*4/3.0, frame.size.height-8)];
//        _showImageView.clipsToBounds=YES;
//        _showImageView.contentMode=UIViewContentModeScaleAspectFill;
//        [self.contentView addSubview:_showImageView];
//        
//        _lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(_showImageView.x+_showImageView.width+5, _showImageView.y, frame.size.width-_showImageView.x*2-_showImageView.width-5, (frame.size.height-8)/2.0-7)];
//        _lblTitle.numberOfLines=0;
//        _lblTitle.font=[UIFont systemFontOfSize:12.0];
//        [self.contentView addSubview:_lblTitle];
//        
//        _lblPrice1Title=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.x, _lblTitle.y+_lblTitle.height+3, 25, 18)];
//        _lblPrice1Title.font=[UIFont systemFontOfSize:12.0];
//        _lblPrice1Title.text=@"原价";
//        [self.contentView addSubview:_lblPrice1Title];
//        
//        UIColor *color=[[UIColor alloc] initWithRed:253.0/255 green:104.0/255 blue:154.0/255 alpha:1.0];
//        _lblPrice1=[[UILabel alloc] initWithFrame:CGRectMake(_lblPrice1Title.x+_lblPrice1Title.width, _lblPrice1Title.y, frame.size.width-_lblPrice1Title.x-_lblPrice1Title.width, 18)];
//        _lblPrice1.font=[UIFont systemFontOfSize:15.0];
//        _lblPrice1.textColor=color;
//        _lblPrice1.text=@"";
//        [self.contentView addSubview:_lblPrice1];
//        
//        _lblPrice2Title=[[UILabel alloc] initWithFrame:CGRectMake(_lblPrice1Title.x, _lblPrice1Title.y+_lblPrice1Title.height, 25, 18)];
//        _lblPrice2Title.font=[UIFont systemFontOfSize:12.0];
//        _lblPrice2Title.text=@"现价";
//        [self.contentView addSubview:_lblPrice2Title];
//        
//        _lblPrice2=[[UILabel alloc] initWithFrame:CGRectMake(_lblPrice2Title.x+_lblPrice2Title.width, _lblPrice2Title.y, frame.size.width-_lblPrice2Title.x-_lblPrice2Title.width, 18)];
//        _lblPrice2.font=[UIFont systemFontOfSize:15.0];
//        _lblPrice2.textColor=color;
//        _lblPrice2.text=@"";
//        [self.contentView addSubview:_lblPrice2];
//        
//        _lblBuyerCount=[[UILabel alloc] initWithFrame:CGRectMake(_lblPrice2Title.x, _lblPrice2Title.y+_lblPrice1Title.height, _lblTitle.width, 18)];
//        _lblBuyerCount.font=[UIFont systemFontOfSize:13.0];
//        _lblBuyerCount.text=@"";
//        _lblBuyerCount.textColor=[UIColor colorWithWhite:0.7 alpha:1.0];
//        [self.contentView addSubview:_lblBuyerCount];
//    }
//    return self;
//}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.frame=frame;
        self.contentView.frame=self.bounds;
        
        //_showImageView=[[MyWebImage alloc] initWithFrame:CGRectMake(10, 10, (frame.size.height-20)*4/3.0, frame.size.height-20)];
        _showImageView=[[MyWebImage alloc] initWithFrame:CGRectMake(10, 10, frame.size.height-20, frame.size.height-20)];
        _showImageView.clipsToBounds=YES;
        _showImageView.contentMode=UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_showImageView];
        
        _lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(_showImageView.x+_showImageView.width+5, _showImageView.y, frame.size.width-_showImageView.x*2-_showImageView.width-5, 20)];
        _lblTitle.font=[UIFont boldSystemFontOfSize:15.0];
        [self.contentView addSubview:_lblTitle];
        
        _lblIntroduce=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.x, _lblTitle.y+_lblTitle.height+5, _lblTitle.width, 40)];
        _lblIntroduce.numberOfLines=0;
        _lblIntroduce.font=[UIFont systemFontOfSize:13.0];
        _lblIntroduce.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        [self.contentView addSubview:_lblIntroduce];
        
        _lblBuyerCount=[[UILabel alloc] initWithFrame:CGRectMake(_lblTitle.x, _showImageView.y+_showImageView.height-18, _lblTitle.width, 18)];
        _lblBuyerCount.font=[UIFont systemFontOfSize:13.0];
        _lblBuyerCount.text=@"";
        _lblBuyerCount.textColor=[UIColor colorWithWhite:0.7 alpha:1.0];
        [self.contentView addSubview:_lblBuyerCount];
        
        _lblGrade=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-75, _lblBuyerCount.y, 65, 18)];
        _lblGrade.font=[UIFont systemFontOfSize:13.0];
        _lblGrade.text=@"";
        _lblGrade.textColor=kNavigationBarBackgroundColor;
        [self.contentView addSubview:_lblGrade];
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
/** 设置title */
-(void)setTitle:(NSString *)title
{
    _lblTitle.text=title;
}
/** 设置简介 */
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
/** 设置原价、现价 */
-(void)setPrice1:(float)price1 andPrice2:(float)price2
{
    NSString *tmpstr=nil;
    NSInteger price=(NSInteger)price1;
    if(price==price1)
        tmpstr=[[NSString alloc] initWithFormat:@"￥%d",price];
    else
        tmpstr=[[NSString alloc] initWithFormat:@"￥%.2f",price1];
    _lblPrice1.text=tmpstr;
    [_lblPrice1 sizeToFit];
    
    price=(NSInteger)price2;
    if(price==price2)
        tmpstr=[[NSString alloc] initWithFormat:@"￥%d",price];
    else
        tmpstr=[[NSString alloc] initWithFormat:@"￥%.2f",price1];
    _lblPrice2.text=tmpstr;
}
/** 设置购买人数 */
-(void)setBuyerCount:(NSUInteger)count
{
//    count = 10;
    
    NSString *tmpstr=[[NSString alloc] initWithFormat:@"所需沃币:%d",count];
//    _lblBuyerCount.backgroundColor = [UIColor redColor];
    _lblBuyerCount.text=tmpstr;
}
/** 设置使用沃币数 */
-(void)setUsedCount:(NSUInteger)count UsedStatus:(NSString*)status
{
    NSString *tmpstr=[[NSString alloc] initWithFormat:@"使用沃币:%d (%@)",count,status];

    _lblBuyerCount.text=tmpstr;
}
/** 设置下载数量 */
-(void)setDownloadCount:(NSUInteger)count
{
    
    NSString *tmpstr=[[NSString alloc] initWithFormat:@"下载%d张优惠券",count];
    _lblBuyerCount.text=tmpstr;
}
/** 设置星级的显示与隐藏 */
-(void)setGradeVisible:(BOOL)visible
{
    _lblGrade.hidden=!visible;
}

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
