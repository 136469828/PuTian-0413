//
//  MyWebImage.h
//  CollocationIPAD
//
//  Created by guofeng on 13-7-17.
//
//

#import <UIKit/UIKit.h>

@interface MyWebImage : UIImageView

/** 是否淡入 */
@property (nonatomic,assign) BOOL isFadeIn;

/** 加载网络图片 */
-(void)setImageWithUrl:(NSString *)urlString callback:(void (^)(BOOL succeed))callback;

@end
