//
//  FriendListCell.m
//  BKMobile
//
//  Created by 薇 颜 on 15/8/29.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FriendListCell.h"

@implementation FriendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionDelFriend:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(friendListCellDeleteButtonClick:)]) {
        [self.delegate friendListCellDeleteButtonClick:_indexPath];
    }
    
}

@end
