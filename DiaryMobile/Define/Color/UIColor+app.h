//
//  UIColor+app.h
//  BKMobile
//
//  Created by Guibin on 15/1/23.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//
/**
 *  这里设置app 所有UI 渲染颜色变化
 */

#import <UIKit/UIKit.h>
#import "NSString+UIColor.h"
#define RGB(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]

@interface UIColor (AppUIColor)

//取随机色
+ (UIColor *)randomColor;

@end

@interface UIImage (BImage_Color)

/**
 *  根据颜色和尺寸返回一个image
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
