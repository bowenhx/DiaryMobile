/**
 -  BKNetworkConfig.m
 -  BKSDK
 -  Created by ligb on 16/11/10.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import "BKNetworkConfig.h"


@implementation BKNetworkConfig


+ (BKNetworkConfig *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


//- (NSDictionary *)parameterDic {
//    //时间戳md5，然后反转，再base64 -拼接- 时间戳base64
//    //获取当前的时间戳
//    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];//是精确到秒
//    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
//
//    NSString *encodeVlaue = [self md5Encode:timeString];
//    encodeVlaue = [self stringReverse:encodeVlaue];
//    encodeVlaue = [self mBase64Encode:encodeVlaue];
//    NSString *codeValue = [NSString stringWithFormat:@"%@-%@",encodeVlaue,[self mBase64Encode:timeString]];
//
//    return @{@"ver":APP_VERSION,
//             @"app":@"ios",
//             @"ipadflag":kIS_IPAD ? @1 : @0,
//             @"code":codeValue};
//}

//字符串翻转
- (NSString *)stringReverse:(NSString *)string {
    NSMutableString *reverseString = [NSMutableString string];
    for (NSInteger i = string.length -1 ; i >= 0; i--) {
        unichar c = [string characterAtIndex:i];
        NSString *str = [NSString stringWithCharacters:&c length:1];
        [reverseString appendString:str];
    }
    return reverseString;
}


- (NSString *)mBase64Encode:(NSString *)string {
    if (!string) return nil;
    NSData *base64Data = [[string dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}


- (NSString *)md5Encode:(NSString *)string {
    const char *strs = [string UTF8String];
    unsigned char r[16];
    CC_MD5(strs, (CC_LONG)strlen(strs), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

@end
