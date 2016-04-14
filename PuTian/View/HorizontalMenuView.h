//
//  HorizontalMenuView.h
//  MeiXiaoZhu
//
//  Created by DBY on 14-9-10.
//  Copyright (c) 2014年 MXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalMenuView;

@protocol HorizontalMenuDataSource <NSObject>

/** 菜单内容总数量 */
-(NSInteger)horizontalMenuViewColumnCount:(HorizontalMenuView *)menuView;
/** 指定索引的菜单名称 */
-(NSString *)horizontalMenuView:(HorizontalMenuView *)menuView menuAtIndex:(NSInteger)index;

@end

@protocol HorizontalMenuDelegate <NSObject>

/** 菜单选择事件 */
-(void)horizontalMenuView:(HorizontalMenuView *)menuView didSelectMenuAtIndex:(NSInteger)index;

@end

@interface HorizontalMenuView : UIView

@property (nonatomic,assign) id<HorizontalMenuDataSource> dataSource;
@property (nonatomic,assign) id<HorizontalMenuDelegate> delegate;
@property (nonatomic,readonly) NSInteger selectedIndex;
@property (nonatomic,assign) BOOL allowsScroll;
/** 字体大小 */
@property (nonatomic,assign) float fontSize;
/** 菜单字体常规颜色 */
@property (nonatomic,strong) UIColor *normalColor;
/** 菜单字体选中颜色 */
@property (nonatomic,strong) UIColor *selectedColor;
/** 菜单空白宽度 */
@property (nonatomic,assign) float gapWidth;

-(id)initWithFrame:(CGRect)frame isShowTopLine:(BOOL)isShowTopLine isShowBottomLine:(BOOL)isShowBottomLine;
-(void)reloadData;

@end
