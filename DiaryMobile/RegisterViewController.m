//
//  RegisterViewController.m
//  BKMobile
//
//  Created by Guibin on 15/10/21.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterTextField.h"
#import "WebViewController.h"
#import "TreatyViewController.h"


@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>

{
    __weak IBOutlet UITableView *_tableView;
    
    IBOutlet UIView *_pickerViewBg;
    
    __weak IBOutlet UIPickerView *_pickerView;
    
    IBOutlet UIView *_datePickerBg;
    
    __weak IBOutlet UIDatePicker *_datePicker;
    
    RegisterTextField       *_regTextField;
    IBOutlet UIView *_footView;
    
    NSArray         *_textArray;
    
    NSMutableArray  *_pickerData;
    
    NSIndexPath     *_indexPath;
    
    NSString        *_pickTitle;
    NSInteger       _pickRow;
    NSInteger     _cityIndex;
    
}
@property (nonatomic , strong) NSMutableDictionary *dicData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vTableViewTopMargin;
@end

@implementation RegisterViewController

- (NSMutableDictionary *)dicData{
    if (!_dicData) {
        _dicData = [NSMutableDictionary dictionary];
    }
    return _dicData;
}
- (void)setPickerViewFrame
{
    /**
     *  设置pickViewBg 的frame适应屏幕尺寸
     */
    _pickerViewBg.backgroundColor = kViewNormalBackColor.color;
    CGRect rect = _pickerViewBg.frame;
    rect.size.width = self.view.screen_W;
    _pickerViewBg.frame = rect;
    
    /**
     *  设置datePickerBg 的frame适应屏幕尺寸
     */
    _datePickerBg.backgroundColor = kViewNormalBackColor.color;
    rect = _datePickerBg.frame;
    rect.size.width = self.view.screen_W;
    _datePickerBg.frame = rect;
    
    
    UIView *pickerView = (UIView *)[_pickerViewBg viewWithTag:10];
    for (UIView *label in pickerView.subviews) {
        label.backgroundColor = kTabBarColor.color;
    }
    
    UIView *datePickView = (UIView *)[_datePickerBg viewWithTag:20];
    for (UIView *label in datePickView.subviews) {
        label.backgroundColor = kTabBarColor.color;
    }
}

- (void)setDatePickerData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter dateFromString:@"1997-01-01"];
    
    //多算一年，因为有个预产期的时间
    NSString *maxStr = [formatter stringFromDate:[NSDate date]];
    NSInteger maxIndex = [[maxStr substringToIndex:4] integerValue];
    maxStr = [maxStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%ld",(long)maxIndex] withString:[NSString stringWithFormat:@"%ld",(long)(maxIndex +1)]];
    
    NSDate *maxDate = [formatter dateFromString:maxStr];

    
    _datePicker.minimumDate = minDate;
    _datePicker.maximumDate = maxDate;
    _datePicker.datePickerMode = UIDatePickerModeDate;

}

- (void)setTabView
{
    UINib *cell = [UINib nibWithNibName:@"RegisterViewCell" bundle:nil];
    [_tableView registerNib:cell forCellReuseIdentifier:@"registerCell"];
    
    
    UIButton *btnClause = (UIButton *)[_footView viewWithTag:10];
    [btnClause setTitleColor:kTabBarColor.color forState:UIControlStateNormal];
    
    UIButton *btnRegist = (UIButton *)[_footView viewWithTag:20];
    btnRegist.layer.cornerRadius = 4;
    btnRegist.backgroundColor = kTabBarColor.color;
    _tableView.tableFooterView = _footView;
    

    UILabel *labLine = (UILabel *)[_footView viewWithTag:66];
    labLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"public_table_line"]];
    
    //适配ipX
//    _vTableViewTopMargin.constant = kNAV_BAR_HEIGHT;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"註冊";

    _pickerData = [[NSMutableArray alloc] initWithCapacity:0];
    _pickRow = 0;
    _textArray = @[
                   @"用戶名 *",@"郵 箱 *",@"流動電話 *",@"密 碼 *",@"確認密碼 *",@"性 別", @"年 齡",@"懷孕狀況",@"預產期/已有最小寶寶出生日",@"居住地區",@"家庭收入"
                   ];

    
    [self setTabView];
   
    [self setPickerViewFrame];
    
    [self setDatePickerData];
    
    
    if (_infoData.count) {
        //facebook 注册后需要完善资料
        self.dicData[@"username"]   = _infoData[@"name"];
        self.dicData[@"email"]      = _infoData[@"email"];
        self.dicData[@"fbid"]       = _infoData[@"id"];
        self.dicData[@"fbemail"]    = _infoData[@"email"];
        self.dicData[@"id"]         = _infoData[@"id"];
        
        [_tableView reloadData];
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self initColor];
}

- (NSAttributedString *)attributedString:(NSString *)title {
    NSMutableAttributedString *attring = [[NSMutableAttributedString alloc] initWithString:title];
    [attring addAttribute:NSFontAttributeName
                    value:[UIFont boldSystemFontOfSize:15]
                    range:NSMakeRange(0, title.length)];
    [attring addAttribute:NSForegroundColorAttributeName
                    value:[UIColor lightGrayColor]
                    range:NSMakeRange(0, title.length)];
    if ([title hasSuffix:@"*"]) {
        [attring addAttribute:NSForegroundColorAttributeName
                        value:[UIColor redColor]
                        range:NSMakeRange(title.length-1, 1)];
    }
    return attring;
}

#pragma mark UITablieViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *defineCell = @"registerCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:defineCell forIndexPath:indexPath];
    [self reloadViewCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)reloadViewCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    UILabel *typeLab = (UILabel *)[cell.contentView viewWithTag:5];
    typeLab.attributedText = [self attributedString:_textArray[indexPath.row]];
    RegisterTextField *textF = (RegisterTextField *)[cell.contentView viewWithTag:120];
    textF.uTag = indexPath.row;
    textF.delegate = self;
    
    if (indexPath.row > 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        textF.enabled = NO;
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        textF.enabled = YES;
        if (indexPath.row > 2) {
            textF.secureTextEntry = YES;
        }
    }
    
    switch (indexPath.row) {
        case 0:
            textF.text = _dicData[@"username"];
            break;
        case 1:
            textF.text = _dicData[@"email"];
            textF.placeholder = @"請填寫真實的郵箱以便驗證";
            break;
        case 2:
            textF.text = _dicData[@"mobile"];
            textF.placeholder = @"請填寫真實的電話以便驗證";
            break;
        case 3:
            textF.text = _dicData[@"password"];
            break;
        case 4:
            textF.text = _dicData[@"password2"];
            break;
        case 5:
            if ([_dicData[@"gender"] integerValue] == 1 ) {
                textF.text = @"男";
            }else if ([_dicData[@"gender"] integerValue] == 2){
                textF.text =  @"女";
            }
            break;
        case 6:
            textF.text = _dicData[@"age"];
            break;
        case 7:
            textF.text = _dicData[@"pregnancy"];
            break;
        case 8:
            textF.text = _dicData[@"prebabydata"];
            break;
        case 9:
            textF.text = _dicData[@"livearea"];
            break;
        case 10:
            textF.text = _dicData[@"income"];
            break;
            break;
        default:
            break;
    }


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_regTextField isFirstResponder]) {
        [_regTextField resignFirstResponder];
    }
    [self hiddenPickerView];
    
    NSInteger row = indexPath.row;

    row -= 1;
    
    if (row > 3) {
        
        NSArray *arrData = nil;
        _cityIndex = 1;
        
        switch (row) {
            case 4: arrData = @[@"男",@"女"];
            break;
            case 5:
            {
                arrData = @[@"25歲以下",@"26﹣35歲",@"36-45歲",@"46歲以上"];
            }
                break;
            case 6:
            {
                arrData = @[@"無懷孕打算",@"準備懷孕",@"懷孕中",@"已有寶寶1位",@"已有寶寶2位或以上"];
            }
                break;
            case 7:
            {
                if ([_dicData[@"pregnancy"] isEqualToString:@"無懷孕打算"]) {
                    //如果怀孕状况选择的是无怀孕打算，那么生日日期不可以已点击
                }else{
                    _datePickerBg.tag = 0xffff;
                    [self showDatePickerView];
                }
               
                
            }
                break;
            case 8:
            {
                _cityIndex = 2;

                //區域
                arrData = @[
                            @{@"title":@"香港島",
                              @"data":@[@"中西區",@"灣仔區",@"東區",@"南區"]
                              },
                            @{@"title":@"九龍",
                              @"data":@[@"油尖旺區",@"深水埗區",@"九龍城區",@"黃大仙區"]
                              },
                            @{@"title":@"新界及離島",
                               @"data":@[@"屯門區",@"元朗區",@"大埔區",@"西貢區",@"沙田區",@"離島區",@"北區",@"荃灣區",@"葵青區"]
                              },
                            @{@"title":@"其他",
                              @"data":@[@"其他"]
                              }
                            ];
            }
                break;
            case 9:
            {
                arrData = @[@"少於HK$20,000",@"HK$20,001-HK$40,000",@"多於HK$400,001"];

               
            }
                break;
            default:
                break;
        }
        
        if (arrData.count) {
            [_pickerData setArray:arrData];
            [self showPickView];
            [_pickerView reloadAllComponents];
            
            if (_cityIndex == 2) {
                //[_pickerView selectRow:0 inComponent:0 animated:YES];
                [_pickerView selectRow:0 inComponent:1 animated:YES];
                _pickTitle = _pickerData[0][@"data"][0];
            }else{
                 [_pickerView selectRow:0 inComponent:0 animated:YES];
                _pickTitle = _pickerData[0];
            }
           
            [_pickerView setTintColor:[UIColor redColor]];
            _datePickerBg.tag = 999;
            _pickerViewBg.tag = indexPath.row;
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)isEditUserInfo
{
    if ([_regTextField isFirstResponder]) {
        [_regTextField resignFirstResponder];
    }
    
    UIButton *btnSel = (UIButton *)[_footView viewWithTag:521];
    
    if ([@"" isStringBlank:self.dicData[@"username"]]) {
        [self.view showHUDTitleView:@"請填寫用戶名" image:nil];
        return NO;
    }else if ([@"" isStringBlank:self.dicData[@"email"]])
    {
        [self.view showHUDTitleView:@"請填寫您的郵箱" image:nil];
        return NO;
    }else if ([@"" isStringBlank:self.dicData[@"password"]])
    {
        [self.view showHUDTitleView:@"請設置您的密碼" image:nil];
        return NO;
    }else if (![self.dicData[@"password"] isEqualToString:self.dicData[@"password2"]])
    {
        [self.view showHUDTitleView:@"您兩次輸入的密碼不一致，請重新輸入" image:nil];
        return NO;
    }else if (!btnSel.isSelected) {
        [self.view showHUDTitleView:@"請先同意條款" image:nil];
        return NO;
    }
    if ([@"" isStringBlank:self.dicData[@"mobile"]]) {
        [self.view showHUDTitleView:@"請填寫您的電話" image:nil];
        return NO;
    }
    return YES;
}
- (IBAction)selectFinishAction:(UIButton *)sender {
    
    if ([self isEditUserInfo]) {
        [BaseNetworking mHttpWithUrl:kRegister parameter:_dicData response:^(BKNetworkModel *model, NSString *netErr) {
            if (netErr) {
                [self.view showHUDTitleView:netErr image:nil];
            }else{
                if (model.status == 1) {
                    [[[UIAlertView alloc] initWithTitle:nil message:model.message delegate:self cancelButtonTitle:nil otherButtonTitles:@"確定", nil] show];
                }else{
                    [self.view showHUDTitleView:model.message image:nil];
                }
            }
        }];
    }
}

- (IBAction)selectAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.dicData[@"agreebbrule"] = @(sender.selected);
}

- (IBAction)selectSeeClauseAction:(UIButton *)sender {
    TreatyViewController *treatyVC = [[TreatyViewController alloc] initWithNibName:@"TreatyViewController" bundle:nil];
    treatyVC.navigationItem.title = @"服務條款";
    treatyVC.vTreatyText =  [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"KingTextHK" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    [self.navigationController pushViewController:treatyVC animated:YES];
}


#pragma  mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(RegisterTextField *)textField
{
    _regTextField = textField;
    [self hiddenPickerView];
}
- (void)textFieldDidEndEditing:(RegisterTextField *)textField
{
    NSInteger tag = textField.uTag;

    switch (tag) {
        case 0:  self.dicData[@"username"]  = textField.text;  break;
        case 1:  self.dicData[@"email"]     = textField.text;  break;
        case 2:  self.dicData[@"mobile"]    = textField.text;  break;
        case 3:  self.dicData[@"password"]  = textField.text;  break;
        case 4:  self.dicData[@"password2"] = textField.text;  break;
        default:
            break;
    }

}
- (BOOL)textFieldShouldReturn:(RegisterTextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma  mark PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _cityIndex;
}
- (NSArray *)selectPickRow
{
    return _pickerData[_pickRow][@"data"];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_cityIndex == 2) {
        if (component == 0) {
            return _pickerData.count;
        }
        return [[self selectPickRow] count];
    }
    return _pickerData.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_cityIndex == 2) {
        if (component == 0) {
            return _pickerData[row][@"title"];
        }
        return [self selectPickRow][row];
    }
    return [NSString stringWithFormat:@"%@",_pickerData[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_cityIndex == 2) {
        if (component == 0) {
            _pickRow = row;
            [pickerView reloadComponent:1];
            _pickTitle = _pickerData[row][@"data"][0];
        }else{
            _pickTitle = _pickerData[_pickRow][@"data"][row];
        }
      
        return;
    }
    _pickTitle = _pickerData[row];
}
#pragma mark 选择完成操作PickerDate
- (IBAction)didSelectCancelAction:(UIButton *)sender {
    if (_datePickerBg.tag == 0xffff) {
       
        [self didHiddenDatePickerView];
    }else{
        [self didHiddenPickerView];
    }
}

#pragma mark 选择完成并保存
- (IBAction)didSelectFinishAction:(UIButton *)sender {
   
    if (_datePickerBg.tag == 0xffff) {
        [self didSelectDatePickerAction:_datePicker];
        
         [self didHiddenDatePickerView];
    }else{
        if ([_pickTitle isEqualToString:@"男"]) {
            _pickTitle = @"1";
        }else if ([_pickTitle isEqualToString:@"女"]){
            _pickTitle = @"2";
        }
        
        NSInteger tag = _pickerViewBg.tag;
        tag -= 1;
        switch (tag) {
            case 4:  self.dicData[@"gender"]      = _pickTitle;  break;
            case 5:  self.dicData[@"age"]         = _pickTitle;  break;
            case 6:  self.dicData[@"pregnancy"]   = _pickTitle;  break;
            case 7:  self.dicData[@"prebabydata"] = _pickTitle;  break;
            case 8:  self.dicData[@"livearea"]    = _pickTitle;  break;
            case 9:  self.dicData[@"income"]      = _pickTitle;  break;
            default:
                break;
        }
        
        if ([_dicData[@"pregnancy"] isEqualToString:@"無懷孕打算"]) {
            //如果怀孕状况选择的是无怀孕打算，设置生日为空
            self.dicData[@"prebabydata"] = @"";
            self.dicData[@"birthday"] = @"";//
        }
        
        [self didHiddenPickerView];
    }
    
    [_tableView reloadData];
}

- (IBAction)didSelectDatePickerAction:(UIDatePicker *)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter stringFromDate:sender.date];
    self.dicData[@"prebabydata"] = strDate;
    self.dicData[@"birthday"] = strDate;// 预产期\宝宝生日(birthday) 区别香港字段变化
}


- (void)showPickView {
//    _pickerView.layer.borderWidth = 1;
//    _pickerView.layer.borderColor = [UIColor redColor].CGColor;
    CGRect rect = _pickerViewBg.frame;
    rect.origin.x = 0;
    rect.origin.y = kSCREEN_HEIGHT;
    rect.size.width = kSCREEN_WIDTH;
    _pickerViewBg.frame = rect;
    if (!_pickerViewBg.superview) {
        [self.view addSubview:_pickerViewBg];
    }
    
    [_pickerViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect frame = _pickerViewBg.frame;
//        frame.origin.y = kSCREEN_HEIGHT - _pickerViewBg.frame.size.height;
//        _pickerViewBg.frame = frame;
//    }];
    
}
- (void)didHiddenPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _pickerViewBg.frame;
        rect.origin.y = kSCREEN_HEIGHT;
        _pickerViewBg.frame = rect;
        
        
    } completion:^(BOOL finished) {
        [_pickerViewBg removeFromSuperview];
    }];
    
}

- (void)showDatePickerView
{
    CGRect rect = _datePickerBg.frame;
    rect.origin.x = 0;
    rect.origin.y = kSCREEN_HEIGHT;
    rect.size.width = kSCREEN_WIDTH;
    _datePickerBg.frame = rect;
    _pickerView.w = kSCREEN_WIDTH;
    if (!_datePickerBg.superview) {
        [self.view addSubview:_datePickerBg];
    }
    
    [_datePickerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}
- (void)didHiddenDatePickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _datePickerBg.frame;
        rect.origin.y = kSCREEN_HEIGHT;
        _datePickerBg.frame = rect;
        
    } completion:^(BOOL finished) {
        [_datePickerBg removeFromSuperview];
    }];
    
}

- (void)hiddenPickerView
{
    if (_datePickerBg.superview) {
        [_datePickerBg removeFromSuperview];
    }else if (_pickerViewBg.superview){
        [_pickerViewBg removeFromSuperview];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_pushHomePageVC) {
        _pushHomePageVC (self.dicData);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
