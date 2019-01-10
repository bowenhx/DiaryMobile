/**
 -  BKNetworkConfig.h
 -  BKSDK
 -  Created by ligb on 16/11/10.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  统一设置网络请求服务器地址及配置参数，含有baseUrl，可以追加参数比如App的版本号
 */

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "BKDefineFile.h"

@interface BKNetworkConfig : NSObject


+ (BKNetworkConfig *)sharedInstance;


/** 请求url中base地址 */
@property (copy, nonatomic) NSString *baseUrl;


/** 给url追加参数，比如AppVersion, ApiVersion,等 */
@property (strong, nonatomic) NSDictionary *parameterDic;


@end
