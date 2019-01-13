/**
 -  Tool.h
 -  BKSDK
 -  Created by ligb on 16/11/11.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  工具类，项目中常用方法汇集，包含
 -  判断一个字符串是否为整形，
 -  判断一个字符串是否为空，
 -  判断字符串中是否含有某个字符串，
 -  将时间戳转化为时间，
 -  获取当前时间，
 -  将十六进制颜色转换为UIColor对象，
 -  特殊字符转意处理，
 -  计算一个label的高度，
 -  定位崩溃页面及调用方法。
 -  根据文件名，获取Caches文件夹下该文件路径
 -  获取一个随机产生的颜色
 -  获取指定文件的大小，返回多少M
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface BKTool : NSObject


/**
 *  @brief  ##传入一个字符串，判断该字符串是否为整形
 *
 *  @param  string  需要判断的字符串
 *  @return Yes代表是，NO代表不是
 */
+ (BOOL)isPureInt:(NSString*)string;


/**
 *  @brief  ##判断字符串是否为空
 *
 *  @param  string 需要判断是否为空的字符串
 *  @return YES表示字符串为空，NO字符串非空
 */
+ (BOOL)isStringBlank:(NSString *)string;


/**
 *  @brief  ##判断字符串中是否含有某个字符串
 *
 *  @param  str         判断是否含有该字符串
 *  @param  originalStr 原始字符串
 *  @return YES表示含有这个字符串，NO表示不含该字符串
 */
+ (BOOL)isHaveString:(NSString *)str inString:(NSString *)originalStr;


/**
 *  @brief  ## 获取url字符串中某个参数所对应的值 比如：url中含有userId=123，传入userId字段，会截取到123
 *
 *  @param  keyString   判断是否含有该字符串
 *  @param  urlString   原始字符串
 *  @return 参数所对应的值，如果没有对应值，返回空字符串
 */
+ (NSString *)getValueStringOfKeyString:(NSString *)keyString formUrlString:(NSString *)urlString;


/**
 *  @brief  ##将时间戳转化为时间
 *
 *  @param  timeStemp 时间戳
 *  @return 返回yyyy-MM-dd格式的时间
 */
+ (NSString *)convertTimestempToDateWithString:(NSString *)timeStemp;


/**
 *  @brief  ##获取当前时间
 *
 *  @param  dateFormat 时间格式，例如@"yyyy-MM-dd" @"MM-dd HH:mm" 等
 *  @return 返回格式化后的当前时间
 */
+ (NSString *)getTodyDate:(NSString *)dateFormat;


/**
 *  @brief  ##将十六进制颜色转换为 UIColor 对象
 *
 *  @param  color 十六进制颜色
 *  @return 返回转换后的UIColor
 */
+ (UIColor*)colorWithHexString:(NSString *)color;


/**
 *  @brief  ##字符转意处理，解决了&，%，等特殊字符传递给后台无法识别的问题
 *
 *  @param  string 传入一个字符串
 *  @return 返回一个转意处理后的字符串
 */
+ (NSString *)stringByUrlEncoding:(NSString *)string;


/**
 *  @brief  ##计算一个label的高度
 *
 *  @param  labelText       label上的所有字符
 *  @param  labelMaxWidth   在屏幕上该label最大宽度
 *  @param  font            该label的文字字号
 *  @param  space           label中文字的行间距
 *  @return 返回label的size
 */
+ (CGSize)mCalculateVerticalSize:(NSString *)labelText labelMaxWidth:(CGFloat)labelMaxWidth font:(UIFont*)font defaultSpace:(CGFloat)space;


/**
 *  @brief  ##从堆栈信息中，定位崩溃的页面方法
 *
 *  @param  callStackSymbols 堆栈信息
 *  @return 返回定位到的崩溃页面，及调用方法
 */
+ (NSString *)getCrashViewMethod:(NSArray<NSString *> *)callStackSymbols;


/**
 *  @brief  ##根据文件名，获取Documents文件夹下该文件路径
 *
 *  @param  fileName 文件名称
 *  @return 返回根据文件名，得到的路径
 */
+ (NSString *)getDocumentsPath:(NSString *)fileName;



/**
 *  @brief  ##根据文件名，获取Library文件夹下文件路径
 *
 *  @param  fileName 文件名称
 *  @return 返回根据文件名，得到的路径
 */
+ (NSString *)getLibraryDirectoryPath:(NSString *)fileName;



/**
 *  @brief  ##获取一个随机颜色
 *
 *  @return 返回一个UIColor
 */
+ (UIColor *)randomColor;//获取随机色


/**
 *  @brief  ##获得设备型号
 *
 *  @return 返回当前设备的型号，例如iphone6
 */
+ (NSString *)getDeviceName;


/**
 统计app的启动次数

 @param appSource app来源 [HK|SZ|TW|EK]
 */
+ (void)mStatisticsAppLaunch:(NSString *)appSource;


/**
 弹出系统的分享视图

 @param vc 弹出分享视图的UIViewController
 @param urlToShare 分享的url
 @param textToShare 分享的文本
 @param imageToShare 分享的图片
 */
+ (void)mSystemShare:(UIViewController *)vc urlToShare:(NSString *)urlToShare textToShare:(NSString *)textToShare imageToShare:(UIImage *)imageToShare;



#pragma mark - 清除指定文件中缓存文件的方法

/**
 获取指定文件的大小，返回M

 @param folderPath 指定的沙盒文件下路径
 @return 遍历文件夹获得文件夹大小，返回多少M
 */
+ (CGFloat)mFolderSizeAtPath:(NSString *)folderPath;


/**
 清空指定路径下的文件夹

 @param filePath 指定的文件路径
 */
+ (void)mClearnDataWithFilePath:(NSString *)filePath;


/**
 获取到当前界面显示的控制器的类名

 @return 当前界面显示的控制器的类名
 */
+ (NSString *)mGetCurrentViewControllerClassName;

@end






