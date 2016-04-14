//
//  CouponsDownload.m
//  PuTian
//
//  Created by guofeng on 15/9/19.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "CouponsDownload.h"
#import "ASIHTTPRequest.h"
#import "PlatServiceDataParser.h"

@interface CouponsDownload()

@property (nonatomic,strong) ASIHTTPRequest *request;
@property (atomic,assign) BOOL isLoading;

@end

@implementation CouponsDownload

-(void)disposeRequest
{
    if(_request)
    {
        [_request setDelegate:nil];
        self.request=nil;
    }
}

-(void)downloadWithCount:(NSInteger)count
{
    if(!self.isLoading)
    {
        self.isLoading=YES;
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=order&a=add&uid=%d&productid=%d&qty=%d",URL_Server,_userid,_productid,count];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        if(_request)
        {
            [_request setDelegate:nil];
            self.request=nil;
        }
        _request=[[ASIHTTPRequest alloc] initWithURL:url];
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}

-(void)didFinishHttpRequest:(ASIHTTPRequest *)request
{
    BOOL hasNetworkFlags=[Common hasNetworkFlags];
    BOOL succeed=NO;
    NSString *jsonString=[request responseString];
    NSDictionary *dic=[PlatServiceDataParser parseToDictionaryWithJsonString:jsonString];
    if(dic && [[dic objectForKey:@"state"] integerValue]==0)
    {
        succeed=YES;
        
        NSString *tmpstr=[dic objectForKey:@"data"];
        if([tmpstr isNotNilOrEmptyString])
        {
            self.orderNo=tmpstr;
        }
    }
    
    self.isLoading=NO;
    
    NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] init];
    [userInfo setObject:@(hasNetworkFlags) forKey:kNotificationNetworkFlagsKey];
    [userInfo setObject:@(succeed) forKey:kNotificationSucceedKey];
    
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:userInfo];
    }
}

@end
