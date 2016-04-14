//
//  tool.h
//  tool
//
//  Created by JCong on 15/12/24.
//  Copyright © 2015年 JCK. All rights reserved.
//

#ifndef tool_h
#define tool_h

// App
#define APP_VERSION                 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


// System Version
#define SYSTEM_VERSION                             ([[[UIDevice currentDevice] systemVersion] floatValue])
#define SYSTEM_VERSION_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_HIGHER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_EQUAL_TO_OR_HIGHER_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LOWER_THAN(v)               ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_EQUAL_TO_OR_LOWER_THAN(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


// Color
#define RGB(r,g,b)                  [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:1.f]
#define RGBA(r,g,b,a)               [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]
#define RGB_HEX(hex)                RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),1.f)
#define RGBA_HEX(hex,a)             RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),a)

#define COLOR_LIGHT_BLUE            RGB_HEX(0x7f8b97)
#define COLOR_DEEP_BLUE             RGB_HEX(0x00b3d6)


// Language
#define CURRENT_LANGUAGE            ([[NSLocale preferredLanguages] objectAtIndex:0])
#define IS_LANGUAGE(l)              [CURRENT_LANGUAGE hasPrefix:l]
#define IS_LANGUAGE_EN              IS_LANGUAGE(@"en")


// Font
#define FONT_SOFIA_MEDIUM(s)        [UIFont fontWithName:@"SofiaProSoft-Medium" size:s]
#define FONT_SOFIA_SOFT(s)          [UIFont fontWithName:@"SofiaProSoft" size:s]


// Screen
#define SCREEN_SIZE                 [[UIScreen mainScreen] bounds].size
#define SCREEN_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT               [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


// GCD
#define GCD_GLOBAL(block)           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCD_MAIN(block)             dispatch_async(dispatch_get_main_queue(), block)


#endif /* tool_h */
