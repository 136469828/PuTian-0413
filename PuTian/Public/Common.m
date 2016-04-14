//
//  Common.m
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "Common.h"
#import "Reachability.h"

#include <sys/stat.h>
#include <dirent.h>

@implementation Common

/** 屏幕尺寸 */
+(ScreenSizeType)screenSizeType
{
    static NSInteger gScreenSizeType=-1;
    
    if(gScreenSizeType<0)
    {
        float width=[UIScreen mainScreen].bounds.size.width;
        float height=[UIScreen mainScreen].bounds.size.height;
        if(width==320 && height==480)
            gScreenSizeType=ScreenSizeType3_5;
        else if(width==320 && height==568)
            gScreenSizeType=ScreenSizeType4_0;
        else if(width==375 && height==667)
            gScreenSizeType=ScreenSizeType4_7;
        else if(width==414 && height==736)
            gScreenSizeType=ScreenSizeType5_5;
    }
    
    return gScreenSizeType;
}
/** 当前屏幕宽对320像素的比值 */
+(float)ratioWidthScreenWidthTo320
{
    return kScreenSize.width/320.0;
}
/** 320像素对当前屏幕宽的比值 */
+(float)ratioWith320ToScreenWidth
{
    return 320.0/kScreenSize.width;
}
/** 当前屏幕高对480像素的比值 */
+(float)ratioWithScreenHeightTo480
{
    return kScreenSize.height/480.0;
}
/** 480像素对当前屏幕高的比值 */
+(float)ratioWith480ToScreenHeight
{
    return 480.0/kScreenSize.height;
}

+(float)marginTop
{
    static float gMarginTop=-1;
    
    if(gMarginTop<0)
    {
        float version=[Common systemVersion];
        if(version>=7.0)
            gMarginTop=kStatusBarHeight;
        else
            gMarginTop=0;
    }
    
    return gMarginTop;
}

/** 获取系统版本号 */
+(float)systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
/** 获取app版本号 */
+(NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/** 获取程序Documents目录 */
+(NSString *)getAppStartupPath
{
    static NSString *gAppStartupPath=nil;
    if(!gAppStartupPath)
    {
        gAppStartupPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    return gAppStartupPath;
}
/** 程序主目录 */
+(NSString *)mainDirectory
{
    static NSString *gMainDirectory=nil;
    if(!gMainDirectory)
    {
        gMainDirectory=[[NSString alloc] initWithFormat:@"%@/data",[Common getAppStartupPath]];
    }
    return gMainDirectory;
}
/** 自动缓存目录(ASIHttpRequest) */
+(NSString *)aCacheDirectory
{
    static NSString *gACacheDirectory=nil;
    if(!gACacheDirectory)
    {
        gACacheDirectory=[[NSString alloc] initWithFormat:@"%@/cache",[Common mainDirectory]];
    }
    return gACacheDirectory;
}
/** 手动缓存目录 */
+(NSString *)mCacheDirectory
{
    static NSString *gMCacheDirectory=nil;
    if(!gMCacheDirectory)
    {
        gMCacheDirectory=[[NSString alloc] initWithFormat:@"%@/mcache",[Common mainDirectory]];
    }
    return gMCacheDirectory;
}

/** 取文件大小 */
+(long long) fileSizeAtPath:(NSString*)filePath
{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0)
    {
        return st.st_size;
    }
    return 0;
}
/** 获取目录大小 */
+(long long) folderSizeAtPath: (const char*)folderPath
{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL)
    {
        if (child->d_type == DT_DIR &&
            ((child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
             (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
             )) continue;
        
        NSInteger folderPathLength = strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}

+(NSString *)encodeURL:(NSString *)urlString
{
    NSString* escapedUrlString= (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)urlString, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
    escapedUrlString = [escapedUrlString stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    return escapedUrlString;
}

/** 判断是否有网络连接标识 */
+(BOOL)hasNetworkFlags
{
    return [Reachability hasNetworkFlags];
}



/** 数组排序(NSNumber),isASC(YES:升序;NO:倒序;) */
+(void)sortList:(NSMutableArray *)list isASC:(BOOL)isASC
{
    if(list==nil || list.count==0)return;
    if(![list[0] isKindOfClass:[NSNumber class]])return;
    
    if(isASC)
    {
        for(int i=0;i<list.count;i++)
        {
            for(int j=i+1;j<list.count;j++)
            {
                int indexI=[list[i] intValue];
                int indexJ=[list[j] intValue];
                if(indexI>indexJ)
                {
                    NSNumber *tempI=list[i];
                    list[i]=list[j];
                    list[j]=tempI;
                }
            }
        }
    }
    else
    {
        for(int i=0;i<list.count;i++)
        {
            for(int j=i+1;j<list.count;j++)
            {
                int indexI=[list[i] intValue];
                int indexJ=[list[j] intValue];
                if(indexI<indexJ)
                {
                    NSNumber *tempI=list[i];
                    list[i]=list[j];
                    list[j]=tempI;
                }
            }
        }
    }
}

@end
