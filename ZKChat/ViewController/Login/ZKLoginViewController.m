//
//  ZKRootViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/17.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKLoginViewController.h"
#import "ZKRootViewController.h"


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
    ZKRootViewController *rootController=[[ZKRootViewController alloc]init];
    [self pushViewController:rootController animated:YES];
    [self removeHUD];
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
