/**
 -  BKNetworking.m
 -  BKSDK
 -  Created by ligb on 16/11/10.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreFoundation/CoreFoundation.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import "BKNetworking.h"


#define TIMEOUT 60                              //超时时间
#define KEY_BOUNDARY @"------kingdombkapp"      //分隔符
#define UPLOAD_IMAGE @"Filedata"                //标示上传类型为图片
#define UPLOAD_TYPE  @"myimage.jpg"             //标示上传文件格式

@interface BKNetworking()<NSURLSessionDelegate>

/** 网络请求NSURLSession */
@property (nonatomic , strong) NSURLSession *session;
/** 创建一个全局的并行队列 */
@property (nonatomic , strong) dispatch_queue_t queue;

@end

@implementation BKNetworking


+ (BKNetworking *)share {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (NSURLSession *)session {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    return [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
}


- (dispatch_queue_t)queue {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}


#pragma mark - get

- (void)get:(NSString *)url completion:(CompletionBlock)completion {
    
    [self get:url precent:^(float precent) {
    } completion:completion];
}


- (void)get:(NSString *)url
    precent:(PrecentBlock)precentBlock
 completion:(CompletionBlock)completion {
   
    dispatch_async(self.queue, ^{
        [self checkNetworkBlock:^(NSString *netMeg, BOOL status) {
            if (status) {
                //网络状态正常
                [[self.session dataTaskWithURL:[NSURL urlWithMutableString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    if (error) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            completion(nil , error.localizedDescription);
                        });
                    } else {
                        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            if (jsonData) {
                                BKNetworkModel *model = [[BKNetworkModel alloc] init];
                                [model setValuesForKeysWithDictionary:jsonData];
                                completion(model , nil);
                            } else {
                                completion (nil , s_errServe);
                            }
                        });
                    }
                }] resume];
                
                //进度回调
                [self setTaskBytesSent:^(float precent) {
                    precentBlock(precent);
                }];
                
            } else {
                //无法连接网络
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completion(nil , s_errNet);
                });
            }
        }];
    });
}


- (void)gets:(NSArray *)urls
     precent:(PrecentBlock)precent
  completion:(CompletionBlock)completion {
 
    [urls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = (NSString *)obj;
        if ([url isKindOfClass:[NSString class]] && url.length) {
            [self get:url precent:precent completion:completion];
        } else {
            NSLog(@"error url : %@",url);
        }
    }];
}


#pragma mark - post

- (void)post:(NSString *)url
      params:(NSDictionary *)params
  completion:(CompletionBlock)completion {
    
    [self post:url params:params precent:^(float precent) {
    } completion:completion];
}


- (void)post:(NSString *)url
      params:(NSDictionary *)params
     precent:(PrecentBlock)precentBlock
  completion:(CompletionBlock)completion {
    
    __weak typeof(self)bself = self;
    dispatch_async(self.queue, ^{
        [self checkNetworkBlock:^(NSString *netMeg, BOOL status) {
            if (status) {
                NSMutableURLRequest *request = [NSMutableURLRequest request:url params:params];
                [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            completion(nil , error.localizedDescription);
                        });
                    } else {
                        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            if (jsonData) {
                                BKNetworkModel *model = [[BKNetworkModel alloc] init];
                                [model setValuesForKeysWithDictionary:jsonData];
                                completion(model , nil);
                            } else {
                                completion (nil , s_errServe);
                            }
                        });
                    }
                }] resume];
                //进度回调
                [bself setTaskBytesSent:^(float precent) {
                    precentBlock(precent);
                }];
            } else {
                //无法连接网络
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completion(nil,s_errNet);
                });
            }
        }];
    });
}


#pragma mark - 上传任务

- (void)upload:(NSString *)url
        params:(NSDictionary *)params
         image:(UIImage *)image
       precent:(PrecentBlock)precentBlock
    completion:(CompletionBlock)completion {
    
    __weak typeof(self)bself = self;
    dispatch_async(self.queue, ^{
        [self checkNetworkBlock:^(NSString *netMeg, BOOL status) {
            if (status) {
                NSMutableURLRequest * request = [NSMutableURLRequest requestForUpload:url andFiles:@[@[UPLOAD_IMAGE,image]] params:params type:UPLOAD_TYPE];
                [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            completion(nil,error.localizedDescription);
                        });
                    } else {
                        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            if (jsonData) {
                                BKNetworkModel *model = [[BKNetworkModel alloc] init];
                                [model setValuesForKeysWithDictionary:jsonData];
                                completion(model , nil);
                            } else {
                                completion (nil , s_errServe);
                            }
                        });
                    }
                }] resume];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //进度回调
                    [bself setTaskBytesSent:^(float precent) {
                        precentBlock(precent);
                    }];
                });
            } else {
                //无法连接网络
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completion(nil,s_errNet);
                });
            }
        }];
    });
}


- (void)upload:(NSString *)url
        params:(NSDictionary *)params
         files:(NSArray *)files
       precent:(PrecentBlock)precentBlock
    completion:(CompletionBlock)completion {
    
    __weak typeof(self)bself = self;
    dispatch_async(self.queue, ^{
        [self checkNetworkBlock:^(NSString *netMeg, BOOL status) {
            if (status) {
                NSMutableURLRequest * request =[NSMutableURLRequest requestForUpload:url andFiles:files params:params type:UPLOAD_TYPE];
                [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            completion(nil,error.localizedDescription);
                        });
                    } else {
                        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                       
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            if (jsonData) {
                                BKNetworkModel *model = [[BKNetworkModel alloc] init];
                                [model setValuesForKeysWithDictionary:jsonData];
                                completion(model , nil);
                            } else {
                                completion (nil , s_errServe);
                            }
                        });
                    }
                }] resume];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //进度回调
                    [bself setTaskBytesSent:^(float precent) {
                        precentBlock(precent);
                    }];
                });
                
            } else {
                //无法连接网络
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completion(nil,s_errNet);
                });
            }
        }];
    });
}


#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    double progress = (double)totalBytesSent / totalBytesExpectedToSend;
    dispatch_sync(dispatch_get_main_queue(), ^{
        //进度回调
        self.taskPrecent(progress);
    });
}

-(void)setTaskBytesSent:(PrecentBlock)precentBlock {
    self.taskPrecent = precentBlock;
}


#pragma mark - 检查网络连接
- (void)checkNetworkBlock:(void (^)(NSString *netMeg , BOOL status))block {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        block (@"count not recover network reachability flags" , NO);
    } else {
        //根据获得的连接标志进行判断
        BOOL isReachable = flags & kSCNetworkFlagsReachable;
        BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
        if((isReachable && !needsConnection)==YES) {
            //能够连接网络
            if((flags& kSCNetworkReachabilityFlagsIsWWAN)==kSCNetworkReachabilityFlagsIsWWAN) {
                block (@"KSCNetworkFlagsWWAN" , YES);
            } else {
                block (@"KSCNetworkFlagsWiFi" , YES);
            }
        } else {
            block (@"NotKSCNetworkFlags" , NO);
        }
    }
}

- (BOOL)checkNetworkIsWifi{
    __block BOOL currentStatus = NO;
    [self checkNetworkBlock:^(NSString *netMeg, BOOL status) {
        if (status && [netMeg isEqualToString:@"KSCNetworkFlagsWiFi"]) {
            currentStatus = YES;
        }
    }];
    return currentStatus;
}

- (NSMutableArray *)apiValues {
    if (!_apiValues) {
        _apiValues = [NSMutableArray array];
    }
    return _apiValues;
}

@end




#pragma mark - NSDictionary_Extension
@interface NSDictionary (NSDictionary_Extension)

+ (NSString *)stringForDictionary:(NSDictionary *)parameters;

@end

@implementation NSDictionary (NSDictionary_Extension)

+ (NSString *)stringForDictionary:(NSDictionary *)parameters {
    NSMutableArray *stringParameters = [NSMutableArray arrayWithCapacity:parameters.count];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *value = (NSString *)obj;
        if ( [value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            NSString *string = [NSString stringWithFormat:@"%@=%@", key, obj];
            [stringParameters addObject:string];
        } else {
            [NSException raise:NSInvalidArgumentException format:@"error: requests only accept NSString, NSNumber and NSData parameters."];
        }
    }];
    return [stringParameters componentsJoinedByString:@"&"];
}
@end




#pragma mark - NSURL_Ex
@implementation NSURL (NSURL_Ex)

+ (NSURL *)urlWithMutableString:(NSString *)url {
   //判断是否是完整含有http 的url
    if ( url ) {
        if ([BKNetworking share].apiValues.count > 2) {
            [[BKNetworking share].apiValues removeObjectAtIndex:0];
        }

        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            [[BKNetworking share].apiValues addObject:url];
            return [NSURL URLWithString:url];
        } else {
            NSString *urlStr = [self addBuildRequestUrl:url];
            NSString *endUrl = [NSString stringWithFormat:@"%@%@",[BKNetworkConfig sharedInstance].baseUrl,urlStr];
            [[BKNetworking share].apiValues addObject:endUrl];
            return [NSURL URLWithString:endUrl];
        }
    }
    return nil;
}


+ (NSString *)addBuildRequestUrl:(NSString *)addUrl {
    NSString *detailUrl = [NSDictionary stringForDictionary:[BKNetworkConfig sharedInstance].parameterDic];
    return [NSString stringWithFormat:@"%@&%@",addUrl,detailUrl];
}

@end




#pragma mark - NSURLRequest_Extension
@implementation NSMutableURLRequest (NSURLRequest_Extension)

+ (NSMutableURLRequest *)requestURL:(NSString *)url parms:(NSDictionary *)dic {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL urlWithMutableString:url]];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = TIMEOUT;
    return request;
}


+ (NSMutableURLRequest *)request:(NSString *)url params:(NSDictionary *)dic {
    NSMutableURLRequest *request = [self requestURL:url parms:dic];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSData *data = [[NSDictionary stringForDictionary:dic] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    return request;
}


+ (NSMutableURLRequest *)requestForUpload:(NSString *)url andFiles:(NSArray *)files params:(NSDictionary *)dic type:(NSString *)fileType {
    NSMutableURLRequest *request = [self requestURL:url parms:dic];
    NSString * type = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",KEY_BOUNDARY];
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody =[self getHttpBodWithFiles:files andParmaters:dic type:fileType];
    return request;
}


#pragma mark - NSURLRequest_Extension
/**
*  @brief 上传单张图片或者多个文件
*
*  @param   files       需要上传的内容 这是个二位数组 角标0 为上传文件对应的名字 角标1 为上传的文件
*  @param   parmaters   post附加参数：key =参数名 ,value = 参数值
*  @param   fileType    标示上传的类型，image：图片  file：文件
*  @return  返回处理后的data数据
*/
+ (NSData *)getHttpBodWithFiles:(NSArray *)files andParmaters:(NSDictionary *)parmaters type:(NSString *)fileType {
    NSMutableData *data = [NSMutableData data];
    //获取附加参数信息
    [parmaters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *parmaterKey = key;
        NSString *parmaterValue = [NSString stringWithFormat:@"%@",obj];
        NSMutableString *textStr = [NSMutableString stringWithFormat:@"\r\n--%@\r\n",KEY_BOUNDARY];
        [textStr appendFormat:@"Content-Disposition: form-data;name=\"%@\"\r\n\r\n",parmaterKey];
        [data appendData:[textStr dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *msgData = [parmaterValue dataUsingEncoding:NSUTF8StringEncoding];
        [data appendData:msgData];
    }];
    
    /***
     *   遍历数组 添加data数据流
     *   注意：  files >>  是个二位数组，角标0 为上传文件对应的名字 角标1 为上传的文件
     */
    [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //name 对应的就是服务器识别的文件名称
        NSString *name = obj[0];
        id value = obj[1];
        NSMutableString *headerString = [NSMutableString stringWithFormat:@"\r\n--%@\r\n",KEY_BOUNDARY];
        //使用通用类型的方法 application/octet-stream
        [headerString appendFormat:@"Content-Type: application/octet-stream\r\n"];
        //fileType 对应的是文件类型
        NSString *type = [NSString stringWithFormat:@"Content-Disposition: form-data;name=\"%@\"; filename=\"%@\"\r\n\r\n",name,fileType];
        [headerString appendString:type];
        [data appendData:[headerString dataUsingEncoding:NSUTF8StringEncoding]];
        //创建文件内容
        NSData * fileData;
        if ([value isKindOfClass:[UIImage class]]) {
            fileData = UIImageJPEGRepresentation(value, 1);
        } else if ([value isKindOfClass:[NSString class]]) {
            fileData = [NSData dataWithContentsOfFile:value];
        }
        if (fileData) {
            [data appendData:fileData];
        }
    }];
    //加入尾部分隔符
    NSMutableString *footerString = [NSMutableString stringWithFormat:@"\r\n--%@--\r\n",KEY_BOUNDARY];
    [data appendData:[footerString dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}

@end
