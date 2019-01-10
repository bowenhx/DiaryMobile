/**
 -  BKCustomPickerView.h
 -  BKHKAPP
 -  Created by ligb on 2017/9/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BKCustomPickerView;

typedef void(^ActionStringDoneBlock)(NSInteger selectedIndex, id selectedValue);
typedef void(^ActionStringCancelBlock)(void);

@interface BKCustomPickerView : UIView

@property (nonatomic, copy)   ActionStringDoneBlock   onActionSheetDone;
@property (nonatomic, copy)   ActionStringCancelBlock onActionSheetCancel;
@property (nonatomic, strong) UIView    *headerView;
@property (nonatomic, strong) UIButton  *leftButton;
@property (nonatomic, strong) UIButton  *rightButton;


/**
 pickerView

 @param color header color
 @param title 标题
 @param count 有几个Components
 @param data  数据源
 @param key1  一级key
 @param key2  二级key
 @param index 默认选中
 @param doneBlock 回调block
 @param cancelBlock 回调
 @param supView 需要显示的supView
 @return pickerView
 
 使用样例：
 [BKCustomPickerView showPickerViewHeaderColor:[UIColor blackColor] title:@"标题" displayCount:1 datas:threadtypes forKey1:nil forKey2:nil defineSelect:0 doneBlock:^(NSInteger selectedIndex, id selectedValue) {
    NSLog(@"inde = %zd, value = %@",selectedIndex,selectedValue);
 } cancelBlock:^{
 
 } supView:vc.view];
 
 */
+ (instancetype)showPickerViewHeaderColor:(UIColor *)color
                                    title:(NSString *)title
                             displayCount:(NSInteger)count
                                    datas:(NSArray *)data
                                  forKey1:(NSString *)key1
                                  forKey2:(NSString *)key2
                             defineSelect:(NSInteger)index
                                doneBlock:(ActionStringDoneBlock)doneBlock
                              cancelBlock:(ActionStringCancelBlock)cancelBlock
                                  supView:(UIView *)supView;

- (void)showPickerView;

- (void)hiddenPickerView;

@end
