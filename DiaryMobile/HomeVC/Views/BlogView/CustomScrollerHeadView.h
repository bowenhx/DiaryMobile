//
//  CustomScrollerHeadView.h
//
//  Created by ligb on 2017/1/11.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CustomScrollerHeadView : UIView

//可以通过外面更改scrolview属性
@property (nonatomic , strong) UIScrollView *scrollView;

//记录当前选中的item
@property (nonatomic , assign) NSInteger itemIndex;

//滑动或者是点击事件block
@property (nonatomic , copy) void (^itemsEcentAction)(NSInteger index);

//views 对象及item 对应的名字，即可组装相应的滑动页面 最后height标示当前view 高度
- (void)addItemView:(NSArray *)views title:(NSArray *)titles height:(float)height;


//刷新itemHeadView 选中状态
- (void)mSelectHeadViewIndex:(NSInteger)index;

@end
