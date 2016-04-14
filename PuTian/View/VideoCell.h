//
//  VideoCell.h
//  PuTian
//
//  Created by guofeng on 15/9/18.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoCell;

@protocol VideoCellDelegate <NSObject>

-(void)videoCell:(VideoCell *)cell didClickAtIndex:(NSInteger)index;

@end

@interface VideoCell : UITableViewCell

@property (nonatomic,assign) id<VideoCellDelegate> delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

-(void)clean;

/** 设置展示图 */
-(void)setShowImage1Url:(NSString *)urlString index:(NSInteger)index;
/** 设置title颜色 */
-(void)setTitle1Color:(UIColor *)color;
/** 设置title */
-(void)setTitle1:(NSString *)title;
/** 设置副标题 */
-(void)setIntroduce1:(NSString *)introduce;

/** 设置展示图 */
-(void)setShowImage2Url:(NSString *)urlString index:(NSInteger)index;
/** 设置title颜色 */
-(void)setTitle2Color:(UIColor *)color;
/** 设置title */
-(void)setTitle2:(NSString *)title;
/** 设置副标题 */
-(void)setIntroduce2:(NSString *)introduce;

@end
