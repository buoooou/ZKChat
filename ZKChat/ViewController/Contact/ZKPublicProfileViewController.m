//
//  ZKPublicProfileViewControll.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/25.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKPublicProfileViewController.h"
#import "ZKConstant.h"
#import "UIImageView+WebCache.h"
#import "ZKUserEntity.h"
#import "ZKPublicProfileCell.h"
#import "ZKChattingMainViewController.h"
#import "ZKUserInfoCell.h"
#import "ZKNormalCell.h"
#import <Masonry.h>

@interface ZKPublicProfileViewController ()

@end

@implementation ZKPublicProfileViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详细资料";
    
    _chatBtn = [UIButton new];
    [self.tableView registerClass:[ZKPublicProfileCell class] forCellReuseIdentifier:@"NormalCell"];
    [self.tableView registerClass:[ZKUserInfoCell class] forCellReuseIdentifier:@"UserInfoCell"];
    [self.tableView registerClass:[ZKNormalCell class] forCellReuseIdentifier:@"footerCell"];

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        return 100;
    }else{
        return 43;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1){
        return 1;
    }else if(section==2){
        return 2;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NormalCell";
    ZKPublicProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZKPublicProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:{
            static NSString *headcellIdentifier = @"UserInfoCell";
            ZKUserInfoCell * headCell=[tableView dequeueReusableCellWithIdentifier:headcellIdentifier];
            headCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [headCell setCellContent:@"" Name:@"张阔" Cname:@"kafeihu"];
            return headCell;
            break;
        }
        case 1:{
             [cell setDesc:@"标签" detail:@"zk"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case 2:{
            if(indexPath.row==0){
                [cell setDesc:@"地区" detail:@"zk"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else{
                [cell setDesc:@"签名" detail:@"zk"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            break;
        }
        case 3:{
            static NSString *footercellIdentifier = @"footerCell";
            ZKNormalCell *footercell = [tableView dequeueReusableCellWithIdentifier:footercellIdentifier];
            [footercell.textLabel setText:@"发送消息"];
            [footercell.textLabel setTextAlignment:NSTextAlignmentCenter];
            return footercell;
            break;
        }
        default:
            break;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==3)
    {
        [self startChat];
    }
}
-(void)startChat
{
//    ZKSessionEntity* session = [[ZKSessionEntity alloc] init ];
//    [[ZKChattingMainViewController shareInstance] showChattingContentForSession:session];
    
    if ([[self.navigationController viewControllers] containsObject:[ZKChattingMainViewController shareInstance]]) {
        [self.navigationController popToViewController:[ZKChattingMainViewController shareInstance] animated:YES];
    }else
    {
        [self pushViewController:[ZKChattingMainViewController shareInstance] animated:YES];
        
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

@end
