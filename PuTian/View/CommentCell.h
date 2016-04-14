//
//  CommentCell.h
//  PuTian
//
//  Created by guofeng on 15/10/13.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CommentCellHeight 60.0

@interface CommentCell : UITableViewCell

@property (nonatomic,strong) NSString *userNickName;
@property (nonatomic,assign) NSInteger grade;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *comment;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;



@end
