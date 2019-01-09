/**
 -  Tool.m
 -  BKSDK
 -  Created by HY on 16/11/11.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import "BKTool.h"
#import "BKNetworking.h"
#import "BKDefineFile.h"
//获取设备型号
#import "sys/utsname.h"
#import "NSString+UIColor.h"

@implementation BKTool


#pragma mark - 判断字符串是否为整形
+ (BOOL)isPureInt:(NSString*)string {
    NSScanner * scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


#pragma mark - 判断一个字符串是否为空
+ (BOOL)isStringBlank:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (string == nil && [string length] == 0) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}


#pragma mark - 判断字符串中是否含有某个字符串
+ (BOOL)isHaveString:(NSString *)str inString:(NSString *)originalStr {
    NSRange _range = [originalStr rangeOfString:str];
    if (_range.location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - 获取url字符串中某个参数所对应的值
+ (NSString *)getValueStringOfKeyString:(NSString *)keyString formUrlString:(NSString *)urlString {
    if ([urlString rangeOfString:keyString].location != NSNotFound) {
        
        NSString *keyStringPlus = [NSString stringWithFormat:@"%@=",keyString];
        keyString = [urlString componentsSeparatedByString:keyStringPlus].lastObject;
        
        if ([keyString rangeOfString:@"&"].location != NSNotFound) {
            keyString = [keyString componentsSeparatedByString:@"&"].firstObject;
        }
    } else {
        keyString = @"";
    }
    return keyString;
}


#pragma mark - 格式化时间
+ (NSDateFormatter *)userDateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return formatter;
}


#pragma mark - 时间戳转换为时间格式 @"yyyy-MM-dd"
+ (NSString *)convertTimestempToDateWithString:(NSString *)timeStemp {
    NSTimeInterval interval = [timeStemp doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [self userDateFormatter];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}


#pragma mark - 获取当前时间 @"yyyy-MM-dd"
+ (NSString *)getTodyDate:(NSString *)dateFormat {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *str = [formatter stringFromDate:date];
    return str;
}


#pragma mark - 将十六进制颜色转换为 UIColor 对象
+ (UIColor*)colorWithHexString:(NSString *)color {
    //判断字符串是否符合一个字符串类型的颜色RGB格式
    if (color.length < 6) {
        return @"#000000".color;
    }
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] < 6 || [cString length] > 8) {
        return @"#000000".color;
    }
    
    static int COLOR_LENGTH = 4;
    unsigned int colorARGB[COLOR_LENGTH];
    for (int i = 0; i < 4; i++) {
        // 先初始化为所有都是255
        colorARGB[COLOR_LENGTH-i-1] = 255;
        // 根据子字符串进行数字转换
        NSString *subString = [cString substringFromIndex: cString.length < 2 ? 0 : cString.length - 2];
        cString = [cString substringToIndex:cString.length < 2 ? cString.length : cString.length - 2];
        if (subString.length) {
            [[NSScanner scannerWithString:subString] scanHexInt:&colorARGB[COLOR_LENGTH-i-1]];
        }
    }
    return [UIColor colorWithRed:((float) colorARGB[1] / 255.0f)
                           green:((float) colorARGB[2] / 255.0f)
                            blue:((float) colorARGB[3] / 255.0f)
                           alpha:((float) colorARGB[0] / 255.0f)];
}


#pragma mark - 字符转意处理
+ (NSString *)stringByUrlEncoding:(NSString *)string {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,  (__bridge CFStringRef)string,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]",  kCFStringEncodingUTF8);
}


#pragma mark - 计算一个label的高度
+ (CGSize)mCalculateVerticalSize:(NSString *)labelText labelMaxWidth:(CGFloat)labelMaxWidth font:(UIFont*)font defaultSpace:(CGFloat)space {
    NSDictionary *cellTextDic=nil;
    if (space!=0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:space];
        cellTextDic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    } else {
        cellTextDic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    }
    CGSize labelSize = [labelText boundingRectWithSize:CGSizeMake(labelMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:cellTextDic context:nil].size;
    return  CGSizeMake(ceil(labelSize.width), ceil(labelSize.height));
}

#pragma mark - 从堆栈信息中，定位崩溃的页面方法
+ (NSString *)getCrashViewMethod:(NSArray<NSString *> *)callStackSymbols {
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                //get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                }
                *stop = YES;
            }
        }];
        
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    return mainCallStackSymbolMsg;
}

#pragma mark - 获取Documents文件夹目录
+ (NSString *)getDocumentsPath:(NSString *)fileName {
    //获取Documents文件夹目录
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    return [[docPath lastObject] stringByAppendingPathComponent:fileName];
}

#pragma mark - 获取Library文件夹下某个文件路径
+ (NSString *)getLibraryDirectoryPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths lastObject] stringByAppendingPathComponent:fileName];
}

#pragma mark - 获取随机颜色
+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() / (CGFloat)RAND_MAX ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() / (CGFloat)RAND_MAX); // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() / (CGFloat)RAND_MAX ); //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


#pragma mark - 获取设备型号   获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}


#pragma mark - 统计app的启动次数
+ (void)mStatisticsAppLaunch:(NSString *)appSource {
    NSString *url = @"https://i.gugubaby.com/project_work/index.php?c=service&m=poststart";
   
    
    // 当前应用软件版本  比如：1.0版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    // build
    NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:appVersion forKey:@"ver"]; //version
    [dic setObject:appBuild forKey:@"build"]; //build
    
    [dic setObject:@"ios" forKey:@"app"]; //平台
    [dic setObject:appSource forKey:@"source"]; //app来源 [HK|SZ|TW|EK]
    [dic setObject:[self getDeviceName] forKey:@"machine"]; //手机型号
    [dic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"release"]; //当前ios系统
    
    [[BKNetworking share] post:url params:dic completion:^(BKNetworkModel *model, NSString *netErr) {
        if (model.status) {
            //NSLog(@"统计成功");
        }
    }];
}


#pragma mark - 系统分享
+ (void)mSystemShare:(UIViewController *)vc urlToShare:(NSString *)urlToShare textToShare:(NSString *)textToShare imageToShare:(UIImage *)imageToShare {
    NSURL *url = [NSURL URLWithString:urlToShare];
    NSArray *activityItems = @[url,textToShare,imageToShare];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [vc.navigationController presentViewController:activityController animated:YES completion:nil];
}


#pragma mark -  获取指定文件的大小，返回M
+ (CGFloat)mFolderSizeAtPath:(NSString *)folderPath {
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [self mFileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0);
}


//计算单个文件的大小
+ (long long)mFileSizeAtPath:(NSString *)filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 清空指定路径下的文件夹
+ (void)mClearnDataWithFilePath:(NSString *)filePath {
    NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:filePath];
    for ( NSString * subPath in files) {
        NSError * error = nil;
        //获取文件全路径
        NSString * fileAbsolutePath = [filePath stringByAppendingPathComponent:subPath];
        if ([[NSFileManager defaultManager ] fileExistsAtPath:fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath:fileAbsolutePath error:&error];
        }
    }
}


/**
 获取到当前界面显示的控制器的类名
 
 @return 当前界面显示的控制器的类名
 */
+ (NSString *)mGetCurrentViewControllerClassName {
    //获得主窗口的控制器
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    while (1) {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = ((UITabBarController*)viewController).selectedViewController;
        }
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = ((UINavigationController*)viewController).visibleViewController;
        }
        if (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        } else {
            break;
        }
    }
    return NSStringFromClass([viewController class]);
}


@end
