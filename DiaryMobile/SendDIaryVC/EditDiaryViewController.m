//
//  EditBlogViewController.m
//  EduKingdom
//
//  Created by ligb on 2017/1/12.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "EditDiaryViewController.h"
#import "KDefine.h"
#import "UIImage+UIImageExt.h"
#import "BlogTypeTableViewController.h"
#import "UserHelper.h"

static float kPhotosW = 60.f;//图片的宽
static float kPhotosH = 60.f;//图片的高

#define PHOTOS_X       (kSCREEN_WIDTH - kPhotosW * 4 ) / 5   //图片的间距

//最下面两个单元格的表，距离上面view的距离
static CGFloat kTableTopSpace = 40;

@interface EditDiaryViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZLPhotoPickerBrowserViewControllerDelegate, UIPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate> {
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet UITextField *_textField;
    
    __weak IBOutlet UILabel *lineLabel;
    
    __weak IBOutlet UITextView *_textView;
    
    __weak IBOutlet UILabel *textLab;
    
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet NSLayoutConstraint *_tableViewConstraintY;
    
    NSArray     *_listData;
    
    float       img_W;
    
    UIView *_vPhotoBgView; //选择照片下面放置一个背景view，用于点击该view消失键盘操作。
}
@property (nonatomic , strong) UIButton *photoBtn; //添加照片btn
@property (nonatomic , strong) NSMutableArray *vAssets;//照片数据源
@property (strong , nonatomic) UIPopoverController* imagePickerPopover;
@property (nonatomic , strong) NSMutableArray *typeNames;
@property (nonatomic , assign) NSUInteger tempTypeIndex;//临时标记站贴分类选中的index
@property (nonatomic , assign) NSUInteger tempTypeSetIndex;//临时标记隐私设置选中的index
@property (nonatomic , copy) NSArray *usernames;//好友名字
@property (nonatomic , copy) NSString *password;//密码
@property (nonatomic , assign) NSUInteger catid;//分类id
@end

@implementation EditDiaryViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kSelectImageNotificatiion" object:nil];
}
- (NSMutableArray *)vAssets {
    if (!_vAssets) {
        _vAssets = [NSMutableArray array];
    }
    return _vAssets;
}

- (NSMutableArray *)typeNames {
    if (!_typeNames) {
        NSString *path = [BKTool getLibraryDirectoryPath:kBlogTypeKey];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSData *saveData = [NSData dataWithContentsOfFile:path];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
            DiaryTypeModel *listObj = arr[0];
            _catid = listObj.catid;
            _typeNames = [[NSMutableArray alloc] initWithObjects:listObj.catname,@"全站用戶可見", nil];
        }else{
            [DiaryTypeModel getBlogTypeListBlock:^(NSArray *data, NSString *netErr) {
                if (netErr) {
                    [self.view showHUDTitleView:netErr image:nil];
                }else{
                    if (0 == data.count) {
                        return;
                    }
                    
                    DiaryTypeModel *listObj = data[0];
                    _catid = listObj.catid;
                    if (!_typeNames) {
                        _typeNames = [NSMutableArray array];
                    }
                    
                    [_typeNames addObject:listObj.catname];
                    [_typeNames addObject:@"全站用戶可見"];
                    [_tableView reloadData];
                    
                    //保存分类对象
                    NSData *objData = [NSKeyedArchiver archivedDataWithRootObject:data];
                    //创建分类对象的路径
                    NSString *path = [BKTool getLibraryDirectoryPath:kBlogTypeKey];
                    //把数据写入文件
                    if ([objData writeToFile:path atomically:YES]) {
                        NSLog(@"Write File Cusseece");
                    }
                }
            }];
            
            _typeNames = [NSMutableArray array];
        }
    }
    return _typeNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"寫日誌";
    
    [self.rightBtn setTitle:@"發佈" forState:UIControlStateNormal];
    _password = @"";
    
    //添加点击相册统计通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGoogleStatisticsAction) name:@"kSelectImageNotificatiion" object:nil];
}


- (void)loadNewView {
    lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableViewConstraintY.constant = self.photoBtn.h + kTableTopSpace;
}

- (void)loadNewData {
    _listData = @[@"站點分類",@"隱私設置"];
    [_tableView reloadData];
}
#pragma mark 发布
- (void)tapRightBtn{
    if ([@"" isStringBlank:_textField.text]) {
        [self.view showHUDTitleView:@"日誌標題不能為空" image:nil];
        return;
    }
    
    NSString *target_names = @"";
    if (_tempTypeSetIndex == 2) {
        target_names = [_usernames componentsJoinedByString:@","];
    }
    
    NSDictionary *dicInfo = @{@"token":TOKEN,
                              @"catid":@(_catid),
                              @"subject":_textField.text,
                              @"message":_textView.text,
                              @"friend":@(_tempTypeSetIndex),
                              @"target_names":target_names,
                              @"password":_password};
    __weak typeof(self) bself = self;
    [self showActivityView:@"0%"];
    MBProgressHUD *HUDpro = (MBProgressHUD *)[self.view viewWithTag:0xffff];
    NSArray *files = [self uploadingImageFiles:self.vAssets];
    [[BKNetworking share] upload:kSendBlog params:dicInfo files:files precent:^(float precent) {
        NSString *progressStr = [NSString stringWithFormat:@"%.1f", precent * 100];
        progressStr = [progressStr stringByAppendingString:@"%"];
        if (HUDpro) HUDpro.labelText = progressStr;
        DLog(@"progressStr = %@",progressStr);
    } completion:^(BKNetworkModel *model, NSString *netErr) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (HUDpro)
            [HUDpro removeFromSuperview];
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        }else if (model.status == 1) {
            
            [bself.view showHUDTitleView:model.message image:nil];
            //通知我的日志页面，刷新ui
            //[[NSNotificationCenter defaultCenter] postNotificationName:kPublishBlogSuccessNotification object:nil];
            [self performSelector:@selector(mPopViewController) withObject:self afterDelay:1];
        }else{
            [bself.view showHUDTitleView:model.message image:nil];
        }
    }];

}


- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _vPhotoBgView = [[UIView alloc] init];
        _vPhotoBgView.frame = CGRectMake(0, _textView.max_Y+10, kSCREEN_WIDTH, kPhotosH + 20);
        //view添加点击事件，用于点击后，键盘下去
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mKeyboardHidden)];
        [_vPhotoBgView addGestureRecognizer:tapGesture];
        [_scrollView addSubview:_vPhotoBgView];

        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.frame = CGRectMake(PHOTOS_X, _textView.max_Y+10, kPhotosW, kPhotosH);
        [_photoBtn setBackgroundImage:[UIImage imageNamed:@"Post_vi_Add"] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(selectPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_photoBtn];
    }
    return _photoBtn;
}

- (void)addPhotosImage{
    
    DLog(@"width  = %f",kSCREEN_WIDTH);
    float Y = _textView.max_Y+10;
    // 加一是为了有个添加button
    NSInteger count = self.vAssets.count +1;
    for (int i=0;i < count; i++) {
        float addBtnX = PHOTOS_X + (PHOTOS_X + kPhotosW) * (i%4);
        float addBtnY = Y + (10 + kPhotosH) * (i/4);
        
        //多算一个frame确定添加按钮的坐标位置
        if (i == self.vAssets.count) {
            
            //选择照片后，重新设置背景veiw的高度
            CGFloat  viewHeight = (i / 4 + 1) * (kPhotosH + 20);
            _vPhotoBgView.frame = CGRectMake(0, _textView.max_Y+10, kSCREEN_WIDTH, viewHeight);
            
            if (i>8) {
                self.photoBtn.hidden = YES;
            } else {
                self.photoBtn.hidden = NO;
                self.photoBtn.frame = CGRectMake(addBtnX, addBtnY, kPhotosW, kPhotosH);

                [_scrollView addSubview:_photoBtn];
            }
            break;
        }
        
        UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = CGRectMake(addBtnX, addBtnY, kPhotosW, kPhotosH);
        btnImage.tag = i;
        UIImage *image = [self.vAssets[i] thumbImage];
        [btnImage setBackgroundImage:image forState:UIControlStateNormal];
        [_scrollView addSubview:btnImage];
        [btnImage addTarget:self action:@selector(didSelectPhotoImage:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    NSInteger spaceH = ceilf(count / 4.0);
    _tableViewConstraintY.constant = (_photoBtn.h +10) * spaceH + kTableTopSpace;
}


- (void)showActivityView:(NSString *)message {
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = message;
    hud.tag = 0xffff;
    hud.alpha = .6;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙层效果
    hud.dimBackground = YES;
    //[hud hide:YES afterDelay:5];
}

//退出键盘action
- (void)mKeyboardHidden {
    [self.view endEditing:YES];
}

//键盘消失方法,由于页面底部是UIScrollerView,无法响应touch，添加了类别UIScrollView+Touch来解决
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
     [self.view endEditing:YES];
}

- (void)selectPhotoAction:(UIButton *)sender {
    [self mKeyboardHidden];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手機相冊",@"系統拍照", nil];
    [sheet showInView:self.view];
}

#pragma  mark ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://手机相册
            [self localPhoto];
            break;
        case 1://拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}

- (void)didSelectPhotoImage:(UIButton *)btn {
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.vAssets;
    // 当前选中的值
    pickerBrowser.currentIndex = btn.tag;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
    
}

//添加统计 //// 發佈主題 > 點撃拍照圖片 > 點撃手機相冊 >點撃相冊，
- (void)addGoogleStatisticsAction {
    
}


#pragma mark 选择相册
- (void)localPhoto {
    
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 9;
    pickerVc.selectPickers = self.vAssets;
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    // CallBack
    __weak typeof(self) bself = self;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        if (_vAssets.count)
            [_vAssets removeAllObjects];
        
        for (ZLPhotoAssets *asset in status) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                photo.asset = asset;
                //当asset 找不到图片时可以取photoImage/ photoURL
                photo.photoImage = asset.originImage;
                photo.photoURL = asset.assetURL;
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                ZLCamera *camera = (ZLCamera *)asset;
                photo.photoImage = [camera photoImage];
            }
            [_vAssets addObject:photo];
        }
        [bself removeScrollViewSuperViewBtn];
    };
    
    if (kIS_IPAD) {
        if (kiOS8) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:pickerVc animated:YES completion:nil];
            }];
            
        }else{
            self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:pickerVc];
            [self.imagePickerPopover presentPopoverFromRect:CGRectMake(_photoBtn.frame.origin.x, _photoBtn.frame.origin.y + _photoBtn.frame.size.height, 300.0f, 100.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }else{
        [self presentViewController:pickerVc animated:YES completion:nil];
    }
    
}

#pragma mark 拍照
- (void)takePhoto
{
    if (self.vAssets.count >= 9) {
        [self.view showHUDTitleView:@"只能選擇9張圖片上傳" image:nil];
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        
        // 判斷用户是否允许摄像头使用
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
            //摄像头访问权限被关闭，弹出提示框
            UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"此功能需要相機權限才能使用" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertC animated:YES completion:nil];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            [alertC addAction:action];
        } else {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            //    imagePicker.allowsEditing = YES;
            //拍照
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
            @WeakObj(self);
            if (kIS_IPAD) {
                if (kiOS8) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [selfWeak presentViewController:imagePicker animated:YES completion:nil];
                    }];
                } else {
                    
                    self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                    [self.imagePickerPopover presentPopoverFromRect:CGRectMake(_photoBtn.frame.origin.x, _photoBtn.frame.origin.y + _photoBtn.frame.size.height, 300.0f, 100.0f) inView:selfWeak.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                }
                
            } else {
                [selfWeak presentViewController:imagePicker animated:YES completion:nil];
            }
        }
 
    } else {
        DLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [image scalingImageByRatio];
    image = [image fixOrientation];//调整图片
    
    //把牌照图片存储到本地
    NSString *path = [UserHelper saveImagePath:image];
    NSData *data = UIImageJPEGRepresentation(image, 0.6);
    image = [UIImage imageWithData:data];
    
    ZLPhotoAssets *assets = [[ZLPhotoAssets alloc] init];
    assets.originImage = image;
    assets.assetURL = [NSURL URLWithString:path];
    
    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
    photo.asset = _vAssets;
    photo.photoImage = image;
    photo.thumbImage = image;
    photo.photoURL = [NSURL URLWithString:path];
    
    [self.vAssets addObject:photo];
    
    [self removeScrollViewSuperViewBtn];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (self.vAssets.count > index) {
        [self.vAssets removeObjectAtIndex:index];
        [self removeScrollViewSuperViewBtn];
    }
}
- (void)removeScrollViewSuperViewBtn
{
    for (UIButton *buttonView in [_scrollView subviews]) {
        if ([buttonView isKindOfClass:[UIButton class]]) {
            //判断，不要把选择主题分类按钮删除掉
            if ([buttonView backgroundImageForState:UIControlStateNormal]) {
                [buttonView removeFromSuperview];
            }
        }
    }
    
    [self addPhotosImage];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    textLab.hidden = textView.text.length ? YES: NO;
}

#pragma mark - TableVeiwDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *defineCell = @"defineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defineCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self cellForRowSurplusTableViewCell:cell indexPath:indexPath];
    
//    cell.userInteractionEnabled = YES;
    
    return cell;
}

- (void)cellForRowSurplusTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = _listData[indexPath.row];
//    if (indexPath.row == 0) {
//        BlogTypeList *listObj = self.typeNames[indexPath.row];
//        cell.detailTextLabel.text = listObj.catname;
//    }else{
    cell.detailTextLabel.text = self.typeNames.count ? self.typeNames[indexPath.row] : @"";
//    }
    
//    BlogTypeList *listObj = self.typeNames.count > indexPath.row ? self.typeNames[indexPath.row] : nil;
//    cell.detailTextLabel.text = listObj ? listObj.catname : @"";
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击单元格时候，缩回键盘
    [self mKeyboardHidden];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        NSString *path = [BKTool getLibraryDirectoryPath:kBlogTypeKey];
        __block NSMutableArray *actions = [NSMutableArray array];
        __block NSMutableArray <DiaryTypeModel *> *arr = [NSMutableArray array];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSData *saveData = [NSData dataWithContentsOfFile:path];
            arr = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
            [arr enumerateObjectsUsingBlock:^(DiaryTypeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [actions addObject:obj.catname];
            }];
        }
        
        CustomAlertController *alert = [CustomAlertController alertController];
        alert.title(@"選擇分類").actions(actions).cancelTitle(@"取消").controller(self);
        
        [alert show:^(UIAlertAction *action, NSInteger index) {
            [_typeNames replaceObjectAtIndex:0 withObject:action.title];
            _tempTypeIndex = index;//标记设置页面
            _catid = arr[index].catid;
            [_tableView reloadData];
            NSLog(@"action.title = %@",action.title);
        } confirmAction:nil cancelAction:nil];
        
     
    } else {
        BlogTypeTableViewController *blogTypeVC = [[BlogTypeTableViewController alloc] initWithNibName:@"BlogTypeTableViewController" bundle:nil];
        blogTypeVC.title = _listData[indexPath.row];
        blogTypeVC.blogSetting = indexPath.row;
        //记录选中的index
        blogTypeVC.selectIndex = indexPath.row == 0 ? _tempTypeIndex : _tempTypeSetIndex;
        [self.navigationController pushViewController:blogTypeVC animated:YES];
        
        blogTypeVC.typeObj = ^(DiaryTypeModel *obj,NSString *setName,NSUInteger index){
            if (indexPath.row == 0) {//分类
                [_typeNames replaceObjectAtIndex:0 withObject:setName];
                _tempTypeIndex = index;//标记设置页面
                _catid = obj.catid;
            } else {//隐私设置
                [_typeNames replaceObjectAtIndex:1 withObject:setName];
                _tempTypeSetIndex = index;//标记设置页面
            }
            [_tableView reloadData];
        };
        
        blogTypeVC.freendsPw = ^(NSArray *usernames,NSString *password){
            if (usernames.count) {
                //好友名字
                _usernames = [usernames copy];
            }else{
                //密码设置
                _password = password;
            }
        };
        
    }
    
    
    
    
    return;
    BlogTypeTableViewController *blogTypeVC = [[BlogTypeTableViewController alloc] initWithNibName:@"BlogTypeTableViewController" bundle:nil];
    blogTypeVC.title = _listData[indexPath.row];
    blogTypeVC.blogSetting = indexPath.row;
    //记录选中的index
    blogTypeVC.selectIndex = indexPath.row == 0 ? _tempTypeIndex : _tempTypeSetIndex;
    [self.navigationController pushViewController:blogTypeVC animated:YES];
    
    blogTypeVC.typeObj = ^(DiaryTypeModel *obj,NSString *setName,NSUInteger index){
        if (indexPath.row == 0) {//分类
            [_typeNames replaceObjectAtIndex:0 withObject:setName];
            _tempTypeIndex = index;//标记设置页面
            _catid = obj.catid;
           
            
        }else{//隐私设置
            [_typeNames replaceObjectAtIndex:1 withObject:setName];
            _tempTypeSetIndex = index;//标记设置页面
        }
        [_tableView reloadData];
    };
    
    blogTypeVC.freendsPw = ^(NSArray *usernames,NSString *password){
        if (usernames.count) {
            //好友名字
            _usernames = [usernames copy];
        }else{
            //密码设置
            _password = password;
        }
    };
    
}

- (void)mPopViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)uploadingImageFiles:(NSArray *)files {
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:files.count];
    
    [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = nil;
        if ([obj isKindOfClass:[ZLPhotoPickerBrowserPhoto class]]) {
            ZLPhotoPickerBrowserPhoto *photo = (ZLPhotoPickerBrowserPhoto *)obj;
            ZLPhotoAssets *asset = photo.asset;
            if (asset && [asset isKindOfClass:[ZLPhotoAssets class]]) {
                image = asset.originImage;
            }else {
                image = photo.photoImage;
            }
            
            if (image) {
                NSString *name = [NSString stringWithFormat:@"attach%lu",(unsigned long)++idx];
                [imageArr addObject:@[name , image]];
            }
        }
    }];
    return imageArr;
}


@end
