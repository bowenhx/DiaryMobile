//
//  BaseItemView.m
//  EduKingdom
//
//  Created by ligb on 16/7/5.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//
#define ITEM_COLOR  @"#35bd6c"  //item select color

#define ITEM_BY  8
#define ITEM_BW  100    //item  button width
#define ITEM_BH  30     //item  button height
#define HEAD_H   55     // head View height
#define LINE_H   15     // head View line height


#import "CustomItemView.h"
#import "KDefine.h"


@implementation HeadLineView

//初始化时高度给15
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addLineView];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self addLineView];
}

- (void)addLineView{
    self.backgroundColor = [UIColor clearColor];
    UIImage *img = [UIImage imageNamed:@"def_iv_Lace"];
    _imageLine = [[UIImageView alloc] initWithImage:img];
    _imageLine.frame = CGRectMake(0, 0, self.screen_W, img.h);
    _imageLine.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageLine];
}

@end


@interface HeadItemView ()

@property (nonatomic , strong) NSMutableArray *items;

- (void)seletItem:(UIButton *)btn;

@end

@implementation HeadItemView

//手动初始化时高度给55
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setView];
        
        [self addItemTitle:titles];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setView];
    }
    return self;
}
- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
// xib 建立view 高度给65
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setView];
}

- (void)setView{
    HeadLineView *lineView = [[HeadLineView alloc] initWithFrame:CGRectMake(0, self.h-LINE_H, self.screen_W, LINE_H)];
    [self addSubview:lineView];
}

- (void)addItemTitle:(NSArray *)titles{
    NSInteger count = titles.count;
    NSInteger itemW = ITEM_BW;
    if (count == 2) {
        itemW += 50;
    }
    float space = (self.screen_W - itemW * count) / (count +1);
    for (int i=0; i < count; i++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.frame = CGRectMake(space + i*(itemW+space), ITEM_BY, itemW, ITEM_BH);
        [itemBtn setTitle:titles[i] forState:0];
        [itemBtn setTitleColor:[UIColor blackColor] forState:0];
        [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        itemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [itemBtn setBackgroundColor:[UIColor clearColor]];
        itemBtn.layer.cornerRadius = 5;
        itemBtn.tag = i;
        [itemBtn addTarget:self action:@selector(seletItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemBtn];
        if (i==0) {
            itemBtn.selected = YES;
        }else{
            itemBtn.selected = NO;
            [itemBtn setBackgroundColor:[UIColor clearColor]];
        }
        
        [self.items addObject:itemBtn];
    }
}


- (void)seletItem:(UIButton *)btn{
    
    for (UIButton *item in self.items) {
        if ([item isEqual:btn]) {
            item.selected = YES;
            [item setBackgroundColor:kTabBarColor.color];
        }else{
            item.selected = NO;
            [item setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    if (_itemsEventAction) {
        _itemsEventAction (btn.tag);
    }
    
}

@end



@interface CustomItemView ()<UIScrollViewDelegate>
{
    HeadItemView *_headView;
}
@end

@implementation CustomItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
      
    }
    return self;
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

        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        //寬度
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
        
        NSString *vFormat = [NSString stringWithFormat:@"V:|-%d-[_scrollView]|",HEAD_H];
        //高度
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    }
    return _scrollView;
}

- (void)addItemView:(NSArray *)views title:(NSArray *)titles height:(float)height{
    _headView = [[HeadItemView alloc] initWithFrame:CGRectMake(0, 0, self.screen_W, HEAD_H)];
    [_headView addItemTitle:titles];
    [self addSubview:_headView];
    
    //设置contentSize
    self.scrollView.contentSize = CGSizeMake(self.screen_W * views.count, _scrollView.h);

    height -= HEAD_H;
    
    for (int i= 0; i< views.count; i++) {
        UIView *iView = views[i];
        iView.frame = CGRectMake(i*self.screen_W, 0, self.screen_W, height);
        [_scrollView addSubview:iView];
    }
    
    //点击item改变对应的页面
    @WeakObj(self);
    _headView.itemsEventAction = ^(NSInteger index){
        selfWeak.itemIndex = index;
        if (views.count >1 ) {
             [selfWeak.scrollView setContentOffset:CGPointMake(index * self.screen_W, 0) animated:YES];
        }
        
        if (selfWeak.itemsEcentAction) {
            selfWeak.itemsEcentAction (index);
        }
    };
}
#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 得到每页宽度
    CGFloat pageWidth = scrollView.screen_W;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //滑动判断如果滑动的page 没有变化就不去改变页面
    if (self.itemIndex == currentPage)
        return;
    
    //改变item 选择状态
    [_headView seletItem:_headView.items[currentPage]];

}

@end



