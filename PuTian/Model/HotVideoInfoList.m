//
//  HotVideoInfo.m
//  PuTian
//
//  Created by guofeng on 15/9/16.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "HotVideoInfoList.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "PlatServiceDataParser.h"

@interface HotVideoInfoList()
{
    NSMutableArray *_arrList;
}

@property (nonatomic,strong) ASIHTTPRequest *request;
@property (atomic,assign) BOOL isLoading;

@end

@implementation HotVideoInfoList

-(NSArray *)list
{
    return _arrList;
}

-(void)disposeRequest
{
    if(_request)
    {
        [_request setDelegate:nil];
        self.request=nil;
    }
}

-(id)init
{
    if(self=[super init])
    {
        _arrList=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadData
{
    if(!self.isLoading)
    {
        self.isLoading=YES;
        
        [_arrList removeAllObjects];
        
        NSString *urlString=@"";
        if(self.type==0)
            urlString=[[NSString alloc] initWithFormat:@"%@?m=video&a=getlist&isHot=1&uid=%d",URL_Server,_uid];
        else
            urlString=[[NSString alloc] initWithFormat:@"%@?m=video&a=getlist&isRandom=1&uid=%d",URL_Server,_uid];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        if(_request)
        {
            [_request setDelegate:nil];
            self.request=nil;
        }
        _request=[[ASIHTTPRequest alloc] initWithURL:url];
        [_request setDownloadCache:[ASIDownloadCache sharedCache]];
        [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
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
                    NSString *tmpstr=nil;
                    VideoInfo *info=[[VideoInfo alloc] init];
                    tmpstr=[tmpdic objectForKey:@"videoid"];
                    if(![tmpstr isNull])
                        info.videoid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"videoname"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.videoName=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"introduce"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.title=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"userid"];
                    if(![tmpstr isNull])
                        info.userid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"ishot"];
                    if(![tmpstr isNull])
                        info.isHot=[tmpstr boolValue];
                    
                    tmpstr=[tmpdic objectForKey:@"thumbimg"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.thumbimg=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"linkurl"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.linkurl=tmpstr;
                    
                    if(![[tmpdic objectForKey:@"iscollect"] isNull])
                        info.isCollect=[[tmpdic objectForKey:@"iscollect"] boolValue];
                    
                    [_arrList addObject:info];
                }
            }
        }
    }
    
    self.isLoading=NO;
    
    NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] init];
    [userInfo setObject:@(hasNetworkFlags) forKey:kNotificationNetworkFlagsKey];
    [userInfo setObject:@(succeed) forKey:kNotificationSucceedKey];
    [userInfo setObject:@(requestCount) forKey:kNotificationContentKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:self userInfo:userInfo];
}

-(void)didFailedHttpRequest:(ASIHTTPRequest *)request
{
    self.isLoading=NO;
    if([_notificationName isNotNilOrEmptyString])
    {
        NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] init];
        if([Common hasNetworkFlags])
            [userInfo setObject:@"1" forKey:kNotificationNetworkFlagsKey];
        else
            [userInfo setObject:@"0" forKey:kNotificationNetworkFlagsKey];
        [userInfo setObject:@"0" forKey:kNotificationSucceedKey];
        [userInfo setObject:@"0" forKey:kNotificationContentKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:userInfo];
    }
}

@end
