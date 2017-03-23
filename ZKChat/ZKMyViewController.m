//
//  ZKMyViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/22.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKMyViewController.h"
#import "ZKConstant.h"
#import "ZKUserInfoCell.h"
#import "ZKNormalCell.h"
#import "ZKPublicProfileViewController.h"


@interface ZKMyViewController ()

@end

@implementation ZKMyViewController

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
    [self.tableView registerClass:[ZKUserInfoCell class] forCellReuseIdentifier:@"myUserInfoCellIdentifier"];
    [self.tableView registerClass:[ZKNormalCell class] forCellReuseIdentifier:@"myFuncCellIdentifier"];
    [self.tableView registerClass:[ZKNormalCell class] forCellReuseIdentifier:@"logoutIdentifier"];
    [self.tableView registerClass:[ZKNormalCell class] forCellReuseIdentifier:@"extraIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title=@"我";
    [self.tableView reloadData];
    self.navigationController.navigationBarHidden =NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

#pragma table
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section != 0){
        return 20;
    }else{
        return 0.1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
    UILabel *detail=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-40, 16)];
    detail.font=systemFont(12);
    detail.textColor=ZKGRAY;
    if(section==1){
        detail.text=@"开启后，在22:00-8:00之间消息不会推送";
        [footerView addSubview:detail];
    }else if(section==2){
        detail.text=@"";
        [footerView addSubview:detail];
    }
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 100;
    }else{
        return 43;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0 || section == 2){
        return 1;
    }else{
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row=[indexPath row];
    NSInteger section=[indexPath section];
    if(section==0){
        static NSString *identifier=@"myUserInfoCellIdentifier";
        ZKUserInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        [cell setCellContent:@"http" Name:@"张阔" Cname:@"kafeihu92"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
    }else if(section==1){
        static NSString *identifier=@"myFuncCellIdentifier";
        ZKNormalCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if(row==0){
            [cell.textLabel setText:@"清理缓存"];
        
        }else if(row==1){
            [cell.textLabel setText:@"检查更新"];
            cell.detail.text=[NSString stringWithFormat:@"%@",ZKChatVerison];
            //[cell setUserInteractionEnabled:NO];
//            if (self.hadUpdate) {
//                [cell setUserInteractionEnabled:YES];
//                [cell showPointBadge:NO];
//                UIView *pointView =[cell pointBadgeView];
//                [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.mas_equalTo(90);
//                    make.centerY.equalTo(cell);
//                    make.width.mas_equalTo(PointBadgeDiameter);
//                    make.height.mas_equalTo(PointBadgeDiameter);
//                }];
//            }
        }else if(row == 2){
            [cell.textLabel setText:@"夜间模式"];
            [cell setUserInteractionEnabled:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell showSwitch];
//            [cell opSwitch:_pushShiledStatus];
//            [cell setChangeSwitch:^(BOOL on){
//                MTTChangeNightModeAPI *changeRequest = [MTTChangeNightModeAPI new];
//                NSMutableArray *array = [NSMutableArray new];
//                if(on){
//                    [array addObject:@(1)];
//                }else{
//                    [array addObject:@(0)];
//                }
//                [changeRequest requestWithObject:array Completion:^(NSArray *response, NSError *error) {
//                    _pushShiledStatus = on;
//                }];
//            }];
            
        }
        return cell;
    }else if(section == 2){
        static NSString* identifier = @"logoutIdentifier";
        ZKNormalCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        [cell.textLabel setText:@"退出登录"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        return cell;
    }else{
        static NSString* identifier = @"extraIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    if (indexPath.section == 0){
        [self goUserInfoProfile];
    }else if(indexPath.section == 1){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row==0) {
            [self clearCache];
        }else if(indexPath.row == 1){
            [self goUpdatePage];
        }
    }else{
        [self logOut];
    }
}
-(void)goUserInfoProfile{
    ZKPublicProfileViewController *userInfoVC=[[ZKPublicProfileViewController alloc]init];

    [self pushViewController:userInfoVC animated:YES];
}
-(void)clearCache{
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"是否清理图片缓存?"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    actionSheet.tag = 10001;
    [actionSheet show];
}
-(void)goUpdatePage{

}
-(void)logOut{
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"退出不会删除任何历史数据,下次登录依然可以使用本账号!"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"退出登陆", nil];
    
    actionSheet.titleFont = [UIFont boldSystemFontOfSize:11.0f];
    actionSheet.tag = 10000;
    [actionSheet show];
}

#pragma mark - LCActionSheetDelegate
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 10000){
        if(buttonIndex == 0){
//            LogoutAPI *logout = [LogoutAPI new];
//            [logout requestWithObject:nil Completion:NULL];
            //[MTTNotification postNotification:DDNotificationLogout userInfo:nil object:nil];
        }
    }
    if(actionSheet.tag == 10001){
        if(buttonIndex == 0){
//            [[MTTPhotosCache sharedPhotoCache] clearAllCache:^(bool isfinish) {
//                if (isfinish) {
//                    NSLog(@"11");
//                }
//            }];
        }
    }
}

@end
