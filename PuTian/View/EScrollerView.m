//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
#import "MyWebImage.h"

#import "UIImageView+WebCache.h"
#import "AdvertInfoList.h"

@interface EScrollerView()

@property (nonatomic,assign) BOOL isShowTitle;

@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableArray *titleArray;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation EScrollerView

-(void)startAutoPlayWithInterval:(NSTimeInterval)interval
{
    if(self.pageCount<4)return;
    
    if(_timer)
    {
        if([_timer isValid])
            [_timer invalidate];
        self.timer=nil;
    }
    self.timer=[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
}
-(void)timerEvent:(NSTimer *)timer
{
    NSInteger page=self.currentPageIndex+1;
    if(page>self.pageCount)
        page=1;
    [self scrollToPage:page];
}

-(id)initWithFrame:(CGRect)frame isShowTitle:(BOOL)isShowTitle
{
    if(self=[super initWithFrame:frame])
    {
        self.userInteractionEnabled=YES;
        
        self.isShowTitle=isShowTitle;
        
        _titleArray=[[NSMutableArray alloc] init];
        _imageArray=[[NSMutableArray alloc] init];
        
        viewSize=frame;
        
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        //说明文字层
        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-33,self.bounds.size.width,33)];
        //[noteView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
        noteView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:noteView];
        
        float pageControlWidth=40.f;
        float pagecontrolHeight=20.0f;
        if(self.isShowTitle)
        {
            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),noteView.y+6, pageControlWidth, pagecontrolHeight)];
        }
        else
        {
            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth)/2.0,noteView.y+6, pageControlWidth, pagecontrolHeight)];
        }
        pageControl.currentPage=0;
        pageControl.numberOfPages=0;
        pageControl.hidden=YES;
        pageControl.pageIndicatorTintColor=[UIColor colorWithWhite:0.5 alpha:1.0];
        //pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        [self addSubview:pageControl];
        
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, noteView.y+6, self.frame.size.width-pageControlWidth-15, 20)];
        noteTitle.textColor=[UIColor whiteColor];
        [noteTitle setBackgroundColor:[UIColor clearColor]];
        [noteTitle setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:noteTitle];
    }
    return self;
}
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr
{
    
	if ((self=[super initWithFrame:rect]))
    {
        self.userInteractionEnabled=YES;
        
        _titleArray=[[NSMutableArray alloc] initWithArray:titArr];
        
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
		_imageArray=[[NSMutableArray alloc] initWithArray:tempArray];
        
		viewSize=rect;
        
        self.pageCount=_imageArray.count;
        
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * _pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        for (int i=0; i<_pageCount; i++) {
            NSString *imgURL=[_imageArray objectAtIndex:i];
            MyWebImage *imgView=[[MyWebImage alloc] init];
            if ([imgURL hasPrefix:@"http://"] || [imgURL hasPrefix:@"https://"])
            {
                //网络图片 请使用ego异步图片库
                //[imgView setImageWithURL:[NSURL URLWithString:imgURL]];
                [imgView setImageWithUrl:imgURL callback:nil];
            }
            else
            {
                
                UIImage *img=[UIImage imageNamed:[_imageArray objectAtIndex:i]];
                [imgView setImage:img];
            }
            
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag=i;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
        }
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];

        
        
        //说明文字层
        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-33,self.bounds.size.width,33)];
        [noteView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
        
        float pageControlWidth=(_pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=20.0f;
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),6, pageControlWidth, pagecontrolHeight)];
        pageControl.currentPage=0;
        pageControl.numberOfPages=(_pageCount-2);
        if(self.pageCount<4)
        {
            pageControl.hidden=YES;
            scrollView.scrollEnabled=NO;
        }
        [noteView addSubview:pageControl];
        
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 6, self.frame.size.width-pageControlWidth-15, 20)];
        if(_titleArray.count>0)
            [noteTitle setText:[_titleArray objectAtIndex:0]];
        [noteTitle setBackgroundColor:[UIColor clearColor]];
        [noteTitle setFont:[UIFont systemFontOfSize:13]];
        [noteView addSubview:noteTitle];
        
        [self addSubview:noteView];
	}
	return self;
}
/** 填充广告栏数据 */
-(void)fillAdvertDataWithImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr
{
    if(_timer)
    {
        if([_timer isValid])
            [_timer invalidate];
        self.timer=nil;
    }
    
    if(scrollView.subviews && scrollView.subviews.count>0)
    {
        NSMutableArray *tmparr=[[NSMutableArray alloc] init];
        for(int i=0;i<scrollView.subviews.count;i++)
        {
            UIView *tmpview=[scrollView.subviews objectAtIndex:i];
            if([tmpview isKindOfClass:[MyWebImage class]])
            {
                [tmparr addObject:tmpview];
            }
        }
        
        for(UIView *v in tmparr)[v removeFromSuperview];
    }
    
    [_titleArray removeAllObjects];
    [_imageArray removeAllObjects];
    
    if(imgArr && imgArr.count>0)
    {
        [_titleArray addObjectsFromArray:titArr];
        [_imageArray addObjectsFromArray:imgArr];
        
        [_imageArray insertObject:[imgArr objectAtIndex:imgArr.count-1] atIndex:0];
        [_imageArray addObject:[imgArr objectAtIndex:0]];
        
        self.pageCount=_imageArray.count;
        
        for (int i=0; i<_pageCount; i++)
        {
            NSString *imgURL=[_imageArray objectAtIndex:i];
            MyWebImage *imgView=[[MyWebImage alloc] init];
            imgView.contentMode=UIViewContentModeScaleAspectFill;
            if ([imgURL hasPrefix:@"http://"] || [imgURL hasPrefix:@"https://"])
            {
                //网络图片 请使用ego异步图片库
                //[imgView setImageWithURL:[NSURL URLWithString:imgURL]];
                [imgView setImageWithUrl:imgURL callback:nil];
            }
            else
            {
                
                UIImage *img=[UIImage imageNamed:[_imageArray objectAtIndex:i]];
                [imgView setImage:img];
            }
            
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag=i;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
        }
        scrollView.contentSize = CGSizeMake(viewSize.size.width*_pageCount, viewSize.size.height);
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
        float pageControlWidth=(_pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=20.0f;
        if(self.isShowTitle)
        {
            pageControl.frame=CGRectMake((self.frame.size.width-pageControlWidth),pageControl.y, pageControlWidth, pagecontrolHeight);
        }
        else
        {
            pageControl.frame=CGRectMake((self.frame.size.width-pageControlWidth)/2.0,pageControl.y, pageControlWidth, pagecontrolHeight);
        }
        pageControl.currentPage=0;
        pageControl.numberOfPages=(_pageCount-2);
        
        if(self.pageCount<4)
        {
            pageControl.hidden=YES;
            scrollView.scrollEnabled=NO;
        }
        else
        {
            pageControl.hidden=NO;
            scrollView.scrollEnabled=YES;
        }
        
        if(self.isShowTitle)
        {
            if(_titleArray.count>0)
                [noteTitle setText:[_titleArray objectAtIndex:0]];
            else
                [noteTitle setText:@""];
        }
    }
    else
    {
        self.pageCount=0;
        
        scrollView.contentSize = CGSizeMake(viewSize.size.width, viewSize.size.height);
        [scrollView setContentOffset:CGPointMake(0, 0)];
        
        pageControl.hidden=YES;
        [noteTitle setText:@""];
    }
}
/** 填充广告栏数据 */
-(void)fillAdvertData:(AdvertInfoList *)infoList ImgStr:(NSString *)imgStr
{
    if(_timer)
    {
        if([_timer isValid])
            [_timer invalidate];
        self.timer=nil;
    }
    
    NSLog(@"%ld",scrollView.subviews.count);
    if(scrollView.subviews && scrollView.subviews.count > 0)
    {
        NSMutableArray *tmparr=[[NSMutableArray alloc] init];
        for(int i=0;i<scrollView.subviews.count;i++)
        {
            UIView *tmpview=[scrollView.subviews objectAtIndex:i];
            if([tmpview isKindOfClass:[MyWebImage class]])
            {
                [tmparr addObject:tmpview];
            }
        }
        
        for(UIView *v in tmparr)[v removeFromSuperview];
    }
    
    [_titleArray removeAllObjects];
    [_imageArray removeAllObjects];
    NSLog(@"%ld",infoList.list.count);
    if(infoList && infoList.list.count>0)
    {
        for (int i=0; i<infoList.list.count; i++)
        {
            AdvertInfo *info=[infoList.list objectAtIndex:i];
            [_titleArray addObject:info.ad_name];
            [_imageArray addObject:info.ad_picurl]; //滚动视图图片名
        }
        
        AdvertInfo *tmpInfo=[infoList.list objectAtIndex:(infoList.list.count-1)];
        [_imageArray insertObject:tmpInfo.ad_picurl atIndex:0];
        tmpInfo=[infoList.list objectAtIndex:0];
        [_imageArray addObject:tmpInfo.ad_picurl];
        
        self.pageCount=_imageArray.count;
        
        for (int i=0; i<_pageCount; i++)
        {
            NSString *imgURL=[_imageArray objectAtIndex:i];
            MyWebImage *imgView=[[MyWebImage alloc] init];
            imgView.contentMode=UIViewContentModeScaleAspectFill;
            [imgView setImageWithUrl:imgURL callback:nil];
            
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag=i;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
        }
        scrollView.contentSize = CGSizeMake(viewSize.size.width*_pageCount, viewSize.size.height);
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
        float pageControlWidth=(_pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=20.0f;
        if(self.isShowTitle)
        {
            pageControl.frame=CGRectMake((self.frame.size.width-pageControlWidth),pageControl.y, pageControlWidth, pagecontrolHeight);
        }
        else
        {
            pageControl.frame=CGRectMake((self.frame.size.width-pageControlWidth)/2.0,pageControl.y, pageControlWidth, pagecontrolHeight);
        }
        pageControl.currentPage=0;
        pageControl.numberOfPages=(_pageCount-2);
        
        if(self.pageCount<4)
        {
            pageControl.hidden=YES;
            scrollView.scrollEnabled=NO;
        }
        else
        {
            pageControl.hidden=NO;
            scrollView.scrollEnabled=YES;
        }
        
        if(self.isShowTitle)
        {
            if(_titleArray.count>0)
                [noteTitle setText:[_titleArray objectAtIndex:0]];
            else
                [noteTitle setText:@""];
        }
    }
    else
    {
        self.pageCount=0;
    
        scrollView.contentSize = CGSizeMake(viewSize.size.width, viewSize.size.height);
        [scrollView setContentOffset:CGPointMake(0, 0)];
        
        pageControl.hidden=YES;
        [noteTitle setText:@""];
        // 假如获取不到网络图片就用产品介绍图
        // coding...
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth , 40)];
        NSLog(@"%@",imgStr);
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgStr]];
        
        [scrollView addSubview:imgView];

    }
}
-(void)scrollToPage:(NSInteger)index
{
    [scrollView scrollRectToVisible:CGRectMake(index*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
}


-(void)removeFromSuperview
{
    if(_timer)
    {
        if(_timer.isValid)
            [_timer invalidate];
        self.timer=nil;
    }
    [super removeFromSuperview];
}


- (void)setPageAndTitle:(UIScrollView *)_scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentPageIndex=page;
    
    pageControl.currentPage=(page-1);
    
    int titleIndex=page-1;
//    if (titleIndex==[_titleArray count]) {
//        titleIndex=0;
//    }
//    if (titleIndex<0) {
//        titleIndex=[_titleArray count]-1;
//    }
    if(self.isShowTitle)
    {
        if(_titleArray.count>titleIndex)
            [noteTitle setText:[_titleArray objectAtIndex:titleIndex]];
        else
            [noteTitle setText:@""];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    [self setPageAndTitle:sender];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)_scrollView
{
    if (self.currentPageIndex==0) {
        
        [_scrollView setContentOffset:CGPointMake(([_imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (self.currentPageIndex==([_imageArray count]-1)) {
        
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (self.currentPageIndex==0) {
      
        [_scrollView setContentOffset:CGPointMake(([_imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (self.currentPageIndex==([_imageArray count]-1)) {
       
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        
    }
}
- (void)imagePressed:(UITapGestureRecognizer *)sender
{

    if ([_delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [_delegate EScrollerViewDidClicked:sender.view.tag];
    }
}

@end
