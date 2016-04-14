//
//  EScrollerView.h
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import <UIKit/UIKit.h>

@class AdvertInfoList;

@protocol EScrollerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(NSUInteger)index;
@end

@interface EScrollerView : UIView<UIScrollViewDelegate> {
	CGRect viewSize;
	UIScrollView *scrollView;
    UIPageControl *pageControl;
    UILabel *noteTitle;
}

@property(nonatomic,retain) id<EScrollerViewDelegate> delegate;
@property(nonatomic,assign) NSUInteger pageCount;
@property(nonatomic,assign) int currentPageIndex;

-(id)initWithFrame:(CGRect)frame isShowTitle:(BOOL)isShowTitle;
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr;
/** 填充广告栏数据 */
-(void)fillAdvertDataWithImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr;
/** 填充广告栏数据 */
//-(void)fillAdvertData:(AdvertInfoList *)infoList;
-(void)fillAdvertData:(AdvertInfoList *)infoList ImgStr:(NSString *)imgStr;
-(void)scrollToPage:(NSInteger)index;

-(void)startAutoPlayWithInterval:(NSTimeInterval)interval;
@end
