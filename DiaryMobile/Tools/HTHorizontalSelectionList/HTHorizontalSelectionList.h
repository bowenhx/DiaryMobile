//
//  HTHorizontalSelectionList.h
//  Hightower
//
//  Created by Erik Ackermann on 7/31/14.
//  Copyright (c) 2014 Hightower Inc. All rights reserved.
//

@import UIKit;

@protocol HTHorizontalSelectionListDataSource;
@protocol HTHorizontalSelectionListDelegate;

typedef NS_ENUM(NSInteger, HTHorizontalSelectionIndicatorStyle) {
    HTHorizontalSelectionIndicatorStyleBottomBar,           // Default
    HTHorizontalSelectionIndicatorStyleButtonBorder,
    HTHorizontalSelectionIndicatorStyleButtonCustomRound,   //椭圆类型
    HTHorizontalSelectionIndicatorStyleNone
};

typedef NS_ENUM(NSInteger, HTHorizontalSelectionIndicatorAnimationMode) {
    HTHorizontalSelectionIndicatorAnimationModeHeavyBounce,     // Default
    HTHorizontalSelectionIndicatorAnimationModeLightBounce,
    HTHorizontalSelectionIndicatorAnimationModeNoBounce
};

@interface HTHorizontalSelectionList : UIView

@property (nonatomic) NSInteger selectedButtonIndex;        // returns selected button index. -1 if nothing selected
                                                            // to animate this change, use `-setSelectedButtonIndex:animated:`
                                                            // NOTE: this value will persist between calls to `-reloadData`

@property (nonatomic, weak) id<HTHorizontalSelectionListDataSource> dataSource;
@property (nonatomic, weak) id<HTHorizontalSelectionListDelegate> delegate;

@property (nonatomic, strong) UIColor *selectionIndicatorColor;
@property (nonatomic, strong) UIColor *bottomTrimColor;
@property (nonatomic) BOOL bottomTrimHidden;                // Default is NO
@property (nonatomic) BOOL centerAlignButtons;              // Default is NO.  Only has an affect if the number of buttons in
                                                            // the selection list does not fill the space horizontally.

@property (nonatomic) BOOL showsEdgeFadeEffect;             // Default is NO.  If set to YES, the buttons will fade away near the edges of the list.

@property (nonatomic) HTHorizontalSelectionIndicatorAnimationMode selectionIdicatorAnimationMode;

@property (nonatomic) UIEdgeInsets buttonInsets;

@property (nonatomic) HTHorizontalSelectionIndicatorStyle selectionIndicatorStyle;

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state;

- (void)reloadData;

- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex animated:(BOOL)animated;

@end

@protocol HTHorizontalSelectionListDataSource <NSObject>

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList;

@optional
- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index;
- (UIView *)selectionList:(HTHorizontalSelectionList *)selectionList viewForItemWithIndex:(NSInteger)index;

@end

@protocol HTHorizontalSelectionListDelegate <NSObject>

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index;

@end
