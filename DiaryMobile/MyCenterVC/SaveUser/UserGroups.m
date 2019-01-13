/**
 -  UserGroups.m
 -  BKSDK
 -  Created by ligb on 16/11/24.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 */

#import "UserGroups.h"

@implementation UserGroups



#pragma mark - 编码 对user属性进行编码处理
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.isbanpost forKey:@"isbanpost"];
    [aCoder encodeObject:self.isbanuser forKey:@"isbanuser"];
    [aCoder encodeObject:self.isclosethread forKey:@"isclosethread"];
    [aCoder encodeObject:self.iseditpost forKey:@"iseditpost"];
    [aCoder encodeObject:self.ismanagereport forKey:@"ismanagereport"];
    [aCoder encodeObject:self.ismovethread forKey:@"ismovethread"];
    [aCoder encodeObject:self.isviewip forKey:@"isviewip"];
    [aCoder encodeObject:self.iswarnpost forKey:@"iswarnpost"];
}


#pragma mark - 解码 解码归档数据来初始化对象
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.isbanpost = [aDecoder decodeObjectForKey:@"isbanpost"];
        self.isbanuser = [aDecoder decodeObjectForKey:@"isbanuser"];
        self.isclosethread = [aDecoder decodeObjectForKey:@"isclosethread"];
        self.iseditpost = [aDecoder decodeObjectForKey:@"iseditpost"];
        self.ismanagereport = [aDecoder decodeObjectForKey:@"ismanagereport"];
        self.ismovethread = [aDecoder decodeObjectForKey:@"ismovethread"];
        self.isviewip = [aDecoder decodeObjectForKey:@"isviewip"];
        self.iswarnpost = [aDecoder decodeObjectForKey:@"iswarnpost"];
    }
    return self;
}


//初始化
+(instancetype)mInitGroupsWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}


-(instancetype)initWithDic:(NSDictionary *)dic
{
    if (self == [super init])
    {
        self.isbanpost = dic[@"isbanpost"];
        self.isbanuser = dic[@"isbanuser"];
        self.isclosethread = dic[@"isclosethread"];
        self.iseditpost =dic[@"iseditpost"];
        self.ismanagereport =dic[@"ismanagereport"];
        self.ismovethread =dic[@"ismovethread"];
        self.isviewip =dic[@"isviewip"];
        self.iswarnpost =dic[@"iswarnpost"];
    }
    return self;
}


@end
