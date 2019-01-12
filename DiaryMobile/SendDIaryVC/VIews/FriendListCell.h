//
//  FriendListCell.h
//  BKMobile
//
//  Created by 薇 颜 on 15/8/29.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FriendListCellDelegate <NSObject>
@optional

//删除按钮点击事件
- (void)friendListCellDeleteButtonClick:(NSIndexPath *)indexPath;
@end


@interface FriendListCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UIImageView *avatarImageView;/**<头像图片*/
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;/**<名字*/
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;/**<等级*/
@property (weak, nonatomic) IBOutlet UIButton *delFriendBtn;/**<解除好友关系的按钮*/
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<FriendListCellDelegate> delegate;

@end
