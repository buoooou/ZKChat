//
//  ZKBaseSearchTableViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseSearchTableViewController.h"

@interface ZKBaseSearchTableViewController ()


@end

@implementation ZKBaseSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.searchController =[[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation=YES;
    
    self.searchController.searchBar.frame= CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 40);
    [self.searchController.searchBar setPlaceholder:@"搜索"];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.sectionIndexColor = [UIColor colorWithRed:0.122 green:0.475 blue:0.992 alpha:1.000];
    self.definesPresentationContext=YES;
    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -properties
-(NSMutableArray *)fileDataSource{
    if(!_filteredDataSource){
        _filteredDataSource=[[NSMutableArray alloc] initWithCapacity:1];
    }
    return _filteredDataSource;
}





@end
