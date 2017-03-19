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

    ZKRootViewController *rootController=[[ZKRootViewController alloc]init];
    
   [self pushViewController:rootController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden =YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
