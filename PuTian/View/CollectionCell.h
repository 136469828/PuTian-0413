//
//  CollectionCell.h
//  PuTian
//
//  Created by guofeng on 15/10/14.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CollectionCellHeight 108.0

@interface CollectionCell : UITableViewCell

@property (nonatomic,strong) NSString *showImageUrl;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *introduce;
@property (nonatomic,strong) NSDate *date;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end
