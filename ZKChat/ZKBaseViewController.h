//
//  ZKBaseVIewControllerViewController.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/14.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZKBaseViewController : UIViewController

/**
 *统一设置背景图片
 *
 */
-(void)setupBackgroundImage:(UIImage *)backgroundImage;

/**
 *显示正在加载，没有文字HUD
 *
 */
-(void)showLoading;

//HUD提示框

//文字提示框
-(void)showHUDWithText:(NSString *)text;
-(void)showHUDWithText:(NSString *)text delay:(NSTimeInterval)delay;
//缓冲提示框
-(void)showHUDWithIndeterminateText:(NSString *)text;
-(void)showHUDWithIndeterminateText:(NSString *)text delay:(NSTimeInterval)delay;
/**
 *隐藏所有HUD
 *
 */
-(void)hideHUD;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
