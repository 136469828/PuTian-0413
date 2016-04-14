//
//  CollectionInfoList.m
//  PuTian
//
//  Created by guofeng on 15/10/14.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "CollectionInfoList.h"
#import "ASIHTTPRequest.h"
#import "PlatServiceDataParser.h"

@implementation CollectionInfo

@end

@interface CollectionInfoList()
{
    NSMutableArray *_arrList;
}

@property (nonatomic,strong) ASIHTTPRequest *request;
@property (nonatomic,assign) SlideType slideType;
@property (atomic,assign) BOOL isLoading;

@end

@implementation CollectionInfoList

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
        
        NSString *urlString=nil;
        if(self.collectType==1)
        {
            urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=getcollection&uid=%d&stype=%d&term_id=%d&pindex=%d&psize=%d",URL_Server,_userid,_collectType,_term_id,tmpPageIndex,_pageSize];
                NSLog(@"JCK%@",urlString);
        }
        else
        {
            urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=getcollection&uid=%d&stype=%d&pindex=%d&psize=%d",URL_Server,_userid,_collectType,tmpPageIndex,_pageSize];
            NSLog(@"JCK%@",urlString);
        }
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
                    CollectionInfo *info=[[CollectionInfo alloc] init];
                    if(![[tmpdic objectForKey:@"id"] isNull])
                        info.collectionid=[[tmpdic objectForKey:@"id"] integerValue];
                    if(![[tmpdic objectForKey:@"post_id"] isNull])
                        info.post_id=[[tmpdic objectForKey:@"post_id"] integerValue];
                    if(![[tmpdic objectForKey:@"post_title"] isNull])
                        info.post_title=[tmpdic objectForKey:@"post_title"];
                    if(![[tmpdic objectForKey:@"post_introduce"] isNull])
                        info.post_introduce=[tmpdic objectForKey:@"post_introduce"];
                    if(![[tmpdic objectForKey:@"url"] isNull])
                        info.url=[tmpdic objectForKey:@"url"];
                    
                    tmpstr=[tmpdic objectForKey:@"createtime"];
                    if([tmpstr isNotNilOrEmptyString])
                    {
                        NSDate *date=[dateFormatter dateFromString:tmpstr];
                        info.date=date;
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