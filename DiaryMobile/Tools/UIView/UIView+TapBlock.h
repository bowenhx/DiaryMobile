/**
 -  UIView+TapBlock.h
 -  BKSDK
 -  Created by HY on 16/12/22.
 -  Copyright © 2016年 BaByKingdom. All rights reserved.
 -  UIView的扩充类，快捷添加点击，长按手势，使用block回调块处理点击
 */
#import <UIKit/UIKit.h>

@interface UIView (TapBlock)

/**
 *  添加tap手势
 *
 *  @param block 点击view的事件处理
 */
- (void)setTapActionBlock:(void (^)(void))block;


/**
 *  添加长按手势
 *
 *  @param block 代码块
 */
- (void)addLongPressActionBlock:(void (^)(void))block;


@end
