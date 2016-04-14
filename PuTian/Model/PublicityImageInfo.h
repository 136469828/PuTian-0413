//
//  PublicityImageInfo.h
//  PuTian
//
//  Created by guofeng on 15/10/21.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicityImageInfo : NSObject

@property (nonatomic,assign) NSInteger ad_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *picurl;
@property (nonatomic,readonly) NSData *imageData;

-(void)loadData;

@end
