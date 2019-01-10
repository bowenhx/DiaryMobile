//
//  BaseItemView.h
//  EduKingdom
//
//  Created by ligb on 16/7/5.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadLineView : UIView
@property (nonatomic , strong) UIImageView *imageLine; //波浪线
@end

@interface HeadItemView : UIView

//点击事件传递block
@property (nonatomic , copy) void (^ itemsEventAction)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (void)addItemTitle:(NSArray *)titles;


@end

@interface CustomItemView : UIView

//可以通过外面更改scrolview属性
@property (nonatomic , strong) UIScrollView *scrollView;

//记录当前选中的item
@property (nonatomic , assign) NSInteger itemIndex;

//滑动或者是点击事件block
@property (nonatomic , copy) void (^itemsEcentAction)(NSInteger index);

//views 对象及item 对应的名字，即可组装相应的滑动页面 最后height表示当前view 高度
- (void)addItemView:(NSArray *)views title:(NSArray *)titles height:(float)height;

@end
