//
//  MyYouhuiCommentCell.h
//  PuTian
//
//  Created by guofeng on 15/10/14.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MyYouhuiCommentCellHeight 102.0

@interface MyYouhuiCommentCell : UITableViewCell

@property (nonatomic,strong) NSString *showImageUrl;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,assign) CommentButtonType gradeType;
@property (nonatomic,assign) NSInteger grade;
@property (nonatomic,strong) NSString *comment;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end
