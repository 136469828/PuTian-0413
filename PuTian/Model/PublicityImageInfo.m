//
//  PublicityImageInfo.m
//  PuTian
//
//  Created by guofeng on 15/10/21.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import "PublicityImageInfo.h"
#import "ASIHTTPRequest.h"
#import "PlatServiceDataParser.h"

@interface PublicityImageInfo()

@property (nonatomic,strong) NSString *cacheInfoPath;
@property (nonatomic,strong) NSString *cacheImagePath;

@property (nonatomic,strong) ASIHTTPRequest *request;
@property (nonatomic,assign) BOOL isLoading;

@end

@implementation PublicityImageInfo

-(NSData *)imageData
{
    if([[NSFileManager defaultManager] fileExistsAtPath:_cacheImagePath])
    {
        return [NSData dataWithContentsOfFile:_cacheImagePath];
    }
    return nil;
}

-(id)init
{
    if(self=[super init])
    {
        _cacheInfoPath=[[NSString alloc] initWithFormat:@"%@/publicityimageinfo.cache",[Common mCacheDirectory]];
        _cacheImagePath=[[NSString alloc] initWithFormat:@"%@/publicityimage.cache",[Common mCacheDirectory]];
        
        [self readCache];
    }
    return self;
}

-(void)readCache
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:_cacheInfoPath] && [fileManager fileExistsAtPath:_cacheImagePath])
    {
        NSDictionary *tmpdic=[[NSDictionary alloc] initWithContentsOfFile:_cacheInfoPath];
        self.ad_id=[[tmpdic objectForKey:@"ad_id"] integerValue];
        self.name=[tmpdic objectForKey:@"name"];
        self.content=[tmpdic objectForKey:@"content"];
        self.picurl=[tmpdic objectForKey:@"picurl"];
    }
}
-(void)saveCache
{
    if([_picurl isNotNilOrEmptyString])
    {
        if(_name==nil)self.name=@"";
        if(_content==nil)self.content=@"";
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^
        {
            NSURL *url=[[NSURL alloc] initWithString:_picurl];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            
            NSHTTPURLResponse *response = nil;
            NSError *error=nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if(response.statusCode==200 && data)
            {
                [data writeToFile:_cacheImagePath atomically:YES];
                
                NSMutableDictionary *tmpdic=[[NSMutableDictionary alloc] init];
                [tmpdic setObject:@(_ad_id) forKey:@"ad_id"];
                [tmpdic setObject:_name forKey:@"name"];
                [tmpdic setObject:_content forKey:@"content"];
                [tmpdic setObject:_picurl forKey:@"picurl"];
                [tmpdic setObject:[Common appVersion] forKey:@"appversion"];
                [tmpdic writeToFile:_cacheInfoPath atomically:YES];
            }
        });
    }
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
        
        [self disposeRequest];
        
        NSString *urlString=[[NSString alloc] initWithFormat:@"%@?m=system&a=getStartPage",URL_Server];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
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
    BOOL succeed=NO;
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
                for(NSDictionary *tmpdic in tmparr)
                {
                    NSString *tmpstr=nil;
                    
                    tmpstr=[tmpdic objectForKey:@"picurl"];
                    if([tmpstr isNotNilOrEmptyString])
                    {
                        if(![tmpstr isEqualToString:_picurl])
                        {
                            self.picurl=tmpstr;
                            
                            tmpstr=[tmpdic objectForKey:@"ad_id"];
                            if(![tmpstr isNull])
                                self.ad_id=[tmpstr integerValue];
                            
                            tmpstr=[tmpdic objectForKey:@"name"];
                            if(![tmpstr isNull])
                                self.name=tmpstr;
                            
                            tmpstr=[tmpdic objectForKey:@"content"];
                            if(![tmpstr isNull])
                                self.content=tmpstr;
                            
                            [self saveCache];
                        }
                        
                        break;
                    }
                }
            }
        }
    }
    
    self.isLoading=NO;
}

-(void)didFailedHttpRequest:(ASIHTTPRequest *)request
{
    self.isLoading=NO;
}

@end
