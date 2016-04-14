//
//  MeishiInfoList.m
//  PuTian
//
//  Created by admin on 16/3/28.
//  Copyright © 2016年 guofeng. All rights reserved.
//

#import "MeishiInfoList.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "PlatServiceDataParser.h"
@interface MeishiInfoList()
{
    NSMutableArray *_arrList;
}

@property (nonatomic,strong) ASIHTTPRequest *request;
@property (nonatomic,assign) SlideType slideType;
@property (atomic,assign) BOOL isLoading;

@end
@implementation MeishiInfoList
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
        //        if(_arrList.count==0)
        //            self.slideType=SlideTypeNormal;
        
        NSInteger tmpPageIndex=_pageIndex+1;
        if(self.slideType==SlideTypeNormal || self.slideType==SlideTypeDown)
            tmpPageIndex=1;
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=article&a=getlist&term_id=%d&uid=%d&pindex=%d&psize=%d",URL_Server,self.termId,_uid,tmpPageIndex,_pageSize];
        NSLog(@"JCK%ld",self.termId);
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        
        if(_request)
        {
            [_request setDelegate:nil];
            self.request=nil;
        }
        _request=[[ASIHTTPRequest alloc] initWithURL:url];
        if(self.slideType==SlideTypeNormal)
        {
            [_request setDownloadCache:[ASIDownloadCache sharedCache]];
            [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        }
        [_request setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request setDelegate:self];
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
                    ArticleInfo *info=[[ArticleInfo alloc] init];
                    
                    tmpstr=[tmpdic objectForKey:@"id"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.articleid=[tmpstr integerValue];
                    
                    tmpstr=[tmpdic objectForKey:@"post_title"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.title=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"post_excerpt"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.excerpt=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"picurl"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.imageUrl=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"comment_count"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.comment_count=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"post_hits"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.post_hits=tmpstr;
                    
                    tmpstr=[tmpdic objectForKey:@"post_date"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.post_date=tmpstr;
                    
                    
                    tmpstr=[tmpdic objectForKey:@"url"];
                    if([tmpstr isNotNilOrEmptyString])
                        info.urlString=tmpstr;
                    
                    if(![[tmpdic objectForKey:@"iscollect"] isNull])
                        info.isCollect=[[tmpdic objectForKey:@"iscollect"] boolValue];
                    
                    //totalcount
                    
                    
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
