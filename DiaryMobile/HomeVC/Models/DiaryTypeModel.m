//
//  DiaryTypeModel.m
//  DiaryMobile
//
//  Created by ligb on 2019/1/18.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import "DiaryTypeModel.h"
#import "kDefine.h"

@implementation DiaryTypeModel
+ (void)getBlogTypeListBlock:(BlogTypeBlock)block{
    [BaseNetworking mHttpWithUrl:kBlogTypeList parameter:nil response:^(BKNetworkModel *model, NSString *netErr) {
        if ( netErr ) {
            block ( nil , netErr );
        }else{
            if ( model.status == 1) {
                if ([model.data isKindOfClass:[NSArray class]]) {
                    block ([DiaryTypeModel mAddObjData:model.data], nil);
                }else if ([model.data isKindOfClass:[NSDictionary class]]){
                    NSArray *arr = model.data[@"lists"];
                    if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
                        block ([DiaryTypeModel mAddObjData:arr], nil);
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

+ (NSArray *)mAddObjData:(NSArray *)data {
    NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:data.count];
    DiaryTypeModel *logAll = [DiaryTypeModel new];
    logAll.catid = 0;
    logAll.catname = @"全部";
    [dataList addObject:logAll];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dataList addObject:[DiaryTypeModel yy_modelWithJSON:obj]];
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

@end
