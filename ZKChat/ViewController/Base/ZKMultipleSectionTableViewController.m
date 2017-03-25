//
//  ZKMultipleSectionTableViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/15.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKMultipleSectionTableViewController.h"

@interface ZKMultipleSectionTableViewController ()

@end

@implementation ZKMultipleSectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.dataSource.count)
        [self loadDataSource];
}
#pragma mark UItableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.dataSource[section] count];
}

#pragma mark 设置分组标题内容高度
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}
#pragma mark 设置每行高度（每行高度可以不一样）
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if(section==0){
//        return 50;
//    }
//    return 40;
//}
#pragma mark 设置尾部说明内容高度
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 40;
//}


@end
