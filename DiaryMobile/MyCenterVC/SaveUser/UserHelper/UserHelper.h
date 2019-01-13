/**
 -  UserHelper.h
 -  BKMobile
 -  Created by ligb on 17/1/9.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 -  工具类，有关用户的一些常用公共方法。
 -  清除用户信息
 -  设置网购中账户信息
 -  设置存储拍照图片的路径
 -  统计跟踪用户数据
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UserHelper : NSObject

///清除用户信息
+ (void)mClearUserInfoData;


/**
 本地保存一个拍照图片

 @param image 照片
 @return 返回存储照片的名称
 */
+ (NSString *)saveImagePath:(UIImage *)image;


/**
 获取保存的图片的路径

 @param file 图片的名称
 @return 返回保存的图片路径
 */
+ (NSString *)getImagePath:(NSString *)file;




@end
