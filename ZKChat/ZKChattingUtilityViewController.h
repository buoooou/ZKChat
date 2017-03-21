//
//  ZKChattingUtilityViewController.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/27.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseViewController.h"

@interface ZKChattingUtilityViewController : ZKBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) UIImagePickerController *imagePicker;
@property(nonatomic) NSInteger userId;

@end
