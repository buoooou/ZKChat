//
//  ZKRootViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/17.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKLoginViewController.h"
#import "ZKRootViewController.h"
#import "ZKAFNetworkingClient.h"
#import "LoginModule.h"
#import "RuntimeStatus.h"
#import "ZKConstant.h"


@interface ZKLoginViewController ()
@property (nonatomic,strong) UIButton *button;
@end

@implementation ZKLoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //        [[NSNotificationCenter defaultCenter] addObserver:self
        //                                                 selector:@selector(handleWillShowKeyboard)
        //                                                     name:UIKeyboardWillShowNotification
        //                                                   object:nil];
        //
        //        [[NSNotificationCenter defaultCenter] addObserver:self
        //                                                 selector:@selector(handleWillHideKeyboard)
        //                                                     name:UIKeyboardWillHideNotification
        //                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.button=[[UIButton alloc]init];
    self.button.frame=CGRectMake(50, 50, 300, 50);
    [self.button setTitle:@"打开首页" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(logInButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.button];
}

-(void)logInButtonPressed{
    
    [self showHUDWithIndeterminateText:@"请稍后..."];
    
    
    [[LoginModule instance] loginWithUsername:@"" password:@"" success:^(ZKUserEntity *user) {
    
            [self removeHUD];
        
            TheRuntime.user=user ;
            [TheRuntime updateData];
    
            if (TheRuntime.pushToken) {
                //SendPushTokenAPI *pushToken = [[SendPushTokenAPI alloc] init];
               // [pushToken requestWithObject:TheRuntime.pushToken Completion:^(id response, NSError *error) {
               // }];
            }
            ZKRootViewController *rootController=[[ZKRootViewController alloc]init];
            [self pushViewController:rootController animated:YES];
    } failure:^(NSString *error) {
        
        [self removeHUD];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden =YES;
}

@end
