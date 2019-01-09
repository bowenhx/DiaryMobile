/**
 -  BKNetworking.h
 -  BKSDK
 -  Created by ligb on 16/11/10.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  网络请求类，包含，Get单个请求，Get单个请求含有进度回调，Get批量请求。 Post单个请求，Post单个请求含有进度回调。普通单个上传图片的任务和批量上传图片的任务。检查网络连接状态。
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BKNetworkModel.h"
#import "BKNetworkConfig.h"

static NSString * const s_errServe = @"連接伺服出現錯誤，請稍後再嘗試";
static NSString * const s_errNet   = @"當前網絡不可用請檢查網絡連接";


/** 单个进度显示 */
typedef void (^PrecentBlock)(float precent);

/** 下载完成后返回（当下载错误是，提供response 提供下载的结果，baseData 返回数据json/img, err 判断下载状态） */
typedef void (^CompletionBlock)(BKNetworkModel *model, NSString *netErr);


@interface BKNetworking : NSObject
@property(nonatomic, strong) NSMutableArray *apiValues;
@property(nonatomic, copy) PrecentBlock taskPrecent;

/**
 *  单例
 */
+ (BKNetworking *)share;


/**
 *  @brief get请求，单个任务
 *
 *  @param url        地址
 *  @param completion 完成回调
 */
- (void)get:(NSString *)url
 completion:(CompletionBlock)completion;


/**
 *  @brief get请求，单个任务，含有进度
 *
 *  @param url              地址
 *  @param precentBlock     进度回调
 *  @param completion       完成回调
 */
- (void)get:(NSString *)url
    precent:(PrecentBlock)precentBlock
 completion:(CompletionBlock)completion;


/**
 *  @brief get请求，批量任务,含有进度
 *
 *  @param urls             地址数组
 *  @param precentBlock     进度回调
 *  @param completion       完成回调
 */
- (void)gets:(NSArray *)urls
    precent:(PrecentBlock)precentBlock
 completion:(CompletionBlock)completion;


/**
 *  @brief post，单个任务
 *
 *  @param url              地址
 *  @param params           参数
 *  @param completion       完成回调
 */
- (void)post:(NSString *)url
      params:(NSDictionary *)params
  completion:(CompletionBlock)completion;


/**
 *  @brief post，单个任务，含有进度
 *
 *  @param url              地址
 *  @param params           参数
 *  @param precentBlock     进度回调
 *  @param completion       完成回调
 */
- (void)post:(NSString *)url
      params:(NSDictionary *)params
     precent:(PrecentBlock)precentBlock
  completion:(CompletionBlock)completion;


/**
 *  @brief upload  普通单个上传任务
 *
 *  @param url              地址
 *  @param params           参数
 *  @param image            图片
 *  @param precentBlock     进度回调
 *  @param completion       完成回调
 */
- (void)upload:(NSString *)url
        params:(NSDictionary *)params
         image:(UIImage *)image
       precent:(PrecentBlock)precentBlock
    completion:(CompletionBlock)completion;


/**
 *  @brief upload 批量上传任务
 *
 *  @param url              地址
 *  @param params           参数
 *  @param files            图片路径数组
 *  @param precentBlock     进度回调
 *  @param completion       完成回调
 */
- (void)upload:(NSString *)url
        params:(NSDictionary *)params
         files:(NSArray *)files
       precent:(PrecentBlock) precentBlock
    completion:(CompletionBlock)completion;


#pragma mark 检查网络连接
- (void)checkNetworkBlock:(void (^)(NSString *netMeg , BOOL status))block;

/**
 检测是否是wifi状态

 @return YES：代表是wifi，NO：代表其他状态
 */
- (BOOL)checkNetworkIsWifi;
@end




//************************************************************************

/**
 -  NSURL_Ex.h
 -  BKSDK
 -  Created by ligb on 16/11/10.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  对NSURL进行扩充方法，方便使用，便于拼接一个完整的请求的url，以及给url追加版本号等附加参数的方法
 */

@interface NSURL (NSURL_Ex)

/**
* @brief  拼接成一个完整的url，加上base地址，版本号等信息
* @param  url 需要判断拼接的地址
* @return 返回拼接后的完整URL
*/
+ (NSURL *)urlWithMutableString:(NSString *)url;


/**
 * @brief  给url追加字段如版本号，设备类型等
 * @param  addUrl 需要添加的参数
 * @return 返回拼接后的字符串
 */
+ (NSString *)addBuildRequestUrl:(NSString *)addUrl;

@end




//************************************************************************

/**
 -  NSURLRequest_Extension.h
 -  BKSDK
 -  Created by ligb on 16/11/10.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  NSMutableURLRequest扩充方法，封装了普通Request方法和上传文件的Request方法
 */

@interface NSMutableURLRequest (NSURLRequest_Extension)

/**
 * @brief  NSMutableURLRequest普通Request方法封装
 * @param  url 请求地址
 * @param  dic 请求添加的参数
 * @return 返回处理后的NSMutableURLRequest
 */
+ (NSMutableURLRequest *)request:(NSString *)url params:(NSDictionary *)dic;


/**
 * @brief  NSMutableURLRequest上传文件的Request方法封装
 * @param  url          请求地址
 * @param  files        上传的文件
 * @param  dic          附加的参数
 * @param  fileType     标示上传的类型，image：图片  file：文件
 * @return 返回处理后的NSMutableURLRequest
 */
+ (NSMutableURLRequest *)requestForUpload:(NSString *)url andFiles:(NSArray *)files params:(NSDictionary *)dic type:(NSString *)fileType;
@end
