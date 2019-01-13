
/**
 -  UserHelper.m
 -  BKMobile
 -  Created by ligb on 17/1/9.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import "UserHelper.h"
#import "KDefine.h"

@implementation UserHelper


+ (void)mClearUserInfoData {
    
    //清空NSUserDefaults下的内容
    NSString*appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    
    [SaveUser mSaveUser:nil];
    
    //表情可以不用清理,防止切换账号，或者选择手动清除用户信息后，再次发帖/发私信找不到表情
    //[BKSaveData deleteArrayFromFile:SmileyKey];

   
    //清楚本地上传图片
    [self removeFilePath:@"UpImages"];

    //删除日志分类缓存
    NSString *path = [BKTool getLibraryDirectoryPath:kBlogTypeKey];
    [self removeFilePath:path];
    
}


+ (int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}


//存储图片路径
+ (NSString *)saveImagePath:(UIImage *)image{
    //先创建用户文件夹，再在用户文件夹存入要图片文件
    NSString *path = [[self getLibraryFilePathManager] stringByAppendingPathComponent:@"UpImages"];
    
    //如果不存在则创建临时存储目录
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *tempName = [NSString stringWithFormat:@"img_%d.jpg",arc4random_uniform(10000)];
    path = [path stringByAppendingPathComponent:tempName];
    //保存图片文件
    BOOL isSave = [UIImageJPEGRepresentation(image, 0.7) writeToFile:path options:NSAtomicWrite error:&error];
    NSLog(@"图片保存状态 = %d",isSave);
    return tempName;
}


//获取图片路径
+ (NSString *)getImagePath:(NSString *)file{
    //先创建用户文件夹，再在用户文件夹存入要图片文件
    NSString *path = [[[self getLibraryFilePathManager] stringByAppendingPathComponent:@"UpImages"] stringByAppendingPathComponent:file];
    return path;
}

+ (BOOL)removeFilePath:(NSString *)path{
    //删除上传图片文件存储目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:path]){
        BOOL succeed = [fileManager removeItemAtPath:path error:&error];
        NSLog(@"图片文件夹删除成功");
        return succeed;
    }
    return NO;
    
}

+ (NSString *)getLibraryFilePathManager{
    //在Library下的创建用户文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *userFile = [NSString stringWithFormat:@"User_%@",USERID];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:userFile];
    return  path;
}



@end


