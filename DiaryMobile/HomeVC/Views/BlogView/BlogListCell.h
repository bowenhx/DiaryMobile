/**
 -  BlogListCell.h
 -  EKHKAPP
 -  Created by HY on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：日志列表cell
 */

#import <UIKit/UIKit.h>
#import "LogListModel.h"

typedef NS_ENUM(NSInteger, EKBlogCellType) {
    EKBlogCellTypeWithNormalBlog, //普通的日志列表，首页日志模块cell
    EKBlogCellTypeWithMyBlog,     //我的日志列表
};

@interface BlogListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImg;

@property (weak, nonatomic) IBOutlet UIButton *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UIButton *userName;

@property (weak, nonatomic) IBOutlet UILabel *readNum;

@property (weak, nonatomic) IBOutlet UILabel *reviewNum;

@property (weak, nonatomic) IBOutlet UILabel *linBg;

@property (weak, nonatomic) IBOutlet UILabel *labCaution;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWithConstraint;



@property (nonatomic , strong) LogListModel *listData;

- (void)mRefreshBlogCell:(LogListModel *)listData type:(EKBlogCellType)type;

@end
