//
//  ZKTableViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/14.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseTableViewController.h"
#import "ZKConstant.h"
@interface ZKBaseTableViewController ()

@end

@implementation ZKBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.size.height -= (self.navigationController.viewControllers.count > 1 ? 0 : (CGRectGetHeight(self.tabBarController.tabBar.bounds)));
    _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:self.tableViewStyle];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (self.tableViewStyle == UITableViewStyleGrouped) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:_tableView.bounds];
        backgroundView.backgroundColor = _tableView.backgroundColor;
        _tableView.backgroundView = backgroundView;
    }
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:ZKBG];
    [self.tableView setBackgroundColor:ZKBG];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // in subClass
    
}
-(void)setupBackgroundImage:(UIImage *)backgroundImage
{
    
    UIImageView * backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    self.tableView.backgroundView=backgroundImageView;
}
#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // in subClass
    return nil;
}


@end
