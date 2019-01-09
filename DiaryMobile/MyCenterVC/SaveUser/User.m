/**
 -  User.m
 -  BKSDK
 -  Created by HY on 16/11/24.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import "User.h"

@implementation User


#pragma mark - 编码 对user属性进行编码处理
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.adminid forKey:@"adminid"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.groupid forKey:@"groupid"];
    [aCoder encodeObject:self.grouptitle forKey:@"grouptitle"];
    [aCoder encodeObject:self.loginovertime forKey:@"loginovertime"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.groups forKey:@"groups"];
}


#pragma mark - 解码 解码归档数据来初始化对象
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.adminid = [aDecoder decodeObjectForKey:@"adminid"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.groupid = [aDecoder decodeObjectForKey:@"groupid"];
        self.grouptitle = [aDecoder decodeObjectForKey:@"grouptitle"];
        self.loginovertime = [aDecoder decodeObjectForKey:@"loginovertime"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.groups = [aDecoder decodeObjectForKey:@"groups"];
    }
    return self;
}


#pragma mark - 属性赋值
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
