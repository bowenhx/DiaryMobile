/**
 -  SaveData.m
 -  BKSDK
 -  Created by ligb on 16/11/22.
 -  Copyright © 2016年 HY. All rights reserved.
 */

#import "BKSaveData.h"



@implementation BKSaveData


#pragma mark - 使用NSUserDefaults对字符串类型做存取操作
+ (void)setString:(NSString *)string key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:string.length > 0 ? string:@"" forKey:key];
    [defaults synchronize];
}


+ (NSString *)getString:(NSString *)key {
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value.length ? value : @"";
}


#pragma mark - 使用NSUserDefaults对NSUInteger类型做存取操作
+ (void)setInteger:(NSUInteger)integer key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:integer forKey:key];
    [defaults synchronize];
}


+ (NSUInteger)getInteger:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}


#pragma mark - 使用NSUserDefaults对BOOL类型做存取操作
+ (void)setBool:(BOOL)value key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}


+ (BOOL)getBool:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}


#pragma mark - 使用NSUserDefaults对double类型做存取操作
+ (void)setDouble:(double)value key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:value forKey:key];
    [defaults synchronize];
}


+ (double)getDouble:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}


#pragma mark - 使用NSUserDefaults对NSArray类型做存取操作
+ (void)setArray:(NSArray *)array key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:key];
    [defaults synchronize];
}


+ (NSArray *)getArray:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


#pragma mark - 使用NSUserDefaults对NSDictionary类型做存取操作
+ (void)setDictionary:(NSDictionary *)dic key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dic forKey:key];
    [defaults synchronize];
}


+ (NSDictionary *)getDictionary:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


#pragma mark - NSArray的文件读写
+ (BOOL)writeArrayToFile:(NSArray *)array fileName:(NSString *)fileName {
    //获取Document目录
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [array writeToFile:filePath atomically:YES];
    if (isSuccess) {
        NSLog(@"数组文件写入成功");
        return YES;
    } else {
        NSLog(@"数组文件写入失败");
        return NO;
    }
}


+ (NSArray *)readArrayByFile:(NSString *)fileName {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    return [NSArray arrayWithContentsOfFile:filePath];
}


+ (BOOL)deleteArrayFromFile:(NSString *)fileName {
    //获取文件管理单例对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    //判断文件是否存在
    BOOL isHave = [fileManager fileExistsAtPath:filePath];
    if (isHave) {
        //文件存在,则删除文件
        BOOL isDelete = [fileManager removeItemAtPath:filePath error:nil];
        if (isDelete) {
            NSLog(@"文件删除成功");
            return YES;
        } else {
            NSLog(@"文件删除失败");
        }
    } else {
        NSLog(@"文件删除失败,因为文件不存在");
    }
    return NO;
}


#pragma mark - NSDictionary的文件读写
+ (BOOL)writeDicToFile:(NSDictionary *)dic fileName:(NSString *)fileName {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    BOOL isFinish = [dic writeToFile:filePath atomically:YES];
    return isFinish;
}


+ (NSDictionary *)readDicByFile:(NSString *)fileName {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}


+ (BOOL)deleteDicFromFile:(NSString *)fileName {
    return [self deleteArrayFromFile:fileName];
}


#pragma mark - NSData的文件读写
+ (void)writeDataToFile:(NSData *)data fileName:(NSString *)fileName {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:YES];
}


+ (NSData *)readDataByFile:(NSString *)fileName {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    return [NSData dataWithContentsOfFile:filePath];
}


#pragma mark - 广告图片的缓存读写
+ (void)writeDataToAdImageCache:(NSData *)data fileName:(NSString *)fileName {
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@",pathDocuments,SAVE_IMAGE_CACHE_FOLDER];
    if (![[NSFileManager defaultManager]fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"缓存广告图片的文件路径创建成功： %@",createPath);
    } else {
        NSLog(@"缓存广告图片的文件路径已经存在： %@",createPath);
    }
    NSString *filePath = [createPath stringByAppendingPathComponent:fileName];
    BOOL write = [data writeToFile:filePath atomically:YES];
    NSLog(@"写入广告图片状态   %d",write);
}


+ (NSData *)readAdImageCacheByFile:(NSString *)fileName {
    NSString *ppth = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:SAVE_IMAGE_CACHE_FOLDER];
    NSString *filePath = [ppth stringByAppendingPathComponent:fileName];
    return [NSData dataWithContentsOfFile:filePath];
}


@end
