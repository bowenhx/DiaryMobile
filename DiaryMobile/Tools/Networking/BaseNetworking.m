//
//  BaseNetworking.m
//  DiaryMobile
//
//  Created by stray s on 2019/1/9.
//  Copyright © 2019年 com.professional.cn. All rights reserved.
//

#import "BaseNetworking.h"

@implementation BaseNetworking

+ (void)mHttpWithUrl:(NSString *)url
           parameter:(NSDictionary *)parameter
            response:(CompletionBlock)block {
    if (parameter) {
        [self mStartPOST:url parameters:parameter response:block];
    } else {
        [self mStartGET:url response:block];
    }
}

#pragma mark - GET请求
+ (void)mStartGET:(NSString *)urlString response:(CompletionBlock)block {
    [[BKNetworking share] get:urlString completion:block];
}

#pragma mark - POST请求
+ (void)mStartPOST:(NSString *)urlSring parameters:(NSDictionary *)parameters response:(CompletionBlock)block {
    //请求网络数据
    [[BKNetworking share] post:urlSring params:parameters completion:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            if (block) block(nil, netErr);
        } else {
            if (block) {
                if (model.status == -2) {
                    block(nil, model.message);
                } else {
                    block(model, nil);
                }
            }
        }
    }];
}


@end
