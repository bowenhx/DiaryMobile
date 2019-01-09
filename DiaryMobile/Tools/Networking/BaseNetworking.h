//
//  BaseNetworking.h
//  DiaryMobile
//
//  Created by stray s on 2019/1/9.
//  Copyright © 2019年 com.professional.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKNetworking.h"

@interface BaseNetworking : NSObject
/**
 BK所使用的网络请求入口
 
 @param url         请求地址，非空
 @param parameter   请求参数，如果为空代表是get请求，非空代表post请求
 @param block       请求返回的block
 */
+ (void)mHttpWithUrl:(NSString *)url
           parameter:(NSDictionary *)parameter
            response:(CompletionBlock)block;

@end
