//
//  MPBrowseViewController.m
//  MPHome
//
//  Created by oasis on 12/9/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPBrowseViewController.h"
#import "MPCellNode.h"
#import "FakeDataLoader.h"

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "MPDetailViewController.h"
#import "MPSpinnerView.h"

@interface MPBrowseViewController () <ASTableViewDataSource, ASTableViewDelegate, DetailViewControllerDelegate>
{
    ASTableView *_tableView;
    NSMutableArray *_masterpieces;
    MPSpinnerView *_spinner;
}

@end

@implementation MPBrowseViewController

#pragma mark - MPBrowseViewController
- (instancetype)init {
    if (!(self = [super init]))
        return nil;

    // initialize data
    [[PFDataLoader sharedInstance]getArtworksWithCompletion:^(NSMutableArray *artworks, NSError *error) {
        if (artworks != nil) {
            _masterpieces = artworks;
            [_tableView reloadData];
            if (_spinner) {
                [_spinner removeFromSuperview];
            }
        }
    }];
    
    // initialize tableview
    _tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.asyncDataSource = self;
    _tableView.asyncDelegate = self;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View did load");

    // register cell class
    //NSString *cellIdentifier = @"MPCellIdentifier";
    //[_tableView registerClass:[MPCellNode class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:_tableView];
    _spinner = [[MPSpinnerView alloc]initWithImage:[UIImage imageNamed:@"spinner"] Frame:self.view.frame];
    _spinner.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_spinner];
}

- (void)viewWillLayoutSubviews {
    _tableView.frame = self.view.bounds;
}

// Disable auto rotate
- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - ASTableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _masterpieces.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *cellIdentifier = @"MPCellIdentifier";

    //MPCellNode *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Artwork *artwork = [[Artwork alloc]initWithPFObject:[_masterpieces objectAtIndex:indexPath.row]];
    MPCellNode *node = [[MPCellNode alloc]initWithArtwork:artwork];
    return node;
}

#pragma mark - UITablevieDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row %ld selected", (long)indexPath.row);
    
    Artwork *artwork = [[Artwork alloc]initWithPFObject:[_masterpieces objectAtIndex:indexPath.row]];
    MPDetailViewController *detailView = [[MPDetailViewController alloc] initWithItemId:artwork.artworkId];
    detailView.delegate = self;
    
    [self presentViewController:detailView animated:NO completion:nil];
}

#pragma mark - DetailViewControllerDelegate
- (void)didDismissDetailViewController {
    [self dismissViewControllerAnimated:NO completion:NULL];
}

@end
