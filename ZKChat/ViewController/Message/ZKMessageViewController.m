//
//  ZKMessageViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/20.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKMessageViewController.h"
#import "ZKConstant.h"
#import "ZKRecentUserCell.h"
#import "ZKChattingMainViewController.h"
#import "ZKNormalCell.h"
#import "ZKChattingUtilityViewController.h"
#import "ZKDatabaseUtil.h"
#import "ZKMessageEntity.h"
#import "DDMessageModule.h"

@interface ZKMessageViewController ()

@end

@implementation ZKMessageViewController
- (id)init {
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}
+ (instancetype)shareInstance
{
    static ZKMessageViewController* g_recentUsersViewController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_recentUsersViewController = [ZKMessageViewController new];
    });
    return g_recentUsersViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"消息";
    
    self.dataSource=[[NSMutableArray alloc] initWithObjects:
                     @"华捷新闻，点击查看！",@"华捷新闻，点击查看！",@"华捷新闻，点击查看！",
                     nil];
    [self.tableView registerClass:[ZKBaseCell class] forCellReuseIdentifier:@"ZKPCStatusCellIdentifier"];
    [self.tableView registerClass:[ZKRecentUserCell class] forCellReuseIdentifier:@"ZKRecentUserCellIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.title=APP_NAME;
    self.navigationController.navigationBarHidden =NO;
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.tableView.contentInset =UIEdgeInsetsMake(64, 0, 49, 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else{
        return [self.dataSource count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if(indexPath.section == 0){
        //        if(self.isMacOnline){
        //            height = 45;
        //        }else{
        //            height = 0;
        //        }
        height = 0;//其他设备登录标示
    }else{
        height = 65;
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        static NSString* cellIdentifier = @"ZKPCStatusCellIdentifier";
        //        ZKPCStatusCell* cell = (MTTPCStatusCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //        if (!cell)
        //        {
        //            cell = [[MTTPCStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //        }
        //        if(!self.isMacOnline){
        //            [cell setHidden:YES];
        //        }
        //pc设备登录提示
        ZKNormalCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.backgroundColor=RGB(200, 200, 209);
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(80, 12, SCREEN_WIDTH, 20)];
        label.text=@"ZKChat已在Mac登录";
        label.textColor=ZKGRAY;
        label.font=systemFont(14);
        
        [cell addSubview:label];
        cell.imageView.image = [UIImage imageNamed:@"mac_logined"];
        [cell setHidden:YES];
        return cell;
    }else{
        static NSString* cellIdentifier = @"ZKRecentUserCellIdentifier";
        ZKRecentUserCell* cell = (ZKRecentUserCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[ZKRecentUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
                NSInteger row = [indexPath row];
        UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
        view.backgroundColor=RGB(229, 229, 229);
                ZKSessionEntity *session = self.dataSource[row];
                if(session.isFixedTop){
                    [cell setBackgroundColor:RGB(243, 243, 247)];
                }else{
                    [cell setBackgroundColor:[UIColor whiteColor]];
                }
        cell.selectedBackgroundView=view;
        [cell setShowSession:self.dataSource[row]];
        [self preLoadMessage:self.dataSource[row]];
        return cell;
    }
    
}
#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //        NSInteger row = [indexPath row];
        //        MTTSessionEntity *session = self.items[row];
        [ZKChattingMainViewController shareInstance].title=@"张阔";
        //        [[ZKChattingMainViewController shareInstance] showChattingContentForSession:session];
        [self pushViewController:[ZKChattingMainViewController shareInstance] animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSUInteger row = [indexPath row];
    //    MTTSessionEntity *session = self.items[row];
    //    [[SessionModule instance] removeSessionByServer:session];
    //    [self.items removeObjectAtIndex:row];
    //    [self setToolbarBadge:[[SessionModule instance]getAllUnreadMessageCount]];
    //    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return NO;
    }
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)preLoadMessage:(ZKSessionEntity *)session
{
    [[ZKDatabaseUtil instance] getLastestMessageForSessionID:session.sessionID completion:^(ZKMessageEntity *message, NSError *error) {
        if (message) {
            if (message.msgID != session.lastMsgID ) {
                [[DDMessageModule shareInstance] getMessageFromServer:session.lastMsgID currentSession:session count:20 Block:^(NSMutableArray *array, NSError *error) {
                    [[ZKDatabaseUtil instance] insertMessages:array success:^{
                        
                    } failure:^(NSString *errorDescripe) {
                        
                    }];
                }];
            }
        }else{
            if (session.lastMsgID !=0) {
                [[DDMessageModule shareInstance] getMessageFromServer:session.lastMsgID currentSession:session count:20 Block:^(NSMutableArray *array, NSError *error) {
                    [[ZKDatabaseUtil instance] insertMessages:array success:^{
                        
                    } failure:^(NSString *errorDescripe) {
                        
                    }];
                }];
            }
        }
    }];
}

@end
