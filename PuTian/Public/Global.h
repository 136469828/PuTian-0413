//
//  Global.h
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IsIOS7 [[UIDevice currentDevice].systemVersion floatValue]>=7.0

//屏幕scale
#define kScreenScale [UIScreen mainScreen].scale
//屏幕尺寸
#define kScreenSize [UIScreen mainScreen].bounds.size
//是否为4英寸屏
#define Is4Inch kScreenSize.height>480?YES:NO
//状态栏高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
//3.5英寸屏幕高度
#define kScreenHeight3_5 480.0
#define kScreenHeight4_0 568.0
#define kScreenHeight4_7 667.0
#define kScreenHeight5_5 736.0

//#define kNavigationBarBackgroundColor [UIColor colorWithRed:254.0/255 green:154.0/255 blue:108.0/255 alpha:1.0]
#define kNavigationBarBackgroundColor [UIColor colorWithRed:237.0/255 green:109.0/255 blue:0 alpha:1.0]
#define kNavigationBarBackgroundColorWithAlpha(Alpha) [UIColor colorWithRed:237.0/255 green:109.0/255 blue:0 alpha:Alpha]



//#define URL_Background @"http://192.168.1.4:81"
//#define URL_Server @"http://192.168.1.4:81/api.php"
//#define URL_Article @"http://192.168.1.4:81/index.php?g=portal&m=index&a=article&id=%d"
#define URL_Background @"http://putian.meidp.com"
#define URL_Server @"http://putian.meidp.com/api.php"
#define URL_Article @"http://putian.meidp.com/index.php?g=portal&m=index&a=article&id=%d"

//#define URL_Background @"http://putian.meidp.com"
//#define URL_Server @"http://putian.meidp.com/api.php"
//#define URL_Article @"http://putian.meidp.com/index.php?g=portal&m=index&a=article&id=%d"

#define kHttpRequestTimeoutSeconds 10.0

#define kHttpRequestDataPageCountDefault 20



#define kNotificationNameNavigationControllerDidShowViewController @"kNotificationNameNavigationControllerDidShowViewController"

//广告栏通知
#define kNotificationNameAdvertInfoList @"kNotificationNameAdvertInfoList"

//首页模块列表通知
#define kNotificationNameIndexModelList @"kNotificationNameIndexModelList"

//商家优惠列表通知
#define kNotificationNameOffPriceInfoList @"kNotificationNameOffPriceInfoList"
//商家优惠详情通知
#define kNotificationNameOffPriceDetail @"kNotificationNameOffPriceDetail"
//其他优惠通知
#define kNotificationNameUnionOffPriceInfoList @"kNotificationNameUnionOffPriceInfoList"
//店铺信息通知
#define kNotificationNameShopInfo @"kNotificationNameShopInfo"
//优惠券下载通知
#define kNotificationNameCouponsDownload @"kNotificationNameCouponsDownload"


//妈祖故乡列表通知
#define kNotificationNameMazuInfoList @"kNotificationNameMazuInfoList"
//本地资讯列表通知
#define kNotificationNameLocalInfoList @"kNotificationNameLocalInfoList"
//莆田美食通知
#define kNotificationNameFood @"kNotificationNameFoodInfoList"
//微店通知
#define kNotificationNameMiniShop @"kNotificationNameMiniShopInfoList"




//莆田娱乐频道列表通知
#define kNotificationNameRecreationChannelList @"kNotificationNameRecreationChannelList"
//莆田娱乐列表通知
#define kNotificationNameRecreationInfoList @"kNotificationNameRecreationInfoList"
#define kNotificationNameArticleInfo @"kNotificationNameArticleInfo"

//莆田视频列表通知(焦点视频，随机视频)
#define kNotificationNameHotVideoInfoList @"kNotificationNameHotVideoInfoList"
//莆田视频列表通知(热门频道)
#define kNotificationNameVideoChannelInfoList @"kNotificationNameVideoChannelInfoList"
//莆田视频列表通知
#define kNotificationNameVideoInfoList @"kNotificationNameVideoInfoList"
//莆田视频通知
#define kNotificationNameVideoInfo @"kNotificationNameVideoInfo"

//沃币详情列表通知
#define kNotificationNameWobiInfoList @"kNotificationNameWobiInfoList"
//沃币商品列表通知
#define kNotificationNameWobiShangPingInfoList @"kNotificationNameWobiShangPingInfoList"

//我的优惠券列表通知
#define kNotificationNameCouponsList @"kNotificationNameCouponsList"

//广场列表通知
#define kNotificationNameSquareInfoList @"kNotificationNameSquareInfoList"

//用户中心通知
#define kNotificationNameUserInfo @"kNotificationNameUserInfo"
//评论列表通知
#define kNotificationNameCommentInfoList @"kNotificationNameCommentInfoList"
//收藏列表通知
#define kNotificationNameCollectionInfoList @"kNotificationNameCollectionInfoList"

//通知类型key
#define kNotificationTypeKey @"kNotificationTypeKey"
//通知内容key
#define kNotificationContentKey @"kNotificationContentKey"
//手指滑动方向
#define kNotificationSlideTypeKey @"NotificationSlideTypeKey"
//是否有网络标识
#define kNotificationNetworkFlagsKey @"NotificationNetworkFlagsKey"
//是否成功
#define kNotificationSucceedKey @"NotificationSucceedKey"
//返回消息
#define kNotificationMessageKey @"NotificationMessageKey"
//当前查询的页码
#define kNotificationPageIndexKey @"NotificationPageIndexKey"



/** NSUserDefaults */
//版本更新提示时间
#define kUserDefaultsKeyUpgradeHintDate @"UpgradeHintDate"
//程序最后一次进入后台的时间
#define kUserDefaultsKeyAppEnterBackgroundDate @"UserDefaultsKeyAppEnterBackgroundDate"
//最后一次登录的时间
#define kUserDefaultsKeyLastLoginDate @"UserDefaultsKeyLastLoginDate"
//是否已经登录
#define kUserDefaultsKeyIsLogin @"UserDefaultsKeyIsLogin"
//登录类型
#define kUserDefaultsKeyLoginType @"UserDefaultsKeyLoginType"
//用户类型
#define kUserDefaultsKeyUserType @"UserDefaultsKeyUserType"
//用户id
#define kUserDefaultsKeyUserID @"UserDefaultsKeyUserID"
//登录账号
#define kUserDefaultsKeyLoginId @"UserDefaultsKeyLoginId"
//登录密码
#define kUserDefaultsKeyPwd @"UserDefaultsKeyPwd"
#define kUserDefaultsKeyEncryptPwd @"UserDefaultsKeyEncryptPwd"
//昵称
#define kUserDefaultsKeyNickName @"UserDefaultsKeyNickName"
//性别(0:女;1:男;)
#define kUserDefaultsKeyGender @"UserDefaultsKeyGender"
//头像url
#define kUserDefaultsKeyPortraitUrl @"UserDefaultsKeyPortraitUrl"
//***** end *****


@interface Global : NSObject

@end
