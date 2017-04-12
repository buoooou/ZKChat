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
//缓冲提示框
-(void)showHUDWithIndeterminateText:(NSString *)text;
-(void)showHUDWithIndeterminateText:(NSString *)text whileExecutingBlock:(void (^)())block completionBlock:(void (^)())completion onView:(UIView *)view;

/**
 *隐藏所有HUD
 *
 */
-(void)removeHUD;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
