//
//  AppURLDefine.h
//  DiaryMobile
//
//  Created by stray s on 2019/1/9.
//  Copyright © 2019年 com.professional.cn. All rights reserved.
//

#ifndef AppURLDefine_h
#define AppURLDefine_h


static NSString *const kHostURL = @"https://bapi.edu-kingdom.com/index.php";

//最新/推荐 日志列表
static NSString *const kHomeBlogList = @"?mod=home&op=bloglist";

//日志分类列表
static NSString *const kBlogTypeList  = @"?mod=home&op=blogtype";

//我的日志列表
static NSString *const kMyBlogList =  @"?mod=home&op=blogmy";

//我的好友日志列表
static NSString *const kMyFriendBlogList = @"?mod=home&op=blogwe";

//发布日志
static NSString *const kSendBlog = @"?mod=home&op=blogpost";

//查看日志详情
static NSString *const kBlogDetail = @"?mod=home&op=blogshow";

#pragma mark ----------- 好友
//好友列表
static NSString *const kFriendList = @"?mod=home&op=friend";

//添加或同意好友添加
static NSString *const kFriendAdd   =   @"?mod=home&op=friendadd";

//刪除或忽略好友
static NSString *const kFriendDelete   =   @"?mod=home&op=frienddelete";
//打招呼相關操作
static NSString *const kGreeting   =  @"?mod=home&op=poke";

//相册
static NSString *const kPhotoGallery = @"?mod=home&op=album";




//保存日志分类对象key
static NSString *const kBlogTypeKey = @"blogType";




#endif /* AppURLDefine_h */
