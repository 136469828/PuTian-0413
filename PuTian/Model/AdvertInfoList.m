//
//  AdvertInfoList.m
//  PuTian
//
//  Created by guofeng on 15/9/15.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "AdvertInfoList.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "PlatServiceDataParser.h"

@implementation AdvertInfo

-(id)init
{
    if(self=[super init])
    {
        self.ad_name=@"";
        self.ad_content=@"";
        self.ad_picurl=@"";
        self.ad_clickurl=@"";
    }
    return self;
}

@end



@interface AdvertInfoList()
{
    NSMutableArray *_arrList;
}

@property (nonatomic,strong) ASIHTTPRequest *request;
@property (nonatomic,assign) BOOL isLoading;

@end

@implementation AdvertInfoList

-(NSArray *)list
{
    return _arrList;
}

-(id)init
{
    if(self=[super init])
    {
        _arrList=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)disposeRequest
{
    if(_request)
    {
        [_request setDelegate:nil];
        self.request=nil;
    }
}

-(void)loadData
{
    if(!self.isLoading)
    {
        self.isLoading=YES;
        
        [_arrList removeAllObjects];
        
        [self disposeRequest];
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=getadvert&stype=%d",URL_Server,_type];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        _request=[[ASIHTTPRequest alloc] initWithURL:url];
        [_request setDownloadCache:[ASIDownloadCache sharedCache]];
        [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [_request setDelegate:self];
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
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
                    AdvertInfo *info=[[AdvertInfo alloc] init];
                    tmpstr=[tmpdic objectForKey:@"ad_id"];
                    if(![tmpstr isNull])
                        info.ad_id=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"ad_name"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.ad_name=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"ad_content"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.ad_content=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"picurl"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.ad_picurl=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"clickurl"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.ad_clickurl=tmpstr;
                    
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
