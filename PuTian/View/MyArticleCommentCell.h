//
//  MyArticleCommentCell.h
//  PuTian
//
//  Created by guofeng on 15/10/14.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MyArticleCommentCellHeight 90.0

@interface MyArticleCommentCell : UITableViewCell

@property (nonatomic,strong) NSString *showImageUrl;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *comment;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end
