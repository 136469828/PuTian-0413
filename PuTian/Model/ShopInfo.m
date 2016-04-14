//
//  ShopInfo.m
//  PuTian
//
//  Created by guofeng on 15/9/12.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "ShopInfo.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "PlatServiceDataParser.h"

@interface ShopInfo()

@property (nonatomic,strong) ASIHTTPRequest *request;
@property (atomic,assign) BOOL isLoading;

@end

@implementation ShopInfo

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
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=shop&a=getinfo&id=%d",URL_Server,_shopid];
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

-(void)didFinishHttpRequest:(ASIHTTPRequest *)request
{
    BOOL hasNetworkFlags=[Common hasNetworkFlags];
    BOOL succeed=NO;
    BOOL hasData=NO;
    NSString *jsonString=[request responseString];
    NSDictionary *dic=[PlatServiceDataParser parseToDictionaryWithJsonString:jsonString];
    if(dic && [[dic objectForKey:@"state"] integerValue]==0)
    {
        succeed=YES;
        
        NSDictionary *tmpdic=[dic objectForKey:@"data"];
        if(tmpdic && [tmpdic isKindOfClass:[NSDictionary class]])
        {
            if(tmpdic.count>0)
            {
                hasData=YES;
                NSString *tmpstr=[tmpdic objectForKey:@"shopname"];
                if(![tmpstr isNull])
                    self.shopName=tmpstr;
                
                tmpstr=[tmpdic objectForKey:@"address"];
                if(![tmpstr isNull])
                    self.address=tmpstr;
                
                tmpstr=[tmpdic objectForKey:@"phone"];
                if(![tmpstr isNull])
                    self.phone=tmpstr;
                
                tmpstr=[tmpdic objectForKey:@"shophours"];
                if(![tmpstr isNull])
                    self.businessTime=tmpstr;
            }
        }
    }
    
    self.isLoading=NO;
    
    NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] init];
    [userInfo setObject:@(hasNetworkFlags) forKey:kNotificationNetworkFlagsKey];
    [userInfo setObject:@(succeed) forKey:kNotificationSucceedKey];
    [userInfo setObject:@(hasData) forKey:kNotificationContentKey];
    
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
