//
//  Common.h
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

/** 屏幕尺寸 */
+(ScreenSizeType)screenSizeType;
/** 当前屏幕宽对320像素的比值 */
+(float)ratioWidthScreenWidthTo320;
/** 320像素对当前屏幕宽的比值 */
+(float)ratioWith320ToScreenWidth;
/** 当前屏幕高对480像素的比值 */
+(float)ratioWithScreenHeightTo480;
/** 480像素对当前屏幕高的比值 */
+(float)ratioWith480ToScreenHeight;

+(float)marginTop;

/** 获取系统版本号 */
+(float)systemVersion;
/** 获取app版本号 */
+(NSString *)appVersion;

/** 获取程序Documents目录 */
+(NSString *)getAppStartupPath;
/** 程序主目录 */
+(NSString *)mainDirectory;
/** 自动缓存目录(ASIHttpRequest) */
+(NSString *)aCacheDirectory;
/** 手动缓存目录 */
+(NSString *)mCacheDirectory;

/** 取文件大小 */
+(long long) fileSizeAtPath:(NSString*)filePath;
/** 获取目录大小 */
+(long long) folderSizeAtPath: (const char*)folderPath;

+(NSString *)encodeURL:(NSString *)urlString;

/** 判断是否有网络连接标识 */
+(BOOL)hasNetworkFlags;



/** 数组排序(NSNumber),isASC(YES:升序;NO:倒序;) */
+(void)sortList:(NSMutableArray *)list isASC:(BOOL)isASC;

@end
