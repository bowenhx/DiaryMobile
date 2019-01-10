/**
 -  BKCustomPickerView.m
 -  BKHKAPP
 -  Created by ligb on 2017/9/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKCustomPickerView.h"
#import "KDefine.h"

NSString * const CancelTitel = @"取消";
NSString * const DoneTitle   = @"確定";

@interface BKCustomPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView  *pickerView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, copy)   NSArray       *data;
@property (nonatomic, assign) NSInteger     displayCount;      //display count
@property (nonatomic, assign) NSInteger     endSelectedIndex;  //end selected
@property (nonatomic, assign) NSInteger     selectedIndex;     //begin selected
@property (nonatomic, copy)   NSString      *key1;             // display stair key
@property (nonatomic, copy)   NSString      *key2;             // display tow key

@end

@implementation BKCustomPickerView

+ (instancetype)showPickerViewHeaderColor:(UIColor *)color title:(NSString *)title displayCount:(NSInteger)count datas:(NSArray *)data  forKey1:(NSString *)key1 forKey2:(NSString *)key2 defineSelect:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlock supView:(UIView *)supView {
    BKCustomPickerView *pickerView = [[BKCustomPickerView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 260)];
    pickerView.titleLabel.text = title;
    [pickerView setHeaderBackgroundColor:color];
    pickerView.onActionSheetDone = doneBlock;
    pickerView.onActionSheetCancel = cancelBlock;
    pickerView.key1 = key1;
    pickerView.key2 = key2;
    pickerView.data = data;
    pickerView.displayCount = count;
    pickerView.endSelectedIndex = index;
    if ([supView isKindOfClass:[UIView class]]) {
        [supView addSubview:pickerView];
    }
    [pickerView showPickerView];
    return pickerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectedIndex = 0;
        [self addItemView];
    }
    return self;
}

- (void)setHeaderBackgroundColor:(UIColor *)color {
    for (UIView *iView in self.headerView.subviews) {
        iView.backgroundColor = color;
    }
}

- (void)addItemView {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.w, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    
    //左边item
    _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _leftButton.frame = CGRectMake(0, 0, 60, 44);
    [_leftButton setTitle:CancelTitel forState:UIControlStateNormal];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headView addSubview:_leftButton];
    
    //右边item
    _rightButton =  [UIButton buttonWithType:UIButtonTypeSystem];
    _rightButton.frame = CGRectMake(self.w-60, 0, 60, 44);
    [_rightButton setTitle:DoneTitle forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headView addSubview:_rightButton];
    
    [self addSubview:headView];
    self.headerView = headView;
  
    [_leftButton addTarget:self action:@selector(didSelectCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton addTarget:self action:@selector(didSelectDoneAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showPickerView {
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, - self.h);
    }];
    
    [self.pickerView selectRow:self.endSelectedIndex inComponent:0 animated:NO];
    [self.pickerView reloadAllComponents];
}

- (void)hiddenPickerView {
    [UIView animateWithDuration:0.35f animations:^{
         self.transform = CGAffineTransformMakeTranslation(0, self.h);
    } completion:^(BOOL finished) {
        self.onActionSheetDone = nil;
        self.onActionSheetCancel = nil;
        [self removeFromSuperview];
    }];
}

- (void)didSelectCancelAction {
    if (_onActionSheetCancel) {
        _onActionSheetCancel();
        [self hiddenPickerView];
    }
}

- (void)didSelectDoneAction {
    if (_onActionSheetDone) {
        if (self.displayCount == 1) {
            id selectedObject = (self.data.count > 0) ? (self.data)[(NSUInteger) self.endSelectedIndex] : nil;
            _onActionSheetDone(self.endSelectedIndex, selectedObject);
        } else if (self.displayCount == 2){
            NSString *selectedObject = (self.data.count > 0) ? (self.data)[(NSUInteger) self.selectedIndex][_key1]: nil;
            NSString *componentObject = (self.data.count > 0) ? (self.data)[(NSUInteger) self.selectedIndex][_key2][(NSUInteger) self.endSelectedIndex] : nil;
            NSString *object = [NSString stringWithFormat:@"%@,%@",selectedObject,componentObject];
            _onActionSheetDone(self.endSelectedIndex, object);
        }
    }
     [self hiddenPickerView];
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kSCREEN_WIDTH, 216)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
    }
    return _pickerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 0, self.w - 122, 44)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [self.headerView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setData:(NSArray *)data {
    _data = data;
}

- (NSArray *)getCitiesByContinent {
    NSArray *citiesIncontinent = self.data[_selectedIndex][_key2];
    return citiesIncontinent;
}

#pragma  mark PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.displayCount;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.displayCount == 1) {
        return self.data.count;
    } else if (self.displayCount == 2){
        switch (component) {
            case 0:
                return self.data.count;
            case 1:
                return [[self getCitiesByContinent] count];
            default:break;
        }
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.displayCount == 1) {
        id object = self.data[row];
        if ([object isKindOfClass:[NSString class]]) {
            return object;
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            return object[_key1];
        } else {
            NSLog(@"暂时不支持其他类型");
            return @"";
        }
    } else if (self.displayCount == 2){
        switch (component) {
            case 0:
                return self.data[row][_key1];
            case 1:
                return [self getCitiesByContinent][row];
            default:break;
        }
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.displayCount == 1) {
        self.endSelectedIndex = row;
    } else if (self.displayCount == 2) {
        switch (component) {
            case 0:{
                self.selectedIndex = row;
                [pickerView reloadComponent:1];
            }
                break;
            case 1:
                self.endSelectedIndex = row;
                break;
            default:break;
        }
    }
}


@end
