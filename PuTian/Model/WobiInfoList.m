//
//  WobiInfoList.m
//  PuTian
//
//  Created by guofeng on 15/9/19.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "WobiInfoList.h"
#import "ASIHTTPRequest.h"
#import "PlatServiceDataParser.h"

@implementation WobiInfo



@end


@interface WobiInfoList()
{
    NSMutableArray *_arrList;
}

@property (nonatomic,strong) ASIHTTPRequest *request;
@property (nonatomic,assign) SlideType slideType;
@property (atomic,assign) BOOL isLoading;

@end

@implementation WobiInfoList

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

-(void)loadDataWithSlideType:(SlideType)slideType
{
    if(!self.isLoading)
    {
        self.isLoading=YES;
        self.slideType=slideType;
        
        NSInteger tmpPageIndex=_pageIndex+1;
        if(self.slideType==SlideTypeNormal || self.slideType==SlideTypeDown)
            tmpPageIndex=1;
        
        NSString *urlString=[NSString stringWithFormat:@"%@?m=system&a=userwblist&uid=%d&pindex=%d&psize=%d",URL_Server,_userid,tmpPageIndex,_pageSize];
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
                
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
                for(NSDictionary *tmpdic in tmparr)
                {
                    NSString *tmpstr=nil;
                    WobiInfo *info=[[WobiInfo alloc] init];
                    tmpstr=[tmpdic objectForKey:@"id"];
                    if(![tmpstr isNull])
                        info.detailid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"fktype"];
                    if(![tmpstr isNull])
                        info.fktype=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"fktypename"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.fktypeName=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"wobi"];
                    if(![tmpstr isNull])
                        info.wobi=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"orderno"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.orderNo=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"createtime"];
                    if([tmpstr isNotNilOrEmptyString])
                    {
                        NSDate *date=[dateFormatter dateFromString:tmpstr];
                        info.createDate=date;
                    }
                    
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
