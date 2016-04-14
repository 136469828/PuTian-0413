//
//  MazuCell.h
//  PuTian
//
//  Created by guofeng on 15/9/9.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MazuCellHeight 90.0

@interface MazuCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

/** 设置展示图 */
-(void)setShowImageUrl:(NSString *)urlString;
-(void)setShowImage:(UIImage *)image;
/** 设置title颜色 */
-(void)setTitleColor:(UIColor *)color;
/** 设置title */
-(void)setTitle:(NSString *)title;
-(void)setIntroduce:(NSString *)introduce;
-(void)setDate:(NSString *)date;
-(void)setOther:(NSString *)other;
@end
