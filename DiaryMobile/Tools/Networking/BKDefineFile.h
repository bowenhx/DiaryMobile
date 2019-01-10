/**
 -  BKDefineFile.h
 -  BKSDK
 -  Created by ligb on 16/11/16.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  常用的宏定义，包含
 -  获取当前版本号
 -  获取屏幕宽高
 -  定义了所有屏幕尺寸大小
 -  判断手机设备是ipad或iphone
 -  获取view坐标点
 -  判断当前设备的系统版本
 -  定义了设置RGB颜色
 -  定义了弱引用/强引用
 -  只在Debug模式下打印日志等宏定义
 */


#ifndef DefineFile_h
#define DefineFile_h

//系统定义
#define APP_DELEGATE     (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define APP_VERSION      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//获取屏幕宽度与高度
#define kSCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define kSCREEN_SIZE     [UIScreen mainScreen].bounds.size
#define kSCREEN_BOUNDS   [UIScreen mainScreen].bounds



//定义屏幕尺寸
//定义屏幕尺寸
#define IPHONE4         ([UIScreen mainScreen].bounds.size.height == 480)
#define IPHONE5         ([UIScreen mainScreen].bounds.size.height == 568)
#define IPHONE6         ([UIScreen mainScreen].bounds.size.height == 667)
#define IPHONE6P        ([UIScreen mainScreen].bounds.size.height == 736)
#define IPHONEX         ([UIScreen mainScreen].bounds.size.height == 812)
#define kBOTTOM_TABBAR_HEIGHT   (([UIScreen mainScreen].bounds.size.height == 812) ? 83 : 49)
#define kNAV_BAR_HEIGHT         (([UIScreen mainScreen].bounds.size.height == 812) ? 88 : 64)
#define kIPHONEX_BottomAddHeight (([UIScreen mainScreen].bounds.size.height == 812) ? 34 : 0) //iphoneX的底部增加了34pt的高度

//判断iPad，iPhone
#define kIS_IPAD         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kIS_IPHONE       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


//判断当前的iPhone系统版本
#define kiOS8            ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define kiOS9            ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
#define kiOS10           ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
#define kiOS11           ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)

//设置RGB颜色/设置RGBA颜色
#define kRGB(r, g, b)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRGBA(r, g, b, a)   [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

//弱引用/强引用
#define WEAKSELF(type)          try{}@finally{} __weak typeof(type) type##Weak = type;
#define STRONGSELF(type)        __strong typeof(type) type = weak##type;

//self 的弱引用
#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;

//NSString 类型
#define string(str)  [NSString stringWithFormat:@"%ld",(long)str]

//int 类型转换 NSString 类型
#define kStringInt(i)       [NSString stringWithFormat:@"%ld", (long)i]
#define kString_Int(str, i)  [NSString stringWithFormat:@"%@%ld", str, (long)i]

//string 拼接字符串
#define kString_Str(str1, str2)  [NSString stringWithFormat:@"%@%@", str1, str2]

//打印日志
#ifdef  DEBUG
#define DLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DLog(...)
#endif

#endif /* DefineFile_h */

