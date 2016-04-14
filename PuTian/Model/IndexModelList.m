//
//  IndexModelList.m
//  PuTian
//
//  Created by guofeng on 15/10/9.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "IndexModelList.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "PlatServiceDataParser.h"

@implementation IndexModel

@end

@interface IndexModelList()
{
    NSMutableArray *_arrListDefault;
    NSMutableArray *_arrListAll;
    NSMutableArray *_arrListAllForChecking;
}

@property (nonatomic,strong) NSString *cachePath;
@property (nonatomic,strong) NSString *deleteCachePath;

@property (nonatomic,strong) ASIHTTPRequest *request1;
@property (nonatomic,strong) ASIHTTPRequest *request2;
@property (nonatomic,strong) ASIHTTPRequest *request3;

@property (atomic,assign) BOOL isLoading1;
@property (atomic,assign) BOOL isLoading2;
@property (atomic,assign) BOOL isLoading3;

@end

@implementation IndexModelList

-(NSArray *)listDefault
{
    return _arrListDefault;
}
-(NSArray *)listAll
{
    return _arrListAll;
}
-(NSArray *)listAllForChecking
{
    return _arrListAllForChecking;
}

-(void)clearDefaultList
{
    [_arrListDefault removeAllObjects];
}
-(void)clearAllList
{
    [_arrListAll removeAllObjects];
}
-(void)clearAllListForChecking
{
    [_arrListAllForChecking removeAllObjects];
}

-(void)disposeRequestDefault
{
    if(_request1)
    {
        [_request1 setDelegate:nil];
        self.request1=nil;
    }
}
-(void)disposeRequestAll
{
    if(_request2)
    {
        [_request2 setDelegate:nil];
        self.request2=nil;
    }
}

-(id)init
{
    if(self=[super init])
    {
        _arrListDefault=[[NSMutableArray alloc] init];
        _arrListAll=[[NSMutableArray alloc] init];
        _arrListAllForChecking=[[NSMutableArray alloc] init];
        
        _cachePath=[[NSString alloc] initWithFormat:@"%@/indexmodellist.cache",[Common mCacheDirectory]];
        _deleteCachePath=[[NSString alloc] initWithFormat:@"%@/deleteindexmodellist.cache",[Common mCacheDirectory]];
    }
    return self;
}

/** 读取客户端已移除模块id列表 */
-(NSMutableArray *)readDeleteCacheList
{
    NSMutableArray *list=[NSMutableArray array];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:_deleteCachePath])
    {
        NSArray *tmparr=[[NSArray alloc] initWithContentsOfFile:_deleteCachePath];
        if(tmparr && tmparr.count>0)
        {
            [list addObjectsFromArray:tmparr];
        }
    }
    
    return list;
}
/** 保存客户端已移除模块id列表 */
-(void)saveDeleteList:(NSArray *)list
{
    if(list && list.count>0)
    {
        [list writeToFile:_deleteCachePath atomically:YES];
    }
}

/** 读取缓存列表 */
-(void)readCacheList:(NSMutableArray *)list
{
    if(list==nil)return;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:_cachePath])
    {
        if(list.count>0)[list removeAllObjects];
        
        NSArray *tmparr=[[NSArray alloc] initWithContentsOfFile:_cachePath];
        if(tmparr && tmparr.count>0)
        {
            for(int i=0;i<tmparr.count;i++)
            {
                NSDictionary *tmpdic=[tmparr objectAtIndex:i];
                if([tmpdic isKindOfClass:[NSDictionary class]])
                {
                    //1.
                    IndexModel *model=[[IndexModel alloc] init];
                    model.modelid=[[tmpdic objectForKey:@"modelid"] integerValue];
                    model.modelName=[tmpdic objectForKey:@"modelName"];
                    model.iconUrl=[tmpdic objectForKey:@"iconUrl"];
                    model.url=[tmpdic objectForKey:@"url"];
                    model.isDefault=[[tmpdic objectForKey:@"isDefault"] boolValue];
//                  NSLog(@"%d",model.nav_style);
                    model.sign=[[tmpdic objectForKey:@"sign"] integerValue];
                    model.nav_style = [[tmpdic objectForKey:@"nav_style"] intValue];
                    model.term_id = [[tmpdic objectForKey:@"termid"] intValue];
                    [list addObject:model];
                }
            }
        }
    }
}
/** 保存默认列表 */
-(void)saveDefaultList:(NSArray *)list
{
    if(list && list.count>0)
    {
        NSMutableArray *saveList=[[NSMutableArray alloc] init];
        for(int i=0;i<list.count;i++)
        {
            IndexModel *model=[list objectAtIndex:i];
            if([model isKindOfClass:[IndexModel class]] && model.modelid>0)
            {
                NSMutableDictionary *tmpdic=[[NSMutableDictionary alloc] init];
                [tmpdic setObject:@(model.modelid) forKey:@"modelid"];
                
                if([model.modelName isNotNilOrEmptyString])
                    [tmpdic setObject:model.modelName forKey:@"modelName"];
                if([model.iconUrl isNotNilOrEmptyString])
                    [tmpdic setObject:model.iconUrl forKey:@"iconUrl"];
                if([model.url isNotNilOrEmptyString])
                    [tmpdic setObject:model.url forKey:@"url"];
                
                [tmpdic setObject:@(model.sign) forKey:@"sign"];
                [tmpdic setObject:@(model.isDefault) forKey:@"isDefault"];
                [tmpdic setObject:@(model.nav_style) forKey:@"nav_style"];
                [tmpdic setObject:@(model.term_id) forKey:@"termid"];
                
                [saveList addObject:tmpdic];
            }
        }
        [saveList writeToFile:_cachePath atomically:YES];
    }
    else
    {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:_cachePath])
            [fileManager removeItemAtPath:_cachePath error:nil];
    }
}

/** 默认列表中是否包含model */
-(BOOL)defaultListContains:(IndexModel *)model index:(int *)index
{
    BOOL isContains=NO;
    if(model==nil)return isContains;
    
    for(int i=0;i<_arrListDefault.count;i++)
    {
        IndexModel *m=[_arrListDefault objectAtIndex:i];
        if(m.modelid==model.modelid)
        {
            isContains=YES;
            if(index)
            {
                *index=i;
            }
            break;
        }
    }
    
    return isContains;
}
/** 全部列表中是否包含model */
-(BOOL)allListContains:(IndexModel *)model index:(int *)index
{
    BOOL isContains=NO;
    if(model==nil)return isContains;
    
    for(int i=0;i<_arrListAll.count;i++)
    {
        IndexModel *m=[_arrListAll objectAtIndex:i];
        if(m.modelid==model.modelid)
        {
            isContains=YES;
            if(index)
            {
                *index=i;
            }
            break;
        }
    }
    
    return isContains;
}
/** 全部列表中是否包含model--检查数据 */
-(BOOL)allListForChechingContains:(IndexModel *)model index:(int *)index
{
    BOOL isContains=NO;
    if(model==nil)return isContains;
    
    for(int i=0;i<_arrListAllForChecking.count;i++)
    {
        IndexModel *m=[_arrListAllForChecking objectAtIndex:i];
        if(m.modelid==model.modelid)
        {
            isContains=YES;
            if(index)
            {
                *index=i;
            }
            break;
        }
    }
    
    return isContains;
}
/** 列表中是否包含model */
-(BOOL)list:(NSArray *)list isContains:(IndexModel *)model atIndex:(int *)index
{
    BOOL isContains=NO;
    if(list==nil || list.count==0 || model==nil)return isContains;
    
    for(int i=0;i<list.count;i++)
    {
        IndexModel *m=[list objectAtIndex:i];
        if(m.modelid==model.modelid)
        {
            isContains=YES;
            if(index)
            {
                *index=i;
            }
            break;
        }
    }
    
    return isContains;
}

-(void)loadDefaultData
{
    if(!self.isLoading1)
    {
        self.isLoading1=YES;
        
        [_arrListDefault removeAllObjects];
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=getappnav&uid=&stype=1&parentid=0&isdefault=1",URL_Server];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        if(_request1)
        {
            [_request1 setDelegate:nil];
            self.request1=nil;
        }
        _request1=[[ASIHTTPRequest alloc] initWithURL:url];
        _request1.tag=1;
        [_request1 setDownloadCache:[ASIDownloadCache sharedCache]];
        [_request1 setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [_request1 setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request1 setDelegate:self];
        [_request1 setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request1 setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request1 startAsynchronous];
    }
}

-(void)loadAllData
{
    if(!self.isLoading2)
    {
        self.isLoading2=YES;
        
        [_arrListAll removeAllObjects];
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=getappnav&uid=&stype=1&parentid=0&isdefault=0",URL_Server];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        if(_request2)
        {
            [_request2 setDelegate:nil];
            self.request2=nil;
        }
        _request2=[[ASIHTTPRequest alloc] initWithURL:url];
        _request2.tag=2;
        [_request2 setDownloadCache:[ASIDownloadCache sharedCache]];
        [_request2 setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [_request2 setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request2 setDelegate:self];
        [_request2 setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request2 setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request2 startAsynchronous];
    }
}

/** 加载全部列表,用于检查数据(type:3) */
-(void)loadAllDataForChecking
{
    if(!self.isLoading3)
    {
        self.isLoading3=YES;
        
        [_arrListAllForChecking removeAllObjects];
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=getappnav&uid=&stype=1&parentid=0&isdefault=0",URL_Server];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        if(_request3)
        {
            [_request3 setDelegate:nil];
            self.request3=nil;
        }
        _request3=[[ASIHTTPRequest alloc] initWithURL:url];
        _request3.tag=3;
        [_request3 setDownloadCache:[ASIDownloadCache sharedCache]];
        [_request3 setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [_request3 setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request3 setDelegate:self];
        [_request3 setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request3 setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request3 startAsynchronous];
    }
}

-(void)didStartHttpRequest:(ASIHTTPRequest *)request
{
    
}

-(void)didFinishHttpRequest:(ASIHTTPRequest *)request
{
    BOOL hasNetworkFlags=[Common hasNetworkFlags];
    BOOL succeed=NO;
    int requestCount=0;
    NSInteger nType=request.tag;
    NSString *jsonString=[request responseString];
    NSDictionary *dic=[PlatServiceDataParser parseToDictionaryWithJsonString:jsonString];
    if(dic && [[dic objectForKey:@"state"] integerValue]==0)
    {
        succeed=YES;
        
        NSArray *tmparr=[dic objectForKey:@"data"];
        if(tmparr && [tmparr isKindOfClass:[NSArray class]])
        {
            if(tmparr.count>0)
            {
                requestCount=tmparr.count;
                
                for(NSDictionary *tmpdic in tmparr)
                {
                    //2.
                    NSString *tmpstr=nil;
                    IndexModel *info=[[IndexModel alloc] init];
                    tmpstr=[tmpdic objectForKey:@"id"];
                    if(![tmpstr isNull])
                        info.modelid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"name"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.modelName=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"imageurl"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.iconUrl=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"id"];
                    if(![tmpstr isNull])
                        info.sign=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"url"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.url=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"isdefault"];
                    if(![tmpstr isNull])
                        info.isDefault=[tmpstr boolValue];
//                    NSLog(@"%@",[tmpdic objectForKey:@"nav_style"]);// 判断用什么通用界面
                    tmpstr=[tmpdic objectForKey:@"nav_style"];
//                    if([tmpstr isNull])
                    info.nav_style=[tmpstr intValue];
                    tmpstr=[tmpdic objectForKey:@"termid"];
//                    if([tmpstr isNull])
                    info.term_id=[tmpstr intValue];
                    if (self.dataArr.count == 0) {
                        self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
                    }
                    else
                    {
                        [self.dataArr addObject:info];
                    }
                    
                    switch(nType)
                    {
                        case 1:
                            [_arrListDefault addObject:info];
                            break;
                        case 2:
                            [_arrListAll addObject:info];
                            break;
                        case 3:
                            [_arrListAllForChecking addObject:info];
                            break;
                    }
                }
            }
        }
    }
    
    switch(nType)
    {
        case 1:self.isLoading1=NO;break;
        case 2:self.isLoading2=NO;break;
        case 3:self.isLoading3=NO;break;
    }
    
    NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] init];
    [userInfo setObject:@(hasNetworkFlags) forKey:kNotificationNetworkFlagsKey];
    [userInfo setObject:@(succeed) forKey:kNotificationSucceedKey];
    [userInfo setObject:@(requestCount) forKey:kNotificationContentKey];
    [userInfo setObject:@(nType) forKey:kNotificationTypeKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:self userInfo:userInfo];
}

-(void)didFailedHttpRequest:(ASIHTTPRequest *)request
{
    switch(request.tag)
    {
        case 1:self.isLoading1=NO;break;
        case 2:self.isLoading2=NO;break;
        case 3:self.isLoading3=NO;break;
    }
    
    if([_notificationName isNotNilOrEmptyString])
    {
        NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] init];
        if([Common hasNetworkFlags])
            [userInfo setObject:@"1" forKey:kNotificationNetworkFlagsKey];
        else
            [userInfo setObject:@"0" forKey:kNotificationNetworkFlagsKey];
        [userInfo setObject:@"0" forKey:kNotificationSucceedKey];
        [userInfo setObject:@"0" forKey:kNotificationContentKey];
        [userInfo setObject:@(request.tag) forKey:kNotificationTypeKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:userInfo];
    }
}

@end
