//
//  RecreationChannelCell.h
//  PuTian
//
//  Created by guofeng on 15/10/21.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RecreationChannelCellHeight 65.0

@interface RecreationChannelCell : UITableViewCell

@property (nonatomic,assign) NSInteger channelid;
@property (nonatomic,strong) NSString *showImageUrl;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *introduce;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end
