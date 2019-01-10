/**
 -  BlogListCell.m
 -  EKHKAPP
 -  Created by HY on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：日志列表cell
 */

#import "BlogListCell.h"



@implementation BlogListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.userName setTitleColor:@"#808080".color forState:0];
    self.userIcon.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = 4;
    self.title.textColor = @"#303030".color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)mRefreshBlogCell:(LogListModel *)listData type:(EKBlogCellType)type {
    
    if (type == EKBlogCellTypeWithMyBlog) {
        //我的日志列表
        self.userInteractionEnabled = YES;
        self.iconWithConstraint.constant = 0;
        
        self.labCaution.hidden = YES;
        self.userIcon.hidden = YES;
        self.userName.hidden = YES;
        self.message.hidden = NO;
        self.reviewNum.hidden = NO;
        self.readNum.hidden = NO;
        
    } else {
        
        self.iconWithConstraint.constant = 50;
        
        //首页日志列表
        if (listData.blogid == 0) {
            //日志设置了隐私，不显示
            self.userInteractionEnabled = NO;
            
            self.message.hidden = YES;
            self.userName.hidden = YES;
            self.readNum.hidden = YES;
            self.reviewNum.hidden = YES;
            self.userIcon.hidden = YES;
            self.labCaution.hidden = NO;
            
            self.labCaution.text = listData.mesg;
            
        } else {
            //正常显示所有cell上内容
            self.userInteractionEnabled = YES;
            
            self.labCaution.hidden = YES;
            self.message.hidden = NO;
            self.userName.hidden = NO;
            self.readNum.hidden = NO;
            self.reviewNum.hidden = NO;
            self.userIcon.hidden = NO;
            
            NSURL *userIconURL = [NSURL URLWithString:listData.avatar];
            [self.userIcon sd_setImageWithURL:userIconURL
                                     forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_avatar"]];
            
            [self.userName setTitle:listData.username forState:UIControlStateNormal];
            
        }
    }

    self.title.text     = listData.subject;
    
    self.message.text   = listData.mesg;
    
    //閱讀
    self.readNum.text   = [NSString stringWithFormat:@"%ld",(long)listData.viewnum];
    
    //評論
    self.reviewNum.text = [NSString stringWithFormat:@"%ld",(long)listData.replynum];

}


@end
