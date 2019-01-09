//
//  NSObject+Layout.h
//  EduKingdom
//
//  Created by ligb on 2018/9/3.
//  Copyright © 2018年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Layout)
//计算size
- (CGRect)mLayoutContext:(NSString *)context
                  bounds:(CGSize)size
                textFont:(float)font;

@end
