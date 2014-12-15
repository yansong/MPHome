//
//  MPBrowseViewController.m
//  MPHome
//
//  Created by oasis on 12/9/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPBrowseViewController.h"
#import "MPCellNode.h"
#import "MPDataLoader.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "MPDetailViewController.h"

static const NSInteger kInitialCount = 20;

@interface MPBrowseViewController () <ASTableViewDataSource, ASTableViewDelegate, DetailViewControllerDelegate>
{
    ASTableView *_tableView;
    NSMutableArray *_masterpieces;
}
@end

@implementation MPBrowseViewController

#pragma mark - MPBrowseViewController
- (instancetype)init {
    if (!(self = [super init]))
        return nil;

    // initialize data
    _masterpieces = [[MPDataLoader sharedInstance]loadData:kInitialCount];
    
    // initialize tableview
    _tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:0xe0 /255.0 green:0xe0/255.0 blue:0xe0/255.0 alpha:1.0];
    _tableView.asyncDataSource = self;
    _tableView.asyncDelegate = self;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View did load");
    
    [self.view addSubview:_tableView];
}

- (void)viewWillLayoutSubviews {
    _tableView.frame = self.view.bounds;
}


#pragma mark - ASTableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _masterpieces.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPCellNode *node = [[MPCellNode alloc]initWithArtwork:_masterpieces[indexPath.row]];
    return node;
}

#pragma mark - UITablevieDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row %ld selected", (long)indexPath.row);
    MPDetailViewController *detailView = [[MPDetailViewController alloc] initWithItemId:@"1"];
    detailView.delegate = self;
    
    [self presentViewController:detailView animated:NO completion:nil];
}

#pragma mark - DetailViewControllerDelegate
- (void)didDismissDetailViewController {
    [self dismissViewControllerAnimated:NO completion:NULL];
}

@end
