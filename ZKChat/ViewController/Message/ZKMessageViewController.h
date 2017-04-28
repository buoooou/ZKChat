//
//  ZKMessageViewController.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/20.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKBaseSearchTableViewController.h"
#import "SessionModule.h"

@interface ZKMessageViewController : ZKBaseSearchTableViewController<UIAlertViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,SessionModuelDelegate>
+ (instancetype)shareInstance;

@property (nonatomic,assign) UIScrollView *scrollView;

@end
