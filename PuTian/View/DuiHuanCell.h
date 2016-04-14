//
//  OffPriceCell.h
//  PuTian
//
//  Created by guofeng on 15/9/8.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DuiHuanCellHeight 108.0

@interface DuiHuanCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

/** 设置展示图 */
-(void)setShowImageUrl:(NSString *)urlString;
-(void)setShowImage:(UIImage *)image;
/** 设置title */
-(void)setTitle:(NSString *)title;
/** 设置简介 */
-(void)setIntroduce:(NSString *)introduce;
/** 设置原价、现价 */
-(void)setPrice1:(float)price1 andPrice2:(float)price2;
/** 设置购买人数 */
-(void)setBuyerCount:(NSUInteger)count;
/** 设置使用沃币数 */
-(void)setUsedCount:(NSUInteger)count UsedStatus:(NSString*)status;
/** 设置下载数量 */
-(void)setDownloadCount:(NSUInteger)count;
/** 设置星级的显示与隐藏 */
-(void)setGradeVisible:(BOOL)visible;

@end
