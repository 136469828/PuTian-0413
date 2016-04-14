//
//  EnumList.h
//  PuTian
//
//  Created by guofeng on 15/9/4.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 屏幕尺寸 */
typedef NS_ENUM(NSInteger, ScreenSizeType)
{
    /** 3.5inch */
    ScreenSizeType3_5=1,
    /** 4.0inch */
    ScreenSizeType4_0=2,
    /** 4.7inch */
    ScreenSizeType4_7=3,
    /** 5.5inch */
    ScreenSizeType5_5=4,
};

/** PullToRefreshTableView加载方式 */
typedef NS_ENUM(NSInteger, SlideType)
{
    /** 首次加载 */
    SlideTypeNormal=0,
    /** 手指下拉刷新 */
    SlideTypeDown=1,
    /** 手指向上滑动加载 */
    SlideTypeUp=2,
};

/** 广告栏类型 */
typedef NS_ENUM(NSInteger, AdvertType)
{
    /** 首页广告 */
    AdvertTypeIndex=1201,
    /** 商家优惠广告 */
    AdvertTypeCoupons=1202,
    /** 莆田视频广告 */
    AdvertTypeVideo=1203,
};

/** 首页模块类别 */
typedef NS_ENUM(NSInteger, IndexModelType)
{
    /** 商家优惠 */
    IndexModelTypeYouhui=1,
    /** 妈祖故乡 */
    IndexModelTypeMazu=2,
    /** 莆田视频 */
    IndexModelTypeShipin=3,
    /** 莆田娱乐 */
    IndexModelTypeYule=4,
    /** 沃币中心 */
    IndexModelTypeWobi=6,
    /** 本地资讯 */
    IndexModelTypeZixun=7,
    /** 本地资讯 */
    IndexModelTypeWobiDuanHuan=14,
    /** 莆田美食 */
    IndexModelTypeMeishi=15,

};

/** 评论按钮类型 */
typedef NS_ENUM(NSInteger, CommentButtonType)
{
    /** 好评 */
    CommentButtonTypeGood=1,
    /** 中评 */
    CommentButtonTypeMiddle=2,
    /** 差评 */
    CommentButtonTypeBad=3,
};

@interface EnumList : NSObject

@end
