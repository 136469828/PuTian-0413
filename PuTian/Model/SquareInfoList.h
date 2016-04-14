//
//  SquareInfoList.h
//  PuTian
//
//  Created by guofeng on 15/9/16.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Square : NSObject

@property (nonatomic,assign) NSInteger link_id;
@property (nonatomic,strong) NSString *link_name;
@property (nonatomic,strong) NSString *link_image;
@property (nonatomic,strong) NSString *link_url;
@property (nonatomic,assign) BOOL isDefault;
@property (nonatomic,assign) BOOL isEditting;

@end

/** 广场信息 */
@interface SquareInfo : NSObject

@property (nonatomic,strong) NSString *attrName;
@property (nonatomic,strong) NSString *dictName;
/** Square列表 */
@property (nonatomic,strong) NSArray *list;

@end

/** 广场信息列表 */
@interface SquareInfoList : NSObject

@property (nonatomic,strong) NSString *notificationName;

/** 默认广场列表(Square) */
@property (nonatomic,strong) NSArray *listDefault;
/** 所有广场列表(Square) */
@property (nonatomic,readonly) NSArray *listAll;
/** 所有模块列表(IndexModel),用于检查数据 */
@property (nonatomic,readonly) NSArray *listAllForChecking;

/** 读取缓存列表 */
-(void)readCacheList:(NSMutableArray *)list;
/** 保存默认列表 */
-(void)saveDefaultList:(NSArray *)list;

/** 读取客户端已移除模块id列表 */
-(NSMutableArray *)readDeleteCacheList;
/** 保存客户端已移除模块id列表 */
-(void)saveDeleteList:(NSArray *)list;

/** 默认列表中是否包含model */
-(BOOL)defaultListContains:(Square *)model index:(int *)index;
/** 全部列表中是否包含model */
-(BOOL)allListContains:(Square *)model index:(int *)index;
/** 全部列表中是否包含model--检查数据 */
-(BOOL)allListForChechingContains:(Square *)model index:(int *)index;
/** 列表中是否包含model */
-(BOOL)list:(NSArray *)list isContains:(Square *)model atIndex:(int *)index;

/** 加载默认列表(type:1) */
-(void)loadDefaultData;
/** 加载全部列表(type:2) */
-(void)loadAllData;
/** 加载全部列表,用于检查数据(type:3) */
-(void)loadAllDataForChecking;

-(void)disposeRequestDefault;
-(void)disposeRequestAll;

@end
