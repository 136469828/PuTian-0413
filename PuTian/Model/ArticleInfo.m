//
//  MazuInfo.m
//  PuTian
//
//  Created by guofeng on 15/10/22.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "ArticleInfo.h"
#import "ASIHTTPRequest.h"
#import "PlatServiceDataParser.h"
#import "CommentInfo.h"

@interface ArticleInfo()

@property (nonatomic,strong) ASIHTTPRequest *request1;
@property (nonatomic,strong) ASIHTTPRequest *request2;
@property (nonatomic,strong) ASIHTTPRequest *request3;
@property (atomic,assign) BOOL isLoading1;
@property (atomic,assign) BOOL isLoading2;
@property (atomic,assign) BOOL isLoading3;

@end

@implementation ArticleInfo

-(id)init
{
    if(self=[super init])
    {
        self.notificationName=kNotificationNameArticleInfo;
    }
    return self;
}

-(void)disposeRequest
{
    if(_request1)
    {
        [_request1 setDelegate:nil];
        self.request1=nil;
        self.isLoading1=NO;
    }
    if(_request2)
    {
        [_request2 setDelegate:nil];
        self.request2=nil;
        self.isLoading2=NO;
    }
    if(_request3)
    {
        [_request3 setDelegate:nil];
        self.request3=nil;
        self.isLoading3=NO;
    }
}

/** 加载数据(type:1) */
-(void)loadData
{
    if(!self.isLoading1)
    {
        self.isLoading1=YES;
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=article&a=getinfo&id=%d&uid=%d",URL_Server,_articleid,_uid];
        NSLog(@"JCK%@",urlString);
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        if(_request1)
        {
            [_request1 setDelegate:nil];
            self.request1=nil;
        }
        _request1=[[ASIHTTPRequest alloc] initWithURL:url];
        _request1.tag=1;
        [_request1 setDelegate:self];
        [_request1 setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request1 setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request1 setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request1 startAsynchronous];
    }
}

/** 提交评论(type:2) */
-(void)comment:(CommentInfo *)comment
{
    if(!self.isLoading2)
    {
        self.isLoading2=YES;
        
        NSString *strComment=comment.comment;
        if([strComment isNotNilOrEmptyString])
        {
            strComment=[strComment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        else
        {
            strComment=@"";
        }
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=comment&id=%d&uid=%d&stype=%d&gradetype=%d&star=%d&content=%@",URL_Server,_articleid,_uid,1,comment.gradeType,comment.grade,strComment];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        if(_request2)
        {
            [_request2 setDelegate:nil];
            self.request2=nil;
        }
        _request2=[[ASIHTTPRequest alloc] initWithURL:url];
        _request2.tag=2;
        [_request2 setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request2 setDelegate:self];
        [_request2 setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request2 setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request2 startAsynchronous];
    }
}

/** 收藏(type:3) */
-(void)collect:(BOOL)flag
{
    if(!self.isLoading3)
    {
        self.isLoading3=YES;
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=collection&id=%d&uid=%d&stype=%d&iscollect=%d",URL_Server,_articleid,_uid,1,flag];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        if(_request3)
        {
            [_request3 setDelegate:nil];
            self.request3=nil;
        }
        _request3=[[ASIHTTPRequest alloc] initWithURL:url];
        _request3.tag=3;
        [_request3 setTimeOutSeconds:kHttpRequestTimeoutSeconds];
        [_request3 setDelegate:self];
        [_request3 setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request3 setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request3 startAsynchronous];
    }
}

-(void)didFinishHttpRequest:(ASIHTTPRequest *)request
{
    BOOL hasNetworkFlags=[Common hasNetworkFlags];
    BOOL succeed=NO;
    id content=@"";
    NSString *msg=@"";
    NSInteger nType=request.tag;
    NSString *jsonString=[request responseString];
    NSDictionary *dic=[PlatServiceDataParser parseToDictionaryWithJsonString:jsonString];
    if(dic && [[dic objectForKey:@"state"] integerValue]==0)
    {
        succeed=YES;
        
        if([[dic objectForKey:@"msg"] isNotNilOrEmptyString])
        {
            msg=[dic objectForKey:@"msg"];
        }
        
        switch(nType)
        {
            case 1:
            {
                NSDictionary *tmpdic=[dic objectForKey:@"data"];
                if(tmpdic && [tmpdic isKindOfClass:[NSDictionary class]])
                {
                    if(![[tmpdic objectForKey:@"iscollect"] isNull])
                    {
                        self.isCollect=[[tmpdic objectForKey:@"iscollect"] boolValue];
                    }
                }
            }
                break;
            case 2: //提交评论
                if(![[dic objectForKey:@"data"] isNull])
                    content=[dic objectForKey:@"data"];
                break;
            case 3: //收藏
                self.isCollect=!_isCollect;
                break;
        }
        
    }
    else
    {
        if(dic && [[dic objectForKey:@"msg"] isNotNilOrEmptyString])
        {
            msg=[dic objectForKey:@"msg"];
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
    [userInfo setObject:content forKey:kNotificationContentKey];
    [userInfo setObject:msg forKey:kNotificationMessageKey];
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
        [userInfo setObject:@"" forKey:kNotificationContentKey];
        [userInfo setObject:@(request.tag) forKey:kNotificationTypeKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:userInfo];
    }
}

@end
