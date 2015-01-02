//
//  MPAboutViewController.m
//  MPHome
//
//  Created by oasis on 1/2/15.
//  Copyright (c) 2015 watchpup. All rights reserved.
//

#import "MPAboutViewController.h"
#import "TextFormatter.h"

@interface MPAboutViewController () 

@property (nonatomic, strong) UITableViewCell *aboutCell;
@property (nonatomic, strong) UITableViewCell *helpCell;

@property (nonatomic, strong) UITextView *aboutTextView;
@property (nonatomic, strong) UITextView *helpTextView;

@property (nonatomic) CGFloat aboutViewHeight;
@property (nonatomic) CGFloat helpViewHeight;

@end

@implementation MPAboutViewController

- (void)loadView {
    self.tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
    self.title = NSLocalizedString(@"About", "About title");
    
    NSLog(@"size %f, %f", self.tableView.frame.size.width, self.tableView.frame.size.height);
    CGRect frame;
    
    // construct about cell, section 0, row 0
    self.aboutCell = [[UITableViewCell alloc]init];
    self.aboutTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    frame = self.aboutTextView.frame;
    self.aboutTextView.attributedText = [TextFormatter formatHelpText:NSLocalizedString(@"AboutText", @"About text")];
    self.aboutViewHeight= [TextFormatter heightForText:self.aboutTextView.attributedText Width:[[UIScreen mainScreen] applicationFrame].size.width];
    frame.size.height = self.aboutViewHeight + 10;
    self.aboutTextView.frame = frame;
    
    [self.aboutCell addSubview:self.aboutTextView];
    
    // construct help cell, section 1, row 0
    self.helpCell = [[UITableViewCell alloc]init];
    self.helpTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    self.helpTextView.attributedText = [TextFormatter formatHelpText:NSLocalizedString(@"HelpText", @"Help text")];
    self.helpViewHeight = [TextFormatter heightForText:self.helpTextView.attributedText Width:[[UIScreen mainScreen] applicationFrame].size.width];
    frame.size.height = self.helpViewHeight + 10;
    self.helpTextView.frame = frame;
    
    [self.helpCell addSubview:self.helpTextView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return self.aboutViewHeight + 10;
            break;
        case 1:
            return self.helpViewHeight + 10;
            break;
        default:
            break;
    };
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return self.aboutCell;
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    return self.helpCell;
                    break;
                    
                default:
                    break;
            }
        default:
            break;
    }
    
    return nil;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"AboutTitle", "About title");
            break;
        case 1:
            return NSLocalizedString(@"HelpTitle", "Help title");
            break;
            
        default:
            break;
    }
    return nil;
}

@end
