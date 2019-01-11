//
//  BlogTypeTableViewController.h
//  EduKingdom
//
//  Created by ligb on 2017/1/13.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LogListModel.h"

/**
 block 返回分类和设置对象
 @param obj 分类对象
 @param setName set字符串
 @param index 标记选中
 */
typedef void (^SelectBlogTypeBlock)(BlogTypeList *obj,NSString *setName,NSUInteger index);

/**  这里是当上面的index 为2和4的时候才会调用
 返回设置中的好友和密码
 @param usernames 好友name
 @param password 设置密码
 */
typedef void (^SelectFriendOrPwBlock)(NSArray *usernames,NSString *password);

typedef enum : NSUInteger {
    EditBlogSetting_Type = 0,   //站贴分类
    EditBlogSetting_Intimity    //隐私设置
} EditBlogSetting;


@interface BlogTypeTableViewController : BaseViewController
@property (nonatomic , assign) EditBlogSetting blogSetting;
@property (nonatomic , copy) SelectBlogTypeBlock typeObj;
@property (nonatomic , copy) SelectFriendOrPwBlock freendsPw;
@property (nonatomic , assign) NSUInteger selectIndex;//标记选中的分类index
@end

/**  根据 api 的逻辑和页面显示去查看上面的block 返回
其中friend为隐私设置，可取值为：
0，默认，全站用户可见
1，仅好友可见
2，指定好友可见，当取该值时，**需要target_names参数传递好友名，多个用空格表示如“好友1 好友2 好友3 张三 李四”，注意，不是uid，而是username
3，仅自己可见
4，密码可见，当取该值时，**需要password参数传递密码
 
*/
