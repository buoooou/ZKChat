//
//  ZKRootViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/21.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKRootViewController.h"
#import "ZKBaseSearchTableViewController.h"
#import "ZKBaseNavigationController.h"
#import "ZKMessageViewController.h"
#import "ZKMyViewController.h"
#import "ZKContactViewController.h"
#import "ZKFindViewController.h"
#import "ZKConstant.h"
@interface ZKRootViewController ()<UITabBarControllerDelegate,UITabBarDelegate>

@end

@implementation ZKRootViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:@"Notification_user_logout" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //消息首页
    ZKMessageViewController *messageVC=[ZKMessageViewController shareInstance];
    UIImage *meaageSelectedImg=[[UIImage imageNamed:@"conversation_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageVC.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"消息" image:[UIImage imageNamed:@"conversation"] selectedImage:meaageSelectedImg];
    messageVC.tabBarItem.tag=100;
    [messageVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(26, 140, 242) forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    messageVC.hidesBottomBarWhenPushed=YES;
    
    //通讯录
    ZKContactViewController *contactVC=[[ZKContactViewController alloc]init];
    UIImage *contactSelectedImg=[[UIImage imageNamed:@"contact_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contactVC.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"通讯录" image:[UIImage imageNamed:@"contact"] selectedImage:contactSelectedImg];
    contactVC.tabBarItem.tag=100;
    [contactVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(26, 140, 242) forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    contactVC.hidesBottomBarWhenPushed=YES;
    
    //发现
    ZKFindViewController *findVC=[[ZKFindViewController alloc]init];
    UIImage *findSelectedImg=[[UIImage imageNamed:@"tab_nav_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findVC.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"发现" image:[UIImage imageNamed:@"tab_nav"] selectedImage:findSelectedImg];
    findVC.tabBarItem.tag=100;
    [findVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(26, 140, 242) forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    findVC.hidesBottomBarWhenPushed=YES;
    
    //个人首页
    ZKMyViewController *myVC=[[ZKMyViewController alloc] init];
    UIImage *mySelectedImg=[[UIImage imageNamed:@"myprofile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myVC.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"myprofile"] selectedImage:mySelectedImg];
    myVC.tabBarItem.tag=100;
    [myVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:RGB(26, 140, 242) forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    myVC.hidesBottomBarWhenPushed=YES;

    self.viewControllers=@[messageVC,contactVC,findVC,myVC];
    self.title=APP_NAME;
    self.delegate=self;
    
}
#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //    [tabBar.items indexOfObject:item]
    
    
    
}

//防重复登录被踢出
-(void)logoutNotification:(NSNotification*)notification{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton =YES;
    self.navigationController.navigationBarHidden =NO;
  
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled =NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled =YES;
}
-(void)dealloc{
    
    self.navigationController.interactivePopGestureRecognizer.delegate =nil;
}


@end
