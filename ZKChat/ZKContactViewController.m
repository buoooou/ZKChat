//
//  ZKContactViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/22.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKContactViewController.h"
#import "ZKContactResultViewController.h"
#import "ZKConstant.h"
#import "ZKContactCell.h"
#import "ZKPublicProfileViewController.h"
#import "ZKUserEntity.h"

@interface ZKContactViewController ()<UISearchResultsUpdating>

@end

@implementation ZKContactViewController

- (id)init {
    self = [super init];
    if (self) {
        ZKContactResultViewController *contactResultController=[[ZKContactResultViewController alloc]init];
        self.searchResultController = contactResultController;
        self.tableViewStyle = UITableViewStylePlain;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor=[UIColor blueColor];
    self.dataSource=[[NSMutableArray alloc] initWithObjects:
     @"张阔",@"张硕",@"张鑫",
     nil];
    //消息初始化
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title=@"通讯录";
    [self.tableView reloadData];
    self.navigationController.navigationBarHidden =NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *text=@"神奇账号";
    UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 22)];
    [sectionHeadView setBackgroundColor:RGB(240, 240, 245)];
    UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4.5, SCREEN_WIDTH, 13)];
    [sectionHeaderLabel setText:text];
    [sectionHeaderLabel setTextColor:RGB(144,144, 148)];
    [sectionHeaderLabel setFont:systemFont(13)];
    [sectionHeadView addSubview:sectionHeaderLabel];
    return sectionHeadView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"contactsCell";
    ZKContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[ZKContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSString *s=self.dataSource[indexPath.row];
    [cell setCellContent:s Name:s];

    
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSArray *userArray =[self.dataSource objectAtIndex:0];
//    ZKUserEntity *user;
//    user = [userArray objectAtIndex:indexPath.row];
    ZKPublicProfileViewController *public = [ZKPublicProfileViewController new];
//    public.user=user;
    [self pushViewController:public animated:YES];
    
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // in subClass
    NSString * searchString = searchController.searchBar.text;
    
    if (searchString.length > 0) {
        NSLog(@"zhangkuo %@ ",searchString);
    }
    
    [self updateFilteredContentForProductName:searchString];
    if (self.searchController.searchResultsController) {
        
        ZKContactResultViewController *vc = (ZKContactResultViewController *)self.searchController.searchResultsController;
        vc.dataSource = self.filteredDataSource;
        [vc.tableView reloadData];
    }

    
}
- (void)updateFilteredContentForProductName:(NSString *)productName{
    
    // Update the filtered array based on the search text and scope.
    //搜索过滤。
    
}

@end
