//
//  HTHorizontalSelectionList.m
//  Hightower
//
//  Created by Erik Ackermann on 7/31/14.
//  Copyright (c) 2014 Hightower Inc. All rights reserved.
//

#import "HTHorizontalSelectionList.h"
#import "HTHorizontalSelectionListLabelCell.h"
#import "HTHorizontalSelectionListCustomViewCell.h"

@interface HTHorizontalSelectionList () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) UIView *selectionIndicatorBar;
@property (nonatomic, strong) UIView *bottomTrim;

@property (nonatomic, strong) NSMutableDictionary *titleColorsByState;
@property (nonatomic, strong) NSMutableDictionary *titleFontsByState;

@property (nonatomic, strong) UIView *edgeFadeGradientView;

@end

#define kHTHorizontalSelectionListHorizontalMargin 8

#define kHTHorizontalSelectionListSelectionIndicatorHeight 2
#define kHTHorizontalSelectionListTrimHeight 0.5

static NSString *LabelCellIdentifier = @"LabelCell";
static NSString *ViewCellIdentifier = @"ViewCell";

@implementation HTHorizontalSelectionList

- (void)awakeFromNib {
    [super awakeFromNib];
      [self initViews];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}
- (void)initViews
{
    self.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.canCancelContentTouches = YES;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_collectionView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [_collectionView registerClass:[HTHorizontalSelectionListLabelCell class] forCellWithReuseIdentifier:LabelCellIdentifier];
    [_collectionView registerClass:[HTHorizontalSelectionListCustomViewCell class] forCellWithReuseIdentifier:ViewCellIdentifier];
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    
    CGColorRef outerColor = [[UIColor colorWithWhite:0.0 alpha:1.0] CGColor];
    CGColorRef innerColor = [[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
    
    maskLayer.colors = @[(__bridge id)outerColor,
                         (__bridge id)innerColor,
                         (__bridge id)innerColor,
                         (__bridge id)outerColor];
    
    maskLayer.locations = @[@0.0, @0.04, @0.96, @1.0];
    
    [maskLayer setStartPoint:CGPointMake(0, 0.5)];
    [maskLayer setEndPoint:CGPointMake(1, 0.5)];
    
    maskLayer.bounds = _collectionView.bounds;
    maskLayer.anchorPoint = CGPointZero;
    
    _edgeFadeGradientView = [[UIView alloc] init];
    _edgeFadeGradientView.backgroundColor = self.backgroundColor;
    _edgeFadeGradientView.layer.mask = maskLayer;
    _edgeFadeGradientView.hidden = YES;
    _edgeFadeGradientView.userInteractionEnabled = NO;
    _edgeFadeGradientView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_edgeFadeGradientView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_edgeFadeGradientView]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_edgeFadeGradientView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_edgeFadeGradientView]-trimHeight-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:@{@"trimHeight" : @(kHTHorizontalSelectionListTrimHeight)}
                                                                   views:NSDictionaryOfVariableBindings(_edgeFadeGradientView)]];
    
    [_collectionView addObserver:self
                      forKeyPath:@"contentSize"
                         options:NSKeyValueObservingOptionNew
                         context:NULL];
    
    _contentView = [[UIScrollView alloc] init];
    _contentView.userInteractionEnabled = NO;
    _contentView.scrollsToTop = NO;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_contentView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_contentView)]];
    _bottomTrim = [[UIView alloc] init];
    _bottomTrim.backgroundColor = [UIColor whiteColor];
    _bottomTrim.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_bottomTrim];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomTrim]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_bottomTrim)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomTrim(height)]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:@{@"height" : @(kHTHorizontalSelectionListTrimHeight)}
                                                                   views:NSDictionaryOfVariableBindings(_bottomTrim)]];
    
    _buttonInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleBottomBar;
    _selectionIdicatorAnimationMode = HTHorizontalSelectionIndicatorAnimationModeHeavyBounce;
    
    _selectionIndicatorBar = [[UIView alloc] init];
    _selectionIndicatorBar.translatesAutoresizingMaskIntoConstraints = NO;
    _selectionIndicatorBar.backgroundColor = [UIColor blackColor];
    
    _titleColorsByState = [NSMutableDictionary dictionaryWithDictionary:@{@(UIControlStateNormal) : [UIColor blackColor]}];
    _titleFontsByState = [NSMutableDictionary dictionaryWithDictionary:@{@(UIControlStateNormal) : [UIFont systemFontOfSize:13]}];
    
    _centerAlignButtons = NO;
}
- (void)layoutSubviews {
    [self reloadData];

    [self bringSubviewToFront:self.edgeFadeGradientView];

    [super layoutSubviews];
}

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - Custom Getters and Setters

- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex {
    [self setSelectedButtonIndex:selectedButtonIndex animated:NO];
}

- (void)setSelectionIndicatorColor:(UIColor *)selectionIndicatorColor {
    self.selectionIndicatorBar.backgroundColor = selectionIndicatorColor;

    if (!self.titleColorsByState[@(UIControlStateSelected)]) {
        self.titleColorsByState[@(UIControlStateSelected)] = selectionIndicatorColor;
    }
}

- (UIColor *)selectionIndicatorColor {
    return self.selectionIndicatorBar.backgroundColor;
}

- (void)setBottomTrimColor:(UIColor *)bottomTrimColor {
    self.bottomTrim.backgroundColor = bottomTrimColor;
}

- (UIColor *)bottomTrimColor {
    return self.bottomTrim.backgroundColor;
}

- (void)setBottomTrimHidden:(BOOL)bottomTrimHidden {
    self.bottomTrim.hidden = bottomTrimHidden;
}

- (BOOL)bottomTrimHidden {
    return self.bottomTrim.hidden;
}

- (void)setShowsEdgeFadeEffect:(BOOL)showEdgeFadeEffect {
    self.edgeFadeGradientView.hidden = !showEdgeFadeEffect;
}

- (BOOL)showsEdgeFadeEffect {
    return !self.edgeFadeGradientView.hidden;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];

    self.collectionView.allowsSelection = userInteractionEnabled;
}

#pragma mark - Public Methods

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    self.titleColorsByState[@(state)] = color;
}

- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state {
    self.titleFontsByState[@(state)] = font;
}

- (void)reloadData {
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];

    NSInteger totalButtons = [self.dataSource numberOfItemsInSelectionList:self];

    if (totalButtons < 1) {
        return;
    }

    if (_selectedButtonIndex > totalButtons - 1) {
        _selectedButtonIndex = -1;
    }

    if (totalButtons > 0 && self.selectedButtonIndex >= 0 && self.selectedButtonIndex < totalButtons) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedButtonIndex inSection:0]];

        ((id<HTHorizontalSelectionListCell>)cell).state = UIControlStateSelected;

        switch (self.selectionIndicatorStyle) {
            case HTHorizontalSelectionIndicatorStyleBottomBar: {
                [self.contentView addSubview:self.selectionIndicatorBar];
                [self.contentView layoutIfNeeded];
                [self alignSelectionIndicatorWithCell:cell];
                break;
            }

            case HTHorizontalSelectionIndicatorStyleButtonBorder: {
                if ([self.delegate respondsToSelector:@selector(selectionList:viewForItemWithIndex:)]) {
                    ((HTHorizontalSelectionListCustomViewCell *)cell).customView.layer.borderColor = self.selectionIndicatorColor.CGColor;
                } else {
                    cell.layer.borderColor = self.selectionIndicatorColor.CGColor;
                }
                break;
            }

            default:
                break;
        }
    }

    [self sendSubviewToBack:self.bottomTrim];

    [self updateConstraintsIfNeeded];
}

- (void)setSelectedButtonIndex:(NSInteger)selectedButtonIndex animated:(BOOL)animated {

    NSInteger buttonCount = [self.dataSource numberOfItemsInSelectionList:self];

    NSInteger oldSelectedIndex = _selectedButtonIndex;
    if (selectedButtonIndex < buttonCount && selectedButtonIndex >= 0) {
        _selectedButtonIndex = selectedButtonIndex;
    } else {
        _selectedButtonIndex = -1;
    }

    UICollectionViewCell *oldSelectedCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:oldSelectedIndex
                                                                                                            inSection:0]];

    UICollectionViewCell *selectedCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedButtonIndex
                                                                                                         inSection:0]];

    [self layoutIfNeeded];
    [UIView animateWithDuration:animated ? 0.4 : 0.0
                          delay:0
         usingSpringWithDamping:[self selectionIndicatorBarSpringDamping]
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setupSelectedCell:selectedCell oldSelectedCell:oldSelectedCell];
                     }
                     completion:nil];

    if (selectedCell) {
        [self.collectionView scrollRectToVisible:CGRectInset(selectedCell.frame, -kHTHorizontalSelectionListHorizontalMargin, 0)
                                        animated:animated];
    }
}

#pragma mark - UICollectionViewDataSource Protocol Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInSelectionList:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;

    if ([self.dataSource respondsToSelector:@selector(selectionList:viewForItemWithIndex:)]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:ViewCellIdentifier
                                                         forIndexPath:indexPath];

        [((HTHorizontalSelectionListCustomViewCell *)cell) setCustomView:[self.dataSource selectionList:self viewForItemWithIndex:indexPath.item]
                                                                  insets:self.buttonInsets];
    } else if ([self.dataSource respondsToSelector:@selector(selectionList:titleForItemWithIndex:)]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:LabelCellIdentifier
                                                         forIndexPath:indexPath];

        ((HTHorizontalSelectionListLabelCell *)cell).title = [self.dataSource selectionList:self titleForItemWithIndex:indexPath.item];

        for (NSNumber *controlState in [self.titleColorsByState allKeys]) {
            [((HTHorizontalSelectionListLabelCell *)cell) setTitleColor:self.titleColorsByState[controlState]
                                                               forState:controlState.integerValue];
        }

        for (NSNumber *controlState in [self.titleFontsByState allKeys]) {
            [((HTHorizontalSelectionListLabelCell *)cell) setTitleFont:self.titleFontsByState[controlState]
                                                              forState:controlState.integerValue];
        }
    }

    if (self.selectionIndicatorStyle == HTHorizontalSelectionIndicatorStyleButtonBorder) {
        if ([self.delegate respondsToSelector:@selector(selectionList:viewForItemWithIndex:)]) {
            ((HTHorizontalSelectionListCustomViewCell *)cell).customView.layer.borderWidth = 1.0;
            ((HTHorizontalSelectionListCustomViewCell *)cell).customView.layer.cornerRadius = 3.0;
            ((HTHorizontalSelectionListCustomViewCell *)cell).customView.layer.borderColor = [UIColor clearColor].CGColor;
            ((HTHorizontalSelectionListCustomViewCell *)cell).customView.layer.masksToBounds = YES;
        } else {
            cell.layer.borderWidth = 1.0;
            cell.layer.cornerRadius = 3.0;
            cell.layer.borderColor = [UIColor clearColor].CGColor;
            cell.layer.masksToBounds = YES;
        }
    }
    
    //ek3.0日志列表页面定制
    if (self.selectionIndicatorStyle == HTHorizontalSelectionIndicatorStyleButtonCustomRound) {
        if ([self.delegate respondsToSelector:@selector(selectionList:viewForItemWithIndex:)]) {
            ((HTHorizontalSelectionListCustomViewCell *)cell).customView.layer.cornerRadius = 15.0;
            ((HTHorizontalSelectionListCustomViewCell *)cell).customView.layer.borderColor = [UIColor clearColor].CGColor;
            ((HTHorizontalSelectionListCustomViewCell *)cell).customView.layer.masksToBounds = YES;
        } else {
            cell.layer.borderColor = [UIColor clearColor].CGColor;
            cell.layer.masksToBounds = YES;
        }
    }
    

    if (indexPath.item == self.selectedButtonIndex) {
        ((id<HTHorizontalSelectionListCell>)cell).state = UIControlStateSelected;
    } else {
        ((id<HTHorizontalSelectionListCell>)cell).state = UIControlStateNormal;
    }

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout Protocol Methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat verticalPadding = self.buttonInsets.top + self.buttonInsets.bottom;
    CGFloat horizontalPadding = self.buttonInsets.left + self.buttonInsets.right;

    if ([self.dataSource respondsToSelector:@selector(selectionList:viewForItemWithIndex:)]) {
        UIView *view = [self.dataSource selectionList:self viewForItemWithIndex:indexPath.item];

        CGFloat buttonHeight = view.frame.size.height;
        CGFloat buttonWidth = view.frame.size.width;

        CGFloat itemHeight = MIN(self.frame.size.height, buttonHeight + verticalPadding);

        if (buttonHeight) {
            CGFloat scaleFactor = (itemHeight - verticalPadding) / buttonHeight;

            CGFloat itemWidth = (buttonWidth * scaleFactor) + horizontalPadding;

            return CGSizeMake(itemWidth, itemHeight);
        } else {
            return CGSizeMake(buttonWidth, buttonHeight);
        }
    } else if ([self.dataSource respondsToSelector:@selector(selectionList:titleForItemWithIndex:)]) {
        NSString *title = [self.dataSource selectionList:self titleForItemWithIndex:indexPath.item];
        CGSize titleSize = [HTHorizontalSelectionListLabelCell sizeForTitle:title withFont:self.titleFontsByState[@(UIControlStateNormal)]];

        CGFloat width = titleSize.width + horizontalPadding;
        CGFloat height = MIN(titleSize.height + verticalPadding,
                             collectionView.frame.size.height - self.buttonInsets.top - self.buttonInsets.bottom);

        return CGSizeMake(width, height);
    }

    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {

    if (self.centerAlignButtons) {
        NSInteger numberOfItems = [self.dataSource numberOfItemsInSelectionList:self];

        CGFloat interitemSpacing = collectionView.frame.size.width - 2*kHTHorizontalSelectionListHorizontalMargin;

        for (NSInteger item = 0; item < numberOfItems; item++) {
            interitemSpacing -= [self collectionView:collectionView
                                              layout:collectionViewLayout
                              sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]].width;

            if (interitemSpacing < 0) {
                break;
            }
        }

        if (interitemSpacing > 0 && numberOfItems > 0) {
            CGFloat inset = (interitemSpacing / (2 * numberOfItems)) + kHTHorizontalSelectionListHorizontalMargin;

            return UIEdgeInsetsMake(0, inset, 0, inset);
        }
    }

    return UIEdgeInsetsMake(0, kHTHorizontalSelectionListHorizontalMargin, 0, kHTHorizontalSelectionListHorizontalMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    if (self.centerAlignButtons) {
        NSInteger numberOfItems = [self.dataSource numberOfItemsInSelectionList:self];

        CGFloat interitemSpacing = collectionView.frame.size.width - 2*kHTHorizontalSelectionListHorizontalMargin;

        for (NSInteger item = 0; item < numberOfItems; item++) {
            interitemSpacing -= [self collectionView:collectionView
                                              layout:collectionViewLayout
                              sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]].width;

            if (interitemSpacing < 0) {
                break;
            }
        }

        if (interitemSpacing > 0 && numberOfItems > 0) {
            return interitemSpacing / numberOfItems;
        }
    }

    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.selectedButtonIndex) {
        if (self.selectionIndicatorStyle == HTHorizontalSelectionIndicatorStyleNone) {
            if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {
                [self.delegate selectionList:self didSelectButtonWithIndex:indexPath.item];
            }
        }

        return;
    }

    [self setSelectedButtonIndex:indexPath.item animated:YES];

    if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {
        [self.delegate selectionList:self didSelectButtonWithIndex:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    id<HTHorizontalSelectionListCell> cell = (id<HTHorizontalSelectionListCell>)[collectionView cellForItemAtIndexPath:indexPath];

    if (cell.state == UIControlStateSelected && self.selectionIndicatorStyle == HTHorizontalSelectionIndicatorStyleNone) {
        cell.state = UIControlStateHighlighted;
    } else if (cell.state != UIControlStateSelected) {
        cell.state = UIControlStateHighlighted;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    id<HTHorizontalSelectionListCell> cell = (id<HTHorizontalSelectionListCell>)[collectionView cellForItemAtIndexPath:indexPath];

    if (self.selectedButtonIndex == indexPath.item) {
        cell.state = UIControlStateSelected;
    } else {
        cell.state = UIControlStateNormal;
    }
}
#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGPoint offset = self.contentView.contentOffset;
        offset.x = scrollView.contentOffset.x;
        [self.contentView setContentOffset:offset];
    }
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.contentView.contentSize = [(NSValue *)change[NSKeyValueChangeNewKey] CGSizeValue];
    }
}

#pragma mark - Private Methods

- (void)setupSelectedCell:(UICollectionViewCell *)selectedCell oldSelectedCell:(UICollectionViewCell *)oldSelectedCell {
    ((id<HTHorizontalSelectionListCell>)selectedCell).state = UIControlStateSelected;
    ((id<HTHorizontalSelectionListCell>)oldSelectedCell).state = UIControlStateNormal;

    switch (self.selectionIndicatorStyle) {
        case HTHorizontalSelectionIndicatorStyleBottomBar: {
            [self layoutIfNeeded];
            [self alignSelectionIndicatorWithCell:selectedCell];
            break;
        }

        case HTHorizontalSelectionIndicatorStyleButtonBorder: {
            if ([self.delegate respondsToSelector:@selector(selectionList:viewForItemWithIndex:)]) {
                ((HTHorizontalSelectionListCustomViewCell *)selectedCell).customView.layer.borderColor = self.selectionIndicatorColor.CGColor;
                ((HTHorizontalSelectionListCustomViewCell *)oldSelectedCell).customView.layer.borderColor = [UIColor clearColor].CGColor;
            } else {
                selectedCell.layer.borderColor = self.selectionIndicatorColor.CGColor;
                oldSelectedCell.layer.borderColor = [UIColor clearColor].CGColor;
            }
            break;
        }

        case HTHorizontalSelectionIndicatorStyleNone: {
            selectedCell.layer.borderColor = [UIColor clearColor].CGColor;
            oldSelectedCell.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

- (void)alignSelectionIndicatorWithCell:(UICollectionViewCell *)cell {
    NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:cell];

    if (selectedIndexPath) {
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:selectedIndexPath];
        CGRect cellRect = attributes.frame;

        self.selectionIndicatorBar.frame = CGRectMake(cellRect.origin.x + self.buttonInsets.left,
                                                      self.contentView.frame.size.height - kHTHorizontalSelectionListSelectionIndicatorHeight,
                                                      cellRect.size.width - self.buttonInsets.left - self.buttonInsets.right,
                                                      kHTHorizontalSelectionListSelectionIndicatorHeight);
    }
}

- (CGFloat)selectionIndicatorBarSpringDamping {
    switch (self.selectionIdicatorAnimationMode) {
        case HTHorizontalSelectionIndicatorAnimationModeHeavyBounce:
        default:
            return 0.5;

        case HTHorizontalSelectionIndicatorAnimationModeLightBounce:
            return 0.8;

        case HTHorizontalSelectionIndicatorAnimationModeNoBounce:
            return 1.0;
    }
}

@end
