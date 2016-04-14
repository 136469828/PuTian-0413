//
//  UnionOffPriceInfoList.m
//  PuTian
//
//  Created by guofeng on 15/9/16.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "UnionOffPriceInfoList.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "PlatServiceDataParser.h"

@interface UnionOffPriceInfoList()
{
    NSMutableArray *_arrList;
}

@property (nonatomic,strong) ASIHTTPRequest *request;
@property (atomic,assign) BOOL isLoading;

@end

@implementation UnionOffPriceInfoList

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

-(void)loadDataWithNumber:(NSInteger)number
{
    if(!self.isLoading)
    {
        self.isLoading=YES;
        
        [_arrList removeAllObjects];
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=product&a=getunionbyshop&num=%d&shopid=%d",URL_Server,number,_shopid];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        if(_request)
        {
            [_request setDelegate:nil];
            self.request=nil;
        }
        _request=[[ASIHTTPRequest alloc] initWithURL:url];
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
                    OffPriceInfo *info=[[OffPriceInfo alloc] init];
                    tmpstr=[tmpdic objectForKey:@"productid"];
                    if(![tmpstr isNull])
                        info.productid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"shopid"];
                    if(![tmpstr isNull])
                        info.shopid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"productname"];
                    if(![tmpstr isNull])
                        info.title=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"thumbimg"];
                    if(![tmpstr isNull])
                        info.imageUrl=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"marketprice"];
                    if(![tmpstr isNull])
                        info.marketprice=[tmpstr floatValue];
                    
                    tmpstr=[tmpdic objectForKey:@"saleprice"];
                    if(![tmpstr isNull])
                        info.saleprice=[tmpstr floatValue];
                    
                    tmpstr=[tmpdic objectForKey:@"usedcount"];
                    if(![tmpstr isNull])
                        info.buyerCount=[tmpstr integerValue];
                    
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
