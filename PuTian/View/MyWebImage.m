//
//  MyWebImage.m
//  CollocationIPAD
//
//  Created by guofeng on 13-7-17.
//
//

#import "MyWebImage.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface MyWebImage()

@property (nonatomic,assign) BOOL isRemoved;

@property (nonatomic,strong) ASIHTTPRequest *request;

@property (nonatomic,strong) void (^ callbackForLoad)(BOOL succeed);

@end

@implementation MyWebImage

/** 加载网络图片 */
-(void)setImageWithUrl:(NSString *)urlString callback:(void (^)(BOOL))callback
{
    if(_request)
    {
        self.request.delegate=nil;
        self.request=nil;
    }
    self.image=nil;
    
    if([urlString isNotNilOrEmptyString])
    {
        self.callbackForLoad=callback;
        
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        _request=[[ASIHTTPRequest alloc] initWithURL:url];
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
                self.image=image;
                
                if(self.isFadeIn)
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
