//
//  FriendModel.m
//  BKMobile
//
//  Created by ligb on 16/5/26.
//  Copyright © 2016年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
}

#pragma mark KVC 安全设置
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%s",__func__);
}
- (void)setNilValueForKey:(NSString *)key
{
    NSLog(@"%s",__func__);
}

@end
