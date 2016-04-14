//
//  AppDelegate.m
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "ViewController.h"
#import "SquareViewController.h"
#import "ServiceViewController.h"
#import "UserViewController.h"

#import "ASIHttpRequest.h"
#import "ASIDownloadCache.h"

#import "PublicityImageInfo.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

#import "WeiboSDK.h"


#import "APService.h"



#include <sys/xattr.h>

@interface AppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic,strong) ViewController *indexVC;
@property (nonatomic,strong) BaseNavigationController *navIndex;

@property (nonatomic,strong) SquareViewController *squareVC;
@property (nonatomic,strong) BaseNavigationController *navSquare;

@property (nonatomic,strong) ServiceViewController *serviceVC;
@property (nonatomic,strong) BaseNavigationController *navService;

@property (nonatomic,strong) UserViewController *userVC;
@property (nonatomic,strong) BaseNavigationController *navUser;

@property (nonatomic,strong) UITabBarController *tabbar;

@property (nonatomic,weak) UIViewController *currentVC;

@property (nonatomic,strong) PublicityImageInfo *publicityImageInfo;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self createDirectory];
    
    //设置缓存
    ASIDownloadCache *cache=[ASIDownloadCache sharedCache];
    [cache setDefaultCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [cache setStoragePath:[Common aCacheDirectory]];
    
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    
    [[UINavigationBar appearance] lt_setBackgroundColor:kNavigationBarBackgroundColor];
    NSDictionary *attr=[[NSDictionary alloc] initWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attr];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    _indexVC=[[ViewController alloc] init];
    _navIndex=[[BaseNavigationController alloc] initWithRootViewController:_indexVC];
    
    _squareVC=[[SquareViewController alloc] init];
    _navSquare=[[BaseNavigationController alloc] initWithRootViewController:_squareVC];
    
    _serviceVC=[[ServiceViewController alloc] init];
    _navService=[[BaseNavigationController alloc] initWithRootViewController:_serviceVC];
    
    _userVC=[[UserViewController alloc] init];
    [_userVC appDidFinishLaunching];
    _navUser=[[BaseNavigationController alloc] initWithRootViewController:_userVC];
    
    NSArray *navs=[NSArray arrayWithObjects:_navIndex,_navSquare,_navService,_navUser, nil];
    _tabbar=[[UITabBarController alloc] init];
    _tabbar.delegate=self;
    _tabbar.viewControllers=navs;
    _tabbar.tabBar.tintColor=[UIColor orangeColor];
    
    _currentVC=_navIndex;
    
    _publicityImageInfo=[[PublicityImageInfo alloc] init];
    
    self.window.backgroundColor=[UIColor whiteColor];
    self.window.rootViewController=_tabbar;
    [self.window makeKeyAndVisible];
    
    
    
    UIImage *publicity=nil;
    NSData *publicityData=_publicityImageInfo.imageData;
    if(publicityData)
    {
        publicity=[[UIImage alloc] initWithData:publicityData];
    }
    else
    {
        NSString *defaultPublicityPath=[[NSBundle mainBundle] pathForResource:@"publicity@2x" ofType:@"png"];
        publicity=[[UIImage alloc] initWithContentsOfFile:defaultPublicityPath];
    }
    if(publicity)
    {
        UIImageView *ivPublicity=[[UIImageView alloc] initWithFrame:self.window.bounds];
        ivPublicity.contentMode=UIViewContentModeScaleAspectFill;
        ivPublicity.userInteractionEnabled=YES;
        ivPublicity.image=publicity;
        [self.window addSubview:ivPublicity];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^
                       {
                           sleep(3);
                           dispatch_sync(dispatch_get_main_queue(), ^
                                         {
                                             [UIView animateWithDuration:1.0 animations:^
                                              {
                                                  ivPublicity.alpha=0;
                                                  ivPublicity.transform=CGAffineTransformScale(ivPublicity.transform, 2.0, 2.0);
                                              } completion:^(BOOL finished)
                                              {
                                                  [ivPublicity removeFromSuperview];
                                              }];
                                         });
                       });
    }
    [_publicityImageInfo loadData];

    
    /**
     *  配置ShareSDK
     *
     */
    
    
    
    /*share sdk
     */
    
    [ShareSDK registerApp:@"edecebf0e95e"
          activePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformTypeWechat)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             case SSDKPlatformSubTypeQZone:
                             case SSDKPlatformSubTypeQQFriend:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"365337373"
                                                appSecret:@"611d10fe22486c9023007e07ba7995ba"
                                              redirectUri:@"http://www.baidu.com"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeQQ:
                  case SSDKPlatformSubTypeQZone:
                  case SSDKPlatformSubTypeQQFriend:
                      //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupQQByAppId:@"1104927797" appKey:@"IMpkBHm11RKtmefv" authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wxe7582963ed8cc4ab" appSecret:@"6106da499756cdd4a98972082335a0c3"];
                      break;
                  default:
                      break;
              }
              
          }];
    
    
       //极光推送
    
    
    
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    
    
    return YES;
}

-(void)createDirectory
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[Common mainDirectory]])
    {
        [fileManager createDirectoryAtPath:[Common mainDirectory] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:[Common aCacheDirectory]])
    {
        [fileManager createDirectoryAtPath:[Common aCacheDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:[Common mCacheDirectory]])
    {
        [fileManager createDirectoryAtPath:[Common mCacheDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSURL *url=[NSURL fileURLWithPath:[Common mainDirectory] isDirectory:YES];
    [self addSkipBackupAttributeToItemAtURL:url];
}
-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSDate *date=[[NSDate alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kUserDefaultsKeyAppEnterBackgroundDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    BOOL isRefreshIndexVC=NO;
    NSDate *date=[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyAppEnterBackgroundDate];
    if(date)
    {
        NSDate *now=[[NSDate alloc] init];
        NSTimeInterval interval=[now timeIntervalSinceDate:date];
        if(interval>=3600)
        {
            [_userVC refresh];
            
            if(interval>=3600*24)
            {
                isRefreshIndexVC=YES;
                
                [_indexVC reloadWhenLongInterval];
            }
        }
    }
    
    if(_navIndex==_currentVC && !isRefreshIndexVC)
        [_indexVC reloadWhenNoData];
    
    [_publicityImageInfo loadData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(viewController==_navIndex)
    {
        
    }
    else if(viewController==_navSquare)
    {
        if(_currentVC!=viewController)
            [_squareVC refresh];
    }
    else if(viewController==_navService)
    {
        if(_currentVC!=viewController)
            [_serviceVC loadWebView];
    }
    else if(viewController==_navUser)
    {
        if(_currentVC!=viewController)
            [_userVC refresh];
    }
    _currentVC=viewController;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hzwl.PuTian" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PuTian" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PuTian.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
