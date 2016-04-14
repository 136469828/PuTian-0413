//
//  SquareInfoList.m
//  PuTian
//
//  Created by guofeng on 15/9/16.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "SquareInfoList.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "PlatServiceDataParser.h"

@implementation Square

@end



@implementation SquareInfo

@end



@interface SquareInfoList()
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

@implementation SquareInfoList

-(NSMutableArray *)listDefault
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
        
        _cachePath=[[NSString alloc] initWithFormat:@"%@/squarelist.cache",[Common mCacheDirectory]];
        _deleteCachePath=[[NSString alloc] initWithFormat:@"%@/deletesquarelist.cache",[Common mCacheDirectory]];
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

/** 读取缓存默认列表 */
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
                    Square *s=[[Square alloc] init];
                    s.link_id=[[tmpdic objectForKey:@"link_id"] integerValue];
                    s.link_name=[tmpdic objectForKey:@"link_name"];
                    s.link_image=[tmpdic objectForKey:@"link_image"];
                    s.link_url=[tmpdic objectForKey:@"link_url"];
                    s.isDefault=[[tmpdic objectForKey:@"isDefault"] boolValue];
                    
                    [list addObject:s];
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
            Square *s=[list objectAtIndex:i];
            if([s isKindOfClass:[Square class]] && s.link_id>0)
            {
                NSMutableDictionary *tmpdic=[[NSMutableDictionary alloc] init];
                [tmpdic setObject:@(s.link_id) forKey:@"link_id"];
                if([s.link_name isNotNilOrEmptyString])
                    [tmpdic setObject:s.link_name forKey:@"link_name"];
                if([s.link_image isNotNilOrEmptyString])
                    [tmpdic setObject:s.link_image forKey:@"link_image"];
                if([s.link_url isNotNilOrEmptyString])
                    [tmpdic setObject:s.link_url forKey:@"link_url"];
                [tmpdic setObject:@(s.isDefault) forKey:@"isDefault"];
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
-(BOOL)defaultListContains:(Square *)model index:(int *)index
{
    BOOL isContains=NO;
    if(model==nil)return isContains;
    
    for(int i=0;i<_arrListDefault.count;i++)
    {
        Square *s=[_arrListDefault objectAtIndex:i];
        if(s.link_id==model.link_id)
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
-(BOOL)allListContains:(Square *)model index:(int *)index
{
    BOOL isContains=NO;
    if(model==nil)return isContains;
    
    for(int i=0;i<_arrListAll.count;i++)
    {
        Square *m=[_arrListAll objectAtIndex:i];
        if(m.link_id==model.link_id)
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
-(BOOL)allListForChechingContains:(Square *)model index:(int *)index
{
    BOOL isContains=NO;
    if(model==nil)return isContains;
    
    for(int i=0;i<_arrListAllForChecking.count;i++)
    {
        Square *m=[_arrListAllForChecking objectAtIndex:i];
        if(m.link_id==model.link_id)
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
-(BOOL)list:(NSArray *)list isContains:(Square *)model atIndex:(int *)index
{
    BOOL isContains=NO;
    if(list==nil || list.count==0 || model==nil)return isContains;
    
    for(int i=0;i<list.count;i++)
    {
        Square *m=[list objectAtIndex:i];
        if(m.link_id==model.link_id)
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
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=getappnav&uid=1&stype=2&parentid=0&isdefault=1",URL_Server];
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
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=getappnav&uid=1&stype=2&parentid=0&isdefault=0",URL_Server];
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

-(void)loadAllDataForChecking
{
    if(!self.isLoading3)
    {
        self.isLoading3=YES;
        
        [_arrListAllForChecking removeAllObjects];
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=getappnav&uid=1&stype=2&parentid=0&isdefault=0",URL_Server];
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
    BOOL hasData=NO;
    NSInteger nType=request.tag;
    NSString *jsonString=[request responseString];
    NSDictionary *dic=[PlatServiceDataParser parseToDictionaryWithJsonString:jsonString];
    if(dic && [[dic objectForKey:@"state"] integerValue]==0)
    {
        succeed=YES;
        
        NSArray *tmparr=[dic objectForKey:@"data"];
        if(tmparr && [tmparr isKindOfClass:[NSArray class]] && tmparr.count>0)
        {
            for(int i=0;i<tmparr.count;i++)
            {
                NSDictionary *tmpdic=[tmparr objectAtIndex:i];
                
                Square *s=[[Square alloc] init];
                
                if(![[tmpdic objectForKey:@"id"] isNull])
                    s.link_id=[[tmpdic objectForKey:@"id"] integerValue];
                if(![[tmpdic objectForKey:@"name"] isNull])
                    s.link_name=[tmpdic objectForKey:@"name"];
                if(![[tmpdic objectForKey:@"imageurl"] isNull])
                    s.link_image=[tmpdic objectForKey:@"imageurl"];
                if(![[tmpdic objectForKey:@"url"] isNull])
                    s.link_url=[tmpdic objectForKey:@"url"];
                if(![[tmpdic objectForKey:@"isdefault"] isNull])
                    s.isDefault=[[tmpdic objectForKey:@"isdefault"] boolValue];
                
                
                if(nType==1)
                    [_arrListDefault addObject:s];
                else if(nType==2)
                    [_arrListAll addObject:s];
                else if(nType==3)
                    [_arrListAllForChecking addObject:s];
            }
            
            if(nType==1)
            {
                if(_arrListDefault.count>0)hasData=YES;
            }
            else if(nType==2)
            {
                if(_arrListAll.count>0)hasData=YES;
            }
            else if(nType==3)
            {
                if(_arrListAllForChecking.count>0)hasData=YES;
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
    [userInfo setObject:@(hasData) forKey:kNotificationContentKey];
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
