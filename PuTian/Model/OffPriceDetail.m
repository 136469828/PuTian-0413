//
//  OffPriceDetail.m
//  PuTian
//
//  Created by guofeng on 15/9/12.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "OffPriceDetail.h"
#import "ASIHTTPRequest.h"
#import "PlatServiceDataParser.h"
#import "CommentInfo.h"

@interface OffPriceDetail()

@property (nonatomic,strong) ASIHTTPRequest *request1;
@property (nonatomic,strong) ASIHTTPRequest *request2;
@property (nonatomic,strong) ASIHTTPRequest *request3;
@property (atomic,assign) BOOL isLoading1;
@property (atomic,assign) BOOL isLoading2;
@property (atomic,assign) BOOL isLoading3;

@end

@implementation OffPriceDetail

-(void)disposeRequest
{
    if(_request1)
    {
        [_request1 setDelegate:nil];
        self.request1=nil;
    }
    if(_request2)
    {
        [_request2 setDelegate:nil];
        self.request2=nil;
    }
    if(_request3)
    {
        [_request3 setDelegate:nil];
        self.request3=nil;
    }
}

/** 加载数据(type:1) */
-(void)loadData
{
    if(!self.isLoading1)
    {
        self.isLoading1=YES;
        NSString *urlString=nil;
        if(self.userid>0)
        {
            urlString=[[NSString alloc] initWithFormat:@"%@?m=product&a=getinfo&id=%d&uid=%d",URL_Server,_productid,self.userid];
        }
        else
        {
            urlString=[[NSString alloc] initWithFormat:@"%@?m=product&a=getinfo&id=%d",URL_Server,_productid];
        }
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
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=comment&id=%d&uid=%d&stype=%d&gradetype=%d&star=%d&content=%@",URL_Server,_productid,_userid,2,comment.gradeType,comment.grade,strComment];
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
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=collection&id=%d&uid=%d&stype=%d&iscollect=%d",URL_Server,_productid,_userid,2,flag];
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
    BOOL hasData=NO;
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
            case 1: //加载数据
            {
                NSDictionary *tmpdic=[dic objectForKey:@"data"];
                if(tmpdic && [tmpdic isKindOfClass:[NSDictionary class]])
                {
                    if(tmpdic.count>0)
                    {
                        hasData=YES;
                        NSString *tmpstr=[tmpdic objectForKey:@"productname"];
                        if(![tmpstr isNull])
                            self.productName=tmpstr;
                        
                        tmpstr=[tmpdic objectForKey:@"marketprice"];
                        if(![tmpstr isNull])
                            self.marketprice=[tmpstr floatValue];
                        
                        tmpstr=[tmpdic objectForKey:@"saleprice"];
                        if(![tmpstr isNull])
                            self.saleprice=[tmpstr floatValue];
                        
                        tmpstr=[tmpdic objectForKey:@"inventory"];
                        if(![tmpstr isNull])
                            self.inventory=[tmpstr integerValue];
                        
                        tmpstr=[tmpdic objectForKey:@"usedcount"];
                        if(![tmpstr isNull])
                            self.buyerCount=[tmpstr integerValue];
                        
                        tmpstr=[tmpdic objectForKey:@"introduce"];
                        if(![tmpstr isNull])
                            self.introduce=tmpstr;
                        
                        tmpstr=[tmpdic objectForKey:@"thumbimg"];
                        if(![tmpstr isNull])
                            self.thumbimg=tmpstr;
                        
                        tmpstr=[tmpdic objectForKey:@"shopid"];
                        if(![tmpstr isNull])
                            self.shopid=[tmpstr integerValue];
                        
                        NSDate *date=nil;
                        NSDateFormatter *dateFormatter=nil;
                        tmpstr=[tmpdic objectForKey:@"validity_start"];
                        if([tmpstr isNotNilOrEmptyString])
                        {
                            dateFormatter=[[NSDateFormatter alloc] init];
                            dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
                            date=[dateFormatter dateFromString:tmpstr];
                            if(date)
                            {
                                dateFormatter.dateFormat=@"yyyy/MM/dd";
                                self.validity_start=[dateFormatter stringFromDate:date];
                            }
                        }
                        
                        tmpstr=[tmpdic objectForKey:@"validity_end"];
                        if([tmpstr isNotNilOrEmptyString])
                        {
                            dateFormatter=[[NSDateFormatter alloc] init];
                            dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
                            date=[dateFormatter dateFromString:tmpstr];
                            if(date)
                            {
                                dateFormatter.dateFormat=@"yyyy/MM/dd";
                                self.validity_end=[dateFormatter stringFromDate:date];
                            }
                        }
                        
                        if(![[tmpdic objectForKey:@"photos"] isNull])
                        {
                            self.photos=[tmpdic objectForKey:@"photos"];
                        }
                        
                        if(![[tmpdic objectForKey:@"iscollect"] isNull])
                        {
                            self.isCollect=[[tmpdic objectForKey:@"iscollect"] boolValue];
                        }
                    }
                }
            }
                break;
            case 2: //提交评论
                
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
    [userInfo setObject:@(hasData) forKey:kNotificationContentKey];
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
        [userInfo setObject:@"0" forKey:kNotificationContentKey];
        [userInfo setObject:@(request.tag) forKey:kNotificationTypeKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:self userInfo:userInfo];
    }
}

@end
