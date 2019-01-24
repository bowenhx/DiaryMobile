//
//  TreatyViewController.m
//  BKMobile
//
//  Created by Guibin on 15/11/20.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "TreatyViewController.h"

@interface TreatyViewController ()
{
    __weak IBOutlet UITextView *_textView;
}
@end

@implementation TreatyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _textView.text = _vTreatyText;
    [self performSelector:@selector(slideTop) withObject:nil afterDelay:0.1];
}

-(void)slideTop{
    [_textView setContentOffset:CGPointZero animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
