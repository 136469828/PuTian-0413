//
//  MyWebButton.h
//  MyTest
//
//  Created by guofeng on 13-7-11.
//
//

#import <UIKit/UIKit.h>

@interface MyWebButton : UIButton

/** 是否淡入 */
@property (nonatomic,assign) BOOL isFadeIn;

/** 加载网络图片 */
-(void)setImageWithUrl:(NSString *)urlString callback:(void (^)(BOOL succeed))callback;
/** 加载网络图片 */
-(void)setBackgroundImageWithUrl:(NSString *)urlString callback:(void (^)(BOOL))callback;

@end
