//  CustomScrollerHeadView.m
//
//  Created by ligb on 2017/1/11.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//
#define ITEM_BY  8
#define ITEM_BW  80    //item  button width
#define ITEM_BH  30     //item  button height
#define HEAD_H   40     // head View height
#define LINE_H   12     // head View line height
#define ITEMCOLOR  @"#808080".color


#import "CustomScrollerHeadView.h"
#import "KDefine.h"
@interface CustomHeadView : UIView
@property (nonatomic , strong) UILabel *itemLab;
@end

@implementation CustomHeadView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemLab.text = title;
        [_itemLab setX:title.length > 2 ? -15 : -10];
    }
    return self;
}

- (UILabel *)itemLab{
    if (!_itemLab) {
        _itemLab = [[UILabel alloc] initWithFrame:self.bounds];
        _itemLab.textColor = ITEMCOLOR;
        _itemLab.font = [UIFont systemFontOfSize:15];
        _itemLab.textAlignment = NSTextAlignmentCenter;
        [_itemLab setY:-5];
        [self addSubview:_itemLab];
    }
    return _itemLab;
}


@end


@interface CustomScrollerHeadView()<UIScrollViewDelegate,HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate>
{
    
}
@property (nonatomic , strong) HTHorizontalSelectionList *headView;
@property (nonatomic , strong) NSMutableArray *items;

@end


@implementation CustomScrollerHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headView).offset(HEAD_H + LINE_H);
            make.left.right.bottom.equalTo(self);
        }];
        
    }
    return _scrollView;
}

- (HTHorizontalSelectionList *)headView {
    if (!_headView) {
        _headView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, self.screen_W, HEAD_H)];
        _headView.delegate = self;
        _headView.dataSource = self;
        _headView.selectedButtonIndex = 100;

        _headView.selectionIdicatorAnimationMode = HTHorizontalSelectionIndicatorStyleButtonBorder;
        _headView.selectionIndicatorStyle = HTHorizontalSelectionIndicatorAnimationModeLightBounce;

        _headView.selectionIndicatorColor = kViewNormalBackColor.color;
        [_headView setTitleFont:[UIFont systemFontOfSize:15] forState:UIControlStateNormal];
        [_headView setTitleFont:[UIFont boldSystemFontOfSize:15] forState:UIControlStateSelected];
        [_headView setTitleFont:[UIFont boldSystemFontOfSize:15] forState:UIControlStateHighlighted];

        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, _headView.h, self.screen_W, LINE_H);
        view.backgroundColor = kViewNormalBackColor.color;

        [self addSubview:_headView];
        [self addSubview:view];
    }
    return _headView;
}

- (void)addItemView:(NSArray *)views title:(NSArray *)titles height:(float)height{
    _items = [NSMutableArray arrayWithCapacity:titles.count];
    for (int i=0;i<titles.count;i++) {
        NSString *length = titles[i];
        float width = length.length > 2 ? 120 : 80;
        CustomHeadView *item = [[CustomHeadView alloc] initWithFrame:CGRectMake(0, 0, width, HEAD_H) title:length];
        if (i == 0) {
            item.itemLab.textColor = [UIColor whiteColor];
            item.itemLab.font = [UIFont systemFontOfSize:17];
            item.backgroundColor = kTabBarColor.color;
        }
        [_items addObject:item];
    }
    
    [self.headView reloadData];
   
    //设置contentSize
    self.scrollView.contentSize = CGSizeMake(self.screen_W * views.count, _scrollView.h);
    
    for (int i= 0; i< views.count; i++) {
        UIView *iView = views[i];
        iView.frame = CGRectMake(i*self.screen_W, 0, self.screen_W, height-HEAD_H-10);
        [_scrollView addSubview:iView];
    }
}

- (void)loadItemsStatus:(NSInteger)index {
    //记录item
    self.itemIndex = index;
    if (_itemsEcentAction) {
        //block 返回item index
        _itemsEcentAction (index);
    }
    
    //改变item title 状态
    for (int i= 0; i< _items.count; i++) {
        CustomHeadView *iView = _items[i];
        if (i == index) {
            iView.itemLab.textColor = [UIColor whiteColor];
            iView.itemLab.font = [UIFont systemFontOfSize:17];
            iView.backgroundColor = kTabBarColor.color;
        } else {
            iView.itemLab.textColor = ITEMCOLOR;
            iView.itemLab.font = [UIFont systemFontOfSize:15];
            iView.backgroundColor = [UIColor clearColor];
        }
    }
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 得到每页宽度
    CGFloat pageWidth = scrollView.screen_W;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //滑动判断如果滑动的page 没有变化就不去改变页面
    if (self.itemIndex == currentPage)
        return;
    
    //改变item 选择状态
    _headView.selectedButtonIndex = currentPage;
    [self loadItemsStatus:currentPage];
}

- (void)mSelectHeadViewIndex:(NSInteger)index {
    //改变item 选择状态
    _headView.selectedButtonIndex = index;
    [self loadItemsStatus:index];
}

#pragma mark
#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods
- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return _items.count;
}

- (UIView *)selectionList:(HTHorizontalSelectionList *)selectionList viewForItemWithIndex:(NSInteger)index{
    return _items[index];
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods
- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(index * self.screen_W, 0) animated:YES];
    [self loadItemsStatus:index];
}

@end
