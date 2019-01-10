//
//  ZLCamera.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 15-1-23.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "ZLCamera.h"
#import "BKSaveData.h"

@implementation ZLCamera

- (UIImage *)photoImage{
    if ([self.imagePath hasPrefix:@"http://"]) {
        return self.thumbImage;
    }
    UIImage *img =  [UIImage imageWithContentsOfFile:self.imagePath];
    if (!img) {
        NSData *data = [BKSaveData readDataByFile:self.imagePath];
        img = [UIImage imageWithData:data];
    }
    return img;

}

@end
