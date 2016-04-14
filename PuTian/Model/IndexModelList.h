//
//  IndexModelList.h
//  PuTian
//
//  Created by guofeng on 15/10/9.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexModel : NSObject

@property (nonatomic,assign) NSInteger modelid;

@property (nonatomic,strong) NSString *modelName;

@property (nonatomic,strong) NSString *iconUrl;

@property (nonatomic,assign) NSInteger sign;

@property (nonatomic,strong) NSString *url;

@property (nonatomic,assign) BOOL isDefault;

@property (nonatomic, assign) int nav_style;

@property (nonatomic, assign) int term_id;
@property (nonatomic,assign) BOOL isEditting;

@end

@interface IndexModelList : NSObject
@property (nonatomic, assign) int nav_style;

@property (nonatomic, assign) int term_id;

@property (nonatomic,strong) NSString *notificationName;

/** 默认模块列表(IndexModel) */
@property (nonatomic,readonly) NSArray *listDefault;
/** 所有模块列表(IndexModel) */
@property (nonatomic,readonly) NSArray *listAll;
/** 所有模块列表(IndexModel),用于检查数据 */
@property (nonatomic,readonly) NSArray *listAllForChecking;
@property (nonatomic, strong) NSMutableArray *dataArr;
/** 读取缓存列表 */
-(void)readCacheList:(NSMutableArray *)list;
/** 保存默认列表 */
-(void)saveDefaultList:(NSArray *)list;

/** 读取客户端已移除模块id列表 */
-(NSMutableArray *)readDeleteCacheList;
/** 保存客户端已移除模块id列表 */
-(void)saveDeleteList:(NSArray *)list;

/** 默认列表中是否包含model */
-(BOOL)defaultListContains:(IndexModel *)model index:(int *)index;
/** 全部列表中是否包含model */
-(BOOL)allListContains:(IndexModel *)model index:(int *)index;
/** 全部列表中是否包含model--检查数据 */
-(BOOL)allListForChechingContains:(IndexModel *)model index:(int *)index;
/** 列表中是否包含model */
-(BOOL)list:(NSArray *)list isContains:(IndexModel *)model atIndex:(int *)index;

/** 加载默认列表(type:1) */
-(void)loadDefaultData;
/** 加载全部列表(type:2) */
-(void)loadAllData;
/** 加载全部列表,用于检查数据(type:3) */
-(void)loadAllDataForChecking;

-(void)clearDefaultList;
-(void)clearAllList;
-(void)clearAllListForChecking;

-(void)disposeRequestDefault;
-(void)disposeRequestAll;

@end
