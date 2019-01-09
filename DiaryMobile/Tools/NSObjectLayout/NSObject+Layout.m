//
//  NSObject+Layout.m
//  EduKingdom
//
//  Created by ligb on 2018/9/3.
//  Copyright © 2018年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "NSObject+Layout.h"

@implementation NSObject (Layout)

//计算size
- (CGRect)mLayoutContext:(NSString *)context
                  bounds:(CGSize)size
                textFont:(float)font {
    if (!context.length) return CGRectZero;
    return [context boundingRectWithSize:size
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                 context:nil];
}


@end
