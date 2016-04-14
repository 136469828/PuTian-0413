//
//  PullToRefreshTableView.m
//
//  Created by DBY on 14-8-5.
//  Copyright (c) 2014年 MXZ. All rights reserved.
//

#import "PullToRefreshTableView.h"

#import <QuartzCore/QuartzCore.h>

/**
 *
 * StateView 顶部和底部状态视图
 *
 **/

@implementation StateView

@synthesize indicatorView;
@synthesize arrowView;
@synthesize stateLabel;
@synthesize timeLabel;
@synthesize viewType;
@synthesize currentState;

- (id)initWithFrame:(CGRect)frame viewType:(int)type{
    CGFloat width = frame.size.width;
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, k_STATE_VIEW_HEIGHT)];
    
    if (self) {
        //  设置当前视图类型
        viewType = type == k_VIEW_TYPE_HEADER ? k_VIEW_TYPE_HEADER : k_VIEW_TYPE_FOOTER;
        self.backgroundColor = [UIColor clearColor];
        
        //  初始化加载指示器（菊花圈）  
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(80, (k_STATE_VIEW_HEIGHT - 20) / 2, 20, 20)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        indicatorView.hidesWhenStopped = YES;
        [self addSubview:indicatorView];
        
        //  初始化箭头视图
        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(80, (k_STATE_VIEW_HEIGHT - 32) / 2, 13, 32)];
        NSString * imageNamed = type == k_VIEW_TYPE_HEADER ? @"refresh_arrow_down.png" : @"refresh_arrow_up.png";
        arrowView.image = [UIImage imageNamed:imageNamed];
        [self addSubview:arrowView];
        
//        //  初始化状态提示文本
//        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
//        stateLabel.font = [UIFont systemFontOfSize:12.0f];
//        stateLabel.backgroundColor = [UIColor clearColor];
//        stateLabel.textAlignment = NSTextAlignmentCenter;
//        stateLabel.text = type == k_VIEW_TYPE_HEADER ? @"下拉可以刷新" : @"上拉加载更多";
//        [self addSubview:stateLabel];
//        
//        //  初始化更新时间提示文本
//        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, width, k_STATE_VIEW_HEIGHT - 20)];
//        timeLabel.font = [UIFont systemFontOfSize:12.0f];
//        timeLabel.backgroundColor = [UIColor clearColor];
//        timeLabel.textAlignment = NSTextAlignmentCenter;
//        timeLabel.text = @"-----";
//        [self addSubview:timeLabel];
        
        //  初始化状态提示文本
        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (k_STATE_VIEW_HEIGHT-20)/2.0, width, 20)];
        stateLabel.font = [UIFont systemFontOfSize:12.0f];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.text = type == k_VIEW_TYPE_HEADER ? @"下拉可以刷新" : @"上拉加载更多";
        [self addSubview:stateLabel];
    }
    return self;
}

- (void)changeState:(int)state{
    [indicatorView stopAnimating];
    arrowView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    switch (state) {
        case k_PULL_STATE_NORMAL:
            currentState = k_PULL_STATE_NORMAL;
            stateLabel.text = viewType == k_VIEW_TYPE_HEADER ? @"下拉可以刷新.." : @"上拉加载更多..";
            //  旋转箭头
            arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            break;
        case k_PULL_STATE_DOWN:
            currentState = k_PULL_STATE_DOWN;
            stateLabel.text = @"松开立即刷新..";
            arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;
            
        case k_PULL_STATE_UP:
            currentState = k_PULL_STATE_UP;
            stateLabel.text = @"松开加载更多..";
            arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;
            
        case k_PULL_STATE_LOAD:
            currentState = k_PULL_STATE_LOAD;
            stateLabel.text = viewType == k_VIEW_TYPE_HEADER ? @"正在刷新..." : @"正在加载...";
            [indicatorView startAnimating];
            arrowView.hidden = YES;
            break;
            
        case k_PULL_STATE_END:
            currentState = k_PULL_STATE_END;
            stateLabel.text = viewType == k_VIEW_TYPE_HEADER ? stateLabel.text : @"已经到最底部了..";
            arrowView.hidden = YES;
            break;
            
        default:
            currentState = k_PULL_STATE_NORMAL;
            stateLabel.text = viewType == k_VIEW_TYPE_HEADER ? @"下拉可以刷新.." : @"上拉加载更多..";
            arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            break;
    }
    [UIView commitAnimations];
}

- (void)updateTimeLabel
{
    if(timeLabel)
    {
        NSDate * date = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterFullStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        timeLabel.text = [NSString stringWithFormat:@"更新于 %@", [formatter stringFromDate:date]];
    }
}

@end


/**
 *
 * PullToRefreshTableView 拖动刷新/加载 表格视图
 *
 **/


@implementation PullToRefreshTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        headerView = [[StateView alloc] initWithFrame:CGRectMake(0, -40, frame.size.width, frame.size.height) viewType:k_VIEW_TYPE_HEADER];
        footerView = [[StateView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) viewType:k_VIEW_TYPE_FOOTER];
        [self addSubview:headerView];
        [self setTableFooterView:footerView];
    }
    return self;
}

-(void)showLoading
{
    //[footerView changeState:k_PULL_STATE_LOAD];
    [UIView animateWithDuration:0.3 animations:^
    {
        self.contentOffset=CGPointMake(0, -headerView.height);
    }];
    [headerView changeState:k_PULL_STATE_LOAD];
}
-(void)didAllLoaded
{
    self.contentInset = UIEdgeInsetsZero;
    [headerView changeState:k_PULL_STATE_NORMAL];
    [footerView changeState:k_PULL_STATE_END];
    
    //  更新时间提示文本
    [headerView updateTimeLabel];
    [footerView updateTimeLabel];
    
    if(self.contentOffset.y<0)
    {
        [UIView animateWithDuration:0.3 animations:^
        {
            self.contentOffset=CGPointMake(0, 0);
        }];
    }
}
-(void)restoreState
{
    self.contentInset = UIEdgeInsetsZero;
    [headerView changeState:k_PULL_STATE_NORMAL];
    [footerView changeState:k_PULL_STATE_NORMAL];
    
    //  更新时间提示文本
    [headerView updateTimeLabel];
    [footerView updateTimeLabel];
    
    if(self.contentOffset.y<0)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             self.contentOffset=CGPointMake(0, 0);
         }];
    }
}
-(void)refresh
{
    [UIView animateWithDuration:0.3 animations:^
    {
        [self setContentOffset:CGPointMake(0, -k_STATE_VIEW_HEIGHT-16)];
    } completion:^(BOOL finished)
    {
        [self.delegate scrollViewDidEndDragging:nil willDecelerate:NO];
    }];
}

- (void)tableViewDidDragging{
    CGFloat offsetY = self.contentOffset.y;
    //  判断是否正在加载
    if (headerView.currentState == k_PULL_STATE_LOAD ||
        footerView.currentState == k_PULL_STATE_LOAD) {
        return;
    }
    //  改变“下拉可以刷新”视图的文字提示
    if (offsetY < -k_STATE_VIEW_HEIGHT - 10) {
        [headerView changeState:k_PULL_STATE_DOWN];
    } else {
        [headerView changeState:k_PULL_STATE_NORMAL];
    }
    //  判断数据是否已全部加载
    if (footerView.currentState == k_PULL_STATE_END) {
        return;
    }
    //  计算表内容大小与窗体大小的实际差距
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    //  改变“上拖加载更多”视图的文字提示
    if (offsetY > differenceY + k_STATE_VIEW_HEIGHT / 3 * 2) {
        [footerView changeState:k_PULL_STATE_UP];
    } else {
        [footerView changeState:k_PULL_STATE_NORMAL];
    }
}

- (int)tableViewDidEndDragging{
    CGFloat offsetY = self.contentOffset.y;
    //  判断是否正在加载数据
    if (headerView.currentState == k_PULL_STATE_LOAD ||
        footerView.currentState == k_PULL_STATE_LOAD) {
        return k_RETURN_DO_NOTHING;
    }
    //  改变“下拉可以刷新”视图的文字及箭头提示
    if (offsetY < -k_STATE_VIEW_HEIGHT - 10) {
        [headerView changeState:k_PULL_STATE_LOAD];
        self.contentInset = UIEdgeInsetsMake(k_STATE_VIEW_HEIGHT, 0, 0, 0);
        return k_RETURN_REFRESH;
    }
    //  改变“上拉加载更多”视图的文字及箭头提示
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    if (footerView.currentState != k_PULL_STATE_END && 
        offsetY > differenceY + k_STATE_VIEW_HEIGHT / 3 * 2) {
        [footerView changeState:k_PULL_STATE_LOAD];
        return k_RETURN_LOADMORE;
    } 
    return k_RETURN_DO_NOTHING;
}

- (void)reloadData:(BOOL)dataIsAllLoaded{
    [self reloadData];
    self.contentInset = UIEdgeInsetsZero;
    [headerView changeState:k_PULL_STATE_NORMAL];
    //  如果数据已全部加载，则禁用“上拖加载”
    if (dataIsAllLoaded) {
        [footerView changeState:k_PULL_STATE_END];
    } else {
        [footerView changeState:k_PULL_STATE_NORMAL];
    }
    //  更新时间提示文本
    [headerView updateTimeLabel];
    [footerView updateTimeLabel];
}

@end