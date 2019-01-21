//
//  LogListModel.m
//  EduKingdom
//
//  Created by ligb on 2017/1/11.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "LogListModel.h"

@implementation LogListPage
- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
}
#pragma mark KVC 安全设置
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"%s",__func__);
}
- (void)setNilValueForKey:(NSString *)key
{
    //NSLog(@"%s",__func__);
}
@end

@implementation LogListModel

+ (void)loadBlogListType:(NSString *)catid order:(NSString *)order page:(NSInteger)page block:(ListDataBlock)block {
    [BaseNetworking mHttpWithUrl:kHomeBlogList parameter:@{@"token":TOKEN,@"catid":catid,@"order":order,@"page":@(page)} response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block ( nil , nil , netErr );
        }else{
            if ( model.status == 1) {
                if ([model.data isKindOfClass:[NSArray class]]) {
                    block ([LogListModel addObjData:model.data],nil, nil);
                }else if ([model.data isKindOfClass:[NSDictionary class]]){
                    NSArray *arr = model.data[@"lists"];
                    if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
                        block ([LogListModel addObjData:arr] , [LogListModel pageData:model.data[@"page"]] , nil);
                    }else{
                        block (@[], nil,nil); //请求成功，但是已经没有更多数据返回
                    }
                }
            }else{
                block ( nil , nil, model.message);
            }
        }
    }];

}

//我的日志列表
+ (void)loadMyBlogListData:(NSInteger)page block:(ListDataBlock)block {
  
    NSLog(@"TOKEN,USERID ===%@   %@   ",TOKEN,USERID);
    
    [BaseNetworking mHttpWithUrl:kMyBlogList parameter:@{@"token":TOKEN,@"uid":USERID,@"page":@(page)}  response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block ( nil , nil , netErr );
        }else{
            if ( model.status == 1) {
                if ([model.data isKindOfClass:[NSArray class]]) {
                    block ([LogListModel addObjData:model.data],nil, nil);
                }else if ([model.data isKindOfClass:[NSDictionary class]]){
                    NSArray *arr = model.data[@"lists"];
                    if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
                        block ([LogListModel addObjData:arr] , [LogListModel pageData:model.data[@"page"]] , nil);
                    }else{
                        block (@[], nil,nil); //请求成功，但是已经没有更多数据返回
                    }
                } else {
                    block (@[], nil,nil); //请求成功，但是已经没有更多数据返回
                }
            } else if (0 == model.status && [model.message isEqualToString:@"沒有更多數據"]) {
                block (@[], nil, nil);
            } else {
                block ( nil , nil, page==1 ? @"沒有更多數據" : model.message);
            }
        }
    }];
}

//好友日志列表
+ (void)loadMyFriendBlogListData:(NSInteger)page block:(ListDataBlock)block {
    //默認fuid = 0 是查看全部好友的日志，具體fuid可以查看對應好友的日志列表fuid
    
    NSLog(@"TOKEN,USERID ===%@   %@   ",TOKEN,USERID);
    [BaseNetworking mHttpWithUrl:kMyFriendBlogList parameter:@{@"token":TOKEN,@"fuid":@(0),@"page":@(page)} response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block ( nil , nil , netErr );
        }else{
            if (model.status == 1) {
                if ([model.data isKindOfClass:[NSArray class]]) {
                    block ([LogListModel addObjData:model.data],nil, nil);
                }else if ([model.data isKindOfClass:[NSDictionary class]]){
                    NSArray *arr = model.data[@"lists"];
                    if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
                        block ([LogListModel addObjData:arr] , [LogListModel pageData:model.data[@"page"]] , nil);
                    } else {
                        block (@[], nil,nil); //请求成功，但是已经没有更多数据返回
                    }
                } else {
                    block (@[], nil,nil); //请求成功，但是什么都没有
                }
            } else if (0 == model.status && [model.message hasPrefix:@"沒有更多"]) {
                block (@[], nil, nil);
            } else{
                block ( nil , nil, page==1 ? @"沒有更多數據" : model.message);
            }
        }
    }];
}

+ (NSArray *)addObjData:(NSArray *)data {
    NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:data.count];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LogListModel *logList = [LogListModel new];
        [logList setValuesForKeysWithDictionary:obj];
        if (![logList.subject isEqualToString:@"培道、迦南點揀"]) {
            [dataList addObject:logList];
        }
    }];
    return dataList;
}


+ (NSArray *)uniteListData:(NSArray <LogListModel *> *)data {
    NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:data.count];
    __block NSInteger row = 0, space = 0;
    [data enumerateObjectsUsingBlock:^(LogListModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        space ++;
        LogListModel *logList = (LogListModel *)obj;
        [dataList addObject:logList];
    }];
    
    return dataList;
}

+ (LogListPage *)pageData:(NSDictionary *)data{
    LogListPage *page = [[LogListPage alloc] init];
    [page setValuesForKeysWithDictionary:data];
    return page;
}



- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"message"]) {
        self.mesg = value;
        CGRect rect = [self mLayoutContext:self.mesg bounds:CGSizeMake(kSCREEN_WIDTH - 80 , 65) textFont:17.f];
        self.height = rect.size.height;
        
    }
}

@end

/*
@implementation BlogTypeList

+ (void)getBlogTypeListBlock:(BlogTypeBlock)block{
    [BaseNetworking mHttpWithUrl:kBlogTypeList parameter:nil response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block ( nil , netErr );
        }else{
            if ( model.status == 1) {
                if ([model.data isKindOfClass:[NSArray class]]) {
                    block ([BlogTypeList addObjData:model.data], nil);
                }else if ([model.data isKindOfClass:[NSDictionary class]]){
                    NSArray *arr = model.data[@"lists"];
                    if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
                        block ([BlogTypeList addObjData:arr], nil);
                    }else{
                        block (@[], nil); //请求成功，但是已经没有更多数据返回
                    }
                }
            }else{
                block ( nil , model.message);
            }
        }
    }];

}

+ (NSArray *)addObjData:(NSArray *)data{
    NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:data.count];
    BlogTypeList *logAll = [BlogTypeList new];
    logAll.catid = 0;
    logAll.catname = @"全部";
    [dataList addObject:logAll];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BlogTypeList *logList = [BlogTypeList new];
        [logList setValuesForKeysWithDictionary:obj];
        [dataList addObject:logList];
    }];
    return dataList;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    //encode properties/values
    [aCoder encodeObject:@(self.catid) forKey:@"catid"];
    [aCoder encodeObject:self.catname forKey:@"catname"];
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super init])) {
        //decode properties/values
        self.catid = [[aDecoder decodeObjectForKey:@"catid"] integerValue];
        self.catname = [aDecoder decodeObjectForKey:@"catname"];
    }
    return self;
    
}
- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
}
#pragma mark KVC 安全设置
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"%s",__func__);
}
- (void)setNilValueForKey:(NSString *)key
{
    //NSLog(@"%s",__func__);
}

@end

*/
