//
//  CommentInfo.h
//  PuTian
//
//  Created by guofeng on 15/10/13.
//  Copyright © 2015年 guofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property (nonatomic,assign) NSInteger commentid;
/** 评论对象id */
@property (nonatomic,assign) NSInteger post_id;
/** 评论对象title */
@property (nonatomic,strong) NSString *post_title;
/** 评论对象展示图url */
@property (nonatomic,strong) NSString *url;
/** 评论用户id */
@property (nonatomic,assign) NSInteger userid;
/** 评论用户昵称 */
@property (nonatomic,strong) NSString *userNickName;
/** 评分 */
@property (nonatomic,assign) NSInteger grade;
/** 评分类型(1:好评;2:中评;3:差评;) */
@property (nonatomic,assign) NSInteger gradeType;
/** 评论内容 */
@property (nonatomic,strong) NSString *comment;
/** 评论日期 */
@property (nonatomic,strong) NSDate *date;

@end
