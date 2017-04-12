//
//  ZKBaseVIewControllerViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/14.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZKConstant.h"
@interface ZKBaseViewController ()<MBProgressHUDDelegate>

@end

@implementation ZKBaseViewController{
    MBProgressHUD *HUD;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:ZKBG];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.tabBarController ==nil) {
        self.navigationItem.hidesBackButton =NO;
    }
}

-(void)p_popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)setTitle:(NSString *)title{
    
    [super setTitle:title];
    
    self.navigationItem.title =title;
}
-(UINavigationItem*)navigationItem{
    
    if (self.tabBarController) {
        return [self.tabBarController navigationItem];
    }
    return [super navigationItem];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Method
-(void)setupBackgroundImage:(UIImage *)backgroundImage
{

    UIImageView * backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

-(void)showHUDWithText:(NSString *)text{
    HUD=[self showHUDWithText:text mode:MBProgressHUDModeCustomView animate:MBProgressHUDAnimationFade];
    [self.view addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.5];
}
-(void)showHUDWithIndeterminateText:(NSString *)text{
    HUD=[self showHUDWithText:text mode:MBProgressHUDModeIndeterminate animate:MBProgressHUDAnimationFade];
    [self.view addSubview:HUD];
    [HUD show:YES];
}

-(void)showHUDWithIndeterminateText:(NSString *)text whileExecutingBlock:(void (^)())block completionBlock:(void (^)())completion onView:(UIView *)view{
    
    HUD = [self showHUDWithText:text mode:MBProgressHUDModeIndeterminate animate:MBProgressHUDAnimationFade];
    [view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:block completionBlock:completion];
}

-(MBProgressHUD *)showHUDWithText:(NSString *)text mode:(MBProgressHUDMode)mode animate:(MBProgressHUDAnimation)animation
{
    [self removeHUD];
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    HUD.animationType=animation;
    
    HUD.mode=mode;
    HUD.dimBackground = YES;
    HUD.labelText=text;
    HUD.delegate = self;
    HUD.removeFromSuperViewOnHide = YES;
    return HUD;
}

-(void)removeHUD
{
    if (!HUD.isHidden) {
        [HUD removeFromSuperview];
    }
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.tabBarController ==nil) {
        [self.navigationController pushViewController:viewController animated:animated];
    }
    else{
        [self.tabBarController.navigationController pushViewController:viewController animated:animated];
    }
}

@end
