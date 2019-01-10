/**
 -  SaveData.h
 -  BKSDK
 -  Created by HY on 16/11/22.
 -  Copyright © 2016年 HY. All rights reserved.
 -  使用NSUserDefaults本地存取NSString，NSUInteger，BOOL，NSArray，NSDictionary。
 -  使用writeToFile方法，对NSArray，NSDictionary，NSData进行文件读写操作。
 -  在本地Documents下创建文件夹，缓存根据url协议拦截到的图片，进行读写操作
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SAVE_IMAGE_CACHE_FOLDER     @"AdImageCacheFolder"          //定义缓存广告图片的文件夹名称
#define kCacheUpImagePhotoKey       @"UpImages"                    //上传照片缓存文件夹名key


@interface BKSaveData : NSObject


/**
 *  @brief      ##使用NSUserDefaults，本地存储一个字符串
 *
 *  @param      string  需要保存的字符串
 *  @param      key     保存字符串时候，指定的唯一值
 *  @warning    对相同的Key赋值,等于一次覆盖，要保证Key的唯一性
 */
+(void)setString:(NSString *)string key:(NSString *)key;


/**
 *  @brief  ##使用NSUserDefaults，根据存储时候指定的key值，获取本地保存的字符串
 *
 *  @param  key 保存该字符串时候，指定的key值
 *  @return 返回根据key值，取到的字符串
 */
+(NSString *)getString:(NSString *)key;


/**
 *  @brief      ##使用NSUserDefaults，本地存储一个NSUInteger
 *
 *  @param      integer  需要保存的integer类型的值
 *  @param      key      保存integer时候，指定的唯一值
 *  @warning    对相同的Key赋值,等于一次覆盖，要保证Key的唯一性
 */
+(void)setInteger:(NSUInteger)integer key:(NSString *)key;


/**
 *  @brief  ##使用NSUserDefaults，根据存储时候指定的key值，获取保存的Integer
 *
 *  @param  key 保存Integer时候，指定的key值
 *  @return 返回根据key值，取到的Integer
 */
+(NSUInteger)getInteger:(NSString *)key;


/**
 *  @brief      ##使用NSUserDefaults，本地存储一个布尔值
 *
 *  @param      value   需要保存的布尔值
 *  @param      key     保存布尔值时候，指定的唯一值
 *  @warning    对相同的Key赋值,等于一次覆盖，要保证Key的唯一性
 */
+(void)setBool:(BOOL)value key:(NSString *)key;


/**
 *  @brief  ##使用NSUserDefaults，根据存储时候指定的key值，获取保存的布尔值
 *
 *  @param  key 保存布尔值时候，指定的key值
 *  @return 返回根据key值，取到的布尔值
 */
+(BOOL)getBool:(NSString *)key;


/**
 *  @brief      ##使用NSUserDefaults，本地存储一个Double
 *
 *  @param      value   需要保存的Double
 *  @param      key     保存Double时候，指定的唯一值
 *  @warning    对相同的Key赋值,等于一次覆盖，要保证Key的唯一性
 */
+ (void)setDouble:(double)value key:(NSString *)key;


/**
 *  @brief  ##使用NSUserDefaults，根据存储时候指定的key值，获取保存的Double
 *
 *  @param  key 保存布尔值时候，指定的key值
 *  @return 返回根据key值，取到的Double
 */
+ (double)getDouble:(NSString *)key;


/**
 *  @brief      ##使用NSUserDefaults，本地存储一个数组
 *
 *  @param      array   需要保存的数组，必须是一个不可变数组
 *  @param      key     保存数组时候，指定的唯一值
 *  @warning    NSUserDefaults存储的对象全是不可变的（这一点非常关键，弄错的话程序会出现崩溃），例如：如果我想要存储一个NSMutableArray对象，我必须先创建一个不可变数组（NSArray）再将它存入NSUserDefaults中去
 */
+(void)setArray:(NSArray *)array key:(NSString *)key;


/**
 *  @brief      ##使用NSUserDefaults，根据存储时候指定的key值，获取保存的数组
 *
 *  @param      key 保存数组时候，指定的key值
 *  @return     返回根据key值，取到的数组
 *  @warning    由于NSUserDefaults存储的对象全是不可变的，这里在获取后得到的是一个不可变数组，如果直接使用可变数据接收数据，并向可变数组中执行添加或删除操作，会导致程序崩溃
 */
+(NSArray *)getArray:(NSString *)key;


/**
 *  @brief      ##使用NSUserDefaults，本地存储一个字典
 *
 *  @param      dic   需要保存的字典
 *  @param      key   唯一指定的key值
 *  @warning    NSUserDefaults存储的对象全是不可变的（这一点非常关键，弄错的话程序会出现崩溃），需要转换为不可变再存储
 */
+(void)setDictionary:(NSDictionary *)dic key:(NSString *)key;


/**
 *  @brief      ##使用NSUserDefaults，根据存储时候指定的key值，获取保存的字典
 *
 *  @param      key 保存字典时候，指定的key值
 *  @return     返回根据key值，取到的字典
 *  @warning    由于NSUserDefaults存储的对象全是不可变的，这里在获取后得到的是一个不可变字典
 */
+(NSDictionary *)getDictionary:(NSString *)key;


/**
 *  @brief  ##使用writeToFile方法，把数组写入到Documents目录下
 *
 *  @param  array       需要写入文件的数组
 *  @param  fileName    写入文件的名字
 */
+ (BOOL)writeArrayToFile:(NSArray *)array fileName:(NSString *)fileName;


/**
 *  @brief  ##根据存储的文件名称，从Documents目录下读取存储的数组
 *
 *  @param  fileName 文件名
 *  @return 返回根据文件名读取到的数组
 */
+(NSArray *)readArrayByFile:(NSString *)fileName;


/**
 根据文件名称,从Documents下删除存储的数组

 @param fileName 文件名称
 @return 是否删除成功
 */
+ (BOOL)deleteArrayFromFile:(NSString *)fileName;


/**
 *  @brief  ##使用writeToFile方法，把字典写入Documents目录下的文件中
 *
 *  @param  dic         需要写入文件的字典
 *  @param  fileName    写入文件的名字
 *  @return Yes写入文件成功，No写入文件失败
 */
+(BOOL)writeDicToFile:(NSDictionary *)dic fileName:(NSString *)fileName;


/**
 *  @brief  ##从Documents目录下的文件中读取存储的字典
 *
 *  @param  fileName 文件名字
 *  @return 返回根据文件名读取到的字典
 */
+(NSDictionary *)readDicByFile:(NSString *)fileName;


/**
 根据文件名称,从Documents下删除存储的字典

 @param fileName 文件名称
 @return 是否删除成功
 */
+ (BOOL)deleteDicFromFile:(NSString *)fileName;


/**
 *  @brief  ##使用writeToFile方法，把NSData数据写入到Documents目录下的文件中
 *
 *  @param  data       需要写入文件的data数据
 *  @param  fileName   写入文件的名字
 */
+(void)writeDataToFile:(NSData *)data fileName:(NSString *)fileName;


/**
 *  @brief  ##NSData数据的读取，从Documents目录下的文件中
 *
 *  @param  fileName 文件名字
 *  @return 返回根据文件名读取到的NSData
 */
+(NSData *)readDataByFile:(NSString *)fileName;


/**
 *  @brief  ##把NSURLProtocol拦截到的图片数据，缓存到指定文件中
 *
 *  @param  data       需要写入文件图片data数据
 *  @param  fileName   需要保存的图片名称
 */
+(void)writeDataToAdImageCache:(NSData *)data fileName:(NSString *)fileName;


/**
 *  @brief  ##NSData数据的读取，从Documents目录下的文件中
 *
 *  @param  fileName 文件名字
 *  @return 返回根据文件名读取到的NSData
 */
+(NSData *)readAdImageCacheByFile:(NSString *)fileName;


@end


