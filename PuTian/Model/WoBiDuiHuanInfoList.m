//
//  OffPriceInfoList.m
//  PuTian
//
//  Created by guofeng on 15/9/9.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "WoBiDuiHuanInfoList.h"
#import "ASIHTTPRequest.h"
#import "PlatServiceDataParser.h"
#import "UserInfo.h"

@implementation WoBiDuanHuanInfo



@end



@interface WoBiDuanHuanInfoList()
{
    NSMutableArray *_arrList;
}

@property (nonatomic,strong) ASIHTTPRequest *request;
@property (nonatomic,assign) SlideType slideType;
@property (atomic,assign) BOOL isLoading;

@end

@implementation WoBiDuanHuanInfoList

-(NSArray *)list
{
    return _arrList;
}
-(void)clearList
{
    _pageIndex=0;
    _pageCount=0;
    _recordCount=0;
    if(_arrList && _arrList.count>0)
        [_arrList removeAllObjects];
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
        _pageSize=kHttpRequestDataPageCountDefault;
        _arrList=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadDataWithSlideType:(SlideType)slideType keywords:(NSString *)keywords
{
    if(!self.isLoading)
    {
        self.isLoading=YES;
        self.slideType=slideType;
        
        [self disposeRequest];
        
        NSInteger tmpPageIndex=_pageIndex+1;
        if(self.slideType==SlideTypeNormal || self.slideType==SlideTypeDown)
            tmpPageIndex=1;
        
        if(keywords==nil)keywords=@"";
        NSString *urlString=nil;
        if([keywords isNotNilOrEmptyString])
        {
            urlString=[[NSString alloc] initWithFormat:@"%@?m=productpoint&a=getlist&pindex=%d&psize=%d&keyword=%@",URL_Server,tmpPageIndex,_pageSize,[keywords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            urlString=[[NSString alloc] initWithFormat:@"%@?m=productpoint&a=getlist&pindex=%d&psize=%d",URL_Server,tmpPageIndex,_pageSize];
//            NSLog(@"%@",urlString);
        }
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        NSLog(@"JCK%@",urlString);
        _request=[[ASIHTTPRequest alloc] initWithURL:url];
        [_request setDelegate:self];
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        //[_request setDidStartSelector:@selector(didStartHttpRequest:)];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}

-(void)loadDataWithSlideTypeFordingdan:(SlideType)slideType keywords:(NSString *)keywords UserId:(NSString *)userid
{
    if(!self.isLoading)
    {
        self.isLoading=YES;
        self.slideType=slideType;
        
        [self disposeRequest];
        
        NSInteger tmpPageIndex=_pageIndex+1;
        if(self.slideType==SlideTypeNormal || self.slideType==SlideTypeDown)
            tmpPageIndex=1;
        
        if(keywords==nil)keywords=@"";
        NSString *urlString=nil;
        if([keywords isNotNilOrEmptyString])
        {
            urlString=[[NSString alloc] initWithFormat:@"%@?m=orderpoint&a=getlist&pindex=%d&uid=%d",URL_Server,tmpPageIndex,userid,[keywords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            urlString=[[NSString alloc] initWithFormat:@"%@?m=orderpoint&a=getlist&pindex=%d&uid=%@",URL_Server,tmpPageIndex,userid];
        }
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        _request=[[ASIHTTPRequest alloc] initWithURL:url];
        [_request setDelegate:self];
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        //[_request setDidStartSelector:@selector(didStartHttpRequest:)];
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
        _recordCount=[[dic objectForKey:@"totalcount"] integerValue];
        _pageCount=(_recordCount-1)/_pageSize+1;
        
        if(self.slideType==SlideTypeDown || self.slideType==SlideTypeNormal)
        {
            [_arrList removeAllObjects];
            _pageIndex=1;
        }
        
        NSArray *tmparr=[dic objectForKey:@"data"];
        if(tmparr && [tmparr isKindOfClass:[NSArray class]])
        {
            if(tmparr.count>0)
            {
                requestCount=tmparr.count;
                if(self.slideType==SlideTypeUp)
                {
                    _pageIndex++;
                }
                
                for(NSDictionary *tmpdic in tmparr)
                {
                    NSString *tmpstr=nil;
                    WoBiDuanHuanInfo *info=[[WoBiDuanHuanInfo alloc] init];
                    tmpstr=[tmpdic objectForKey:@"id"];
                    if(![tmpstr isNull])
                        info.productid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"shopid"];
                    if(![tmpstr isNull])
                        info.shopid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"name"];
                    if(![tmpstr isNull])
                        info.title=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"introduce"];
                    if(![tmpstr isNull])
                        info.introduce=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"thumbimg"];
                    if(![tmpstr isNull])
                        info.imageUrl=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"status"];
                    if(![tmpstr isNull])
                        info.status=[tmpstr floatValue];
                    
                    tmpstr=[tmpdic objectForKey:@"use_point"];
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:tmpstr forKey:@"use_point"];
                    [user synchronize];
                    if(![tmpstr isNull])
                        info.use_point=[tmpstr floatValue];
                    tmpstr=[tmpdic objectForKey:@"point"];
                    if(![tmpstr isNull])
                        info.use_point=[tmpstr floatValue];
                    
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
    [userInfo setObject:@(self.pageIndex) forKey:kNotificationPageIndexKey];
    [userInfo setObject:@(self.slideType) forKey:kNotificationSlideTypeKey];
    
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
        [userInfo setObject:@(self.slideType) forKey:kNotificationSlideTypeKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:userInfo];
    }
}

@end
