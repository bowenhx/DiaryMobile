/**
 -  BKNetworkModel.h
 -  BKSDK
 -  Created by ligb on 16/11/10.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  接收网络请求返回数据的模型类,含有status请求状态，data请求数据，message请求返回信息三个字段
 */

#import <Foundation/Foundation.h>

@interface BKNetworkModel : NSObject


/** 请求状态值，标示请求的成功或失败 */
@property (nonatomic , assign) NSInteger    status;

/** 请求返回的数据 */
@property (nonatomic , strong) id           data;

/** 后台返回的文字信息 */
@property (nonatomic , copy) NSString       *message;


@end
