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
//    self.navigationController.navigationBar.backgroundColor=[UIColor blackColor];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.tabBarController ==nil) {
        self.navigationItem.hidesBackButton =NO;
    }
}
//-(void)p_popViewController
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}

-(void)setTitle:(NSString *)title{
    
    [super setTitle:title];
    
    self.navigationItem.title =title;
    self.navigationItem.titleView =nil;
//self.navigationController.navigationBar.backgroundColor=[UIColor blackColor];
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


-(void)showLoading
{
    [self showHUDWithIndeterminateText:@""];
}

-(void)showHUDWithText:(NSString *)text{
    [self showHUDWithText:text delay:1.5];
}
-(void)showHUDWithIndeterminateText:(NSString *)text{
    [self showHUDWithIndeterminateText:text delay:1.5];
}

-(void)showHUDWithText:(NSString *)text delay:(NSTimeInterval)delay{
    
    HUD=[self showHUDWithText:text mode:MBProgressHUDModeCustomView animate:MBProgressHUDAnimationFade delay:delay];
//    HUD.bezelView.backgroundColor=[UIColor blackColor];
    HUD.backgroundColor=[UIColor blackColor];
    HUD.labelColor=[UIColor whiteColor];

//    HUD.label.textColor=[UIColor whiteColor];
    [self.view addSubview:HUD];
}
-(void)showHUDWithIndeterminateText:(NSString *)text delay:(NSTimeInterval)delay{
    
    HUD=[self showHUDWithText:text mode:MBProgressHUDModeIndeterminate animate:MBProgressHUDAnimationFade delay:delay];
    [self.view addSubview:HUD];
}

-(MBProgressHUD *)showHUDWithText:(NSString *)text mode:(MBProgressHUDMode)mode animate:(MBProgressHUDAnimation)animation delay:(NSTimeInterval)delay
{
    [self hideHUD];
    MBProgressHUD * hud=[[MBProgressHUD alloc] initWithView:self.view];
    hud.animationType=animation;
    
    hud.mode=mode;
    
//    hud.label.text=text;
    hud.labelText=text;
    
    hud.delegate = self;
//    [hud showAnimated:YES];
    [hud hide:YES afterDelay:delay];
//    [hud hideAnimated:YES afterDelay:delay];
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

-(void)hideHUD
{
    if (!HUD.isHidden) {
//        [HUD hideAnimated:NO];
        [HUD hide:NO];
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
