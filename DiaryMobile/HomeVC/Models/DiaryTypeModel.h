//
//  DiaryTypeModel.h
//  DiaryMobile
//
//  Created by ligb on 2019/1/18.
//  Copyright © 2019 com.professional.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BlogTypeBlock)(NSArray *data , NSString *netErr);

@interface DiaryTypeModel : NSObject

@property (nonatomic , assign) NSInteger catid;
@property (nonatomic , copy) NSString *catname;

+ (void)getBlogTypeListBlock:(BlogTypeBlock)block;

@end

NS_ASSUME_NONNULL_END
