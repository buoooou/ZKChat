//
//  ZKFindViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/22.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKFindViewController.h"
#import "ZKConstant.h"
#import "ZKNormalCell.h"
#import <SVWebViewController.h>
@interface ZKFindViewController ()

@end

@implementation ZKFindViewController
- (id)init {
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[ZKNormalCell class] forCellReuseIdentifier:@"FindCellIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title=@"发现";
    self.navigationController.navigationBarHidden =NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //self.tableView.contentInset =UIEdgeInsetsMake(64, 0, 49, 0);
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    //self.tableView.contentInset =UIEdgeInsetsMake(0,0,0,0);
}
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0) return 1;
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *identifier=@"FindCellIdentifier";
    ZKNormalCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];

    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=RGB(244, 245, 246);
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSInteger row=[indexPath row];
    NSInteger section=[indexPath section];
    if(section==0){
        cell.textLabel.text=@"朋友圈";
        cell.imageView.image=[UIImage imageNamed:@"ShowAlbum"];
    }else{
        if(row==0){
            cell.textLabel.text=@"ZK开源";
            cell.imageView.image=[UIImage imageNamed:@"Profile"];
        }else if(row==1){
            cell.textLabel.text=@"扫一扫";
            cell.imageView.image=[UIImage imageNamed:@"QRCode"];
        }
    }
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        
        
    }else if(indexPath.section==1){
        if(indexPath.row==0){
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://tt.mogu.io/home/introduce?type=mobile"]];
            [self.navigationController pushViewController:webViewController animated:YES];
        }else if(indexPath.row==1) {
        
        }
    }
    
    
}
@end
