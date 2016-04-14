//
//  MyWebButton.m
//  MyTest
//
//  Created by guofeng on 13-7-11.
//
//

#import "MyWebButton.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface MyWebButton()

@property (nonatomic,assign) BOOL isRemoved;

@property (nonatomic,strong) ASIHTTPRequest *request;

@property (nonatomic,strong) void (^ callbackForLoad)(BOOL succeed);

@end

@implementation MyWebButton

/** 加载网络图片 */
-(void)setImageWithUrl:(NSString *)urlString callback:(void (^)(BOOL))callback
{
    if(_request)
    {
        _request.delegate=nil;
        self.request=nil;
    }
    [self setImage:nil forState:UIControlStateNormal];
    
    if([urlString isNotNilOrEmptyString])
    {
        self.callbackForLoad=callback;
        
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        _request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=1;
        [_request setDownloadCache:[ASIDownloadCache sharedCache]];
        [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}
/** 加载网络图片 */
-(void)setBackgroundImageWithUrl:(NSString *)urlString callback:(void (^)(BOOL))callback
{
    if(_request)
    {
        _request.delegate=nil;
        self.request=nil;
    }
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    
    if([urlString isNotNilOrEmptyString])
    {
        self.callbackForLoad=callback;
        
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        _request=[[ASIHTTPRequest alloc] initWithURL:url];
        _request.tag=2;
        [_request setDownloadCache:[ASIDownloadCache sharedCache]];
        [_request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [_request setDelegate:self];
        [_request setDidFinishSelector:@selector(didFinishHttpRequest:)];
        [_request setDidFailSelector:@selector(didFailedHttpRequest:)];
        [_request startAsynchronous];
    }
}

-(void)didFinishHttpRequest:(ASIHTTPRequest *)request
{
    if(request!=self.request)return;
    
    UIImage *image=nil;
    if(request.responseStatusCode==200)
    {
        if(!_isRemoved)
        {
            image=[[UIImage alloc] initWithData:request.responseData];
            if(image)
            {
                if(request.tag==1)
                    [self setImage:image forState:UIControlStateNormal];
                else if(request.tag==2)
                    [self setBackgroundImage:image forState:UIControlStateNormal];
                
                if(self.isFadeIn)
                {
                    if(request.tag==1)
                    {
                        self.imageView.alpha=0;
                        [UIView animateWithDuration:0.5 animations:^
                         {
                             self.imageView.alpha=1;
                         }];
                    }
                    else if(request.tag==2)
                    {
                        self.alpha=0;
                        [UIView animateWithDuration:0.5 animations:^
                        {
                            self.alpha=1;
                        }];
                    }
                }
            }
        }
    }
    
    if(self.callbackForLoad)
    {
        if(image)
            self.callbackForLoad(YES);
        else
            self.callbackForLoad(NO);
    }
}

-(void)didFailedHttpRequest:(ASIHTTPRequest *)request
{
    if(self.request==request && !self.isRemoved && self.callbackForLoad)
        self.callbackForLoad(NO);
}

-(void)removeFromSuperview
{
    self.isRemoved=YES;
    
    if(_request)
    {
        self.request.delegate=nil;
        self.request=nil;
    }
    
    [super removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
