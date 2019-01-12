/**
 -  UserHelper.h
 -  BKMobile
 -  Created by HY on 17/1/9.
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

//设置kmall缓存，判断用户登录状态，同步登录或退出kmall网站，shopping页面用到
+ (NSString *)setKmallWebCookies;


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


/**
 数据统计，跟踪用户信息

 @param eventType    跟踪的事件类型，事件在BKAnalyticsConst中定义
 @param dicExtraData 可以附加任何信息，以键值对的形式，该参数也可以为空
 */
+ (void)trackingUserDataForType:(NSString *)eventType
                   dicExtraData:(NSDictionary *)dicExtraData;


@end
