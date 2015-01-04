//
//  MPAboutViewController.m
//  MPHome
//
//  Created by oasis on 1/2/15.
//  Copyright (c) 2015 watchpup. All rights reserved.
//

#import "MPAboutViewController.h"
#import "TextFormatter.h"
#import <MessageUI/MessageUI.h>

static const CGFloat kCellMargin = 10.0f;

@interface MPAboutViewController () <MFMailComposeViewControllerDelegate>
{
    NSMutableArray *_contentTitles;
    NSMutableArray *_contentCells;
    NSMutableArray *_cellHeights;
    
    MFMailComposeViewController *_mailComposer;
}
@end

@implementation MPAboutViewController

- (void)loadView {
    self.tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
    self.title = NSLocalizedString(@"About", "About title");

    [self buildTitles];
    [self buildContentCells];
}

- (void)buildTitles {
    _contentTitles = [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"AboutTitle", @"About Title"), NSLocalizedString(@"HelpTitle", @"Help Title"), NSLocalizedString(@"FeedbackTitle", @"Feedback Title"), nil];
}

- (void)buildContentCells {

    NSArray *contents = [NSArray arrayWithObjects:NSLocalizedString(@"AboutText", @"About Text"),
                         NSLocalizedString(@"HelpText", @"Help Text"), nil];
    
    _contentCells = [[NSMutableArray alloc]init];
    _cellHeights = [[NSMutableArray alloc]init];
    
    CGFloat cellWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    
    // add about and help content
    for (NSInteger i = 0; i < contents.count; i++) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, 100)];
        CGRect cellFrame = textView.frame;
        textView.attributedText = [TextFormatter formatHelpText:[contents objectAtIndex:i]];
        CGFloat textHeight = [TextFormatter heightForText:textView.attributedText Width:cellWidth];
        cellFrame.size.height = textHeight + kCellMargin;
        textView.frame = cellFrame;
        textView.editable = NO;
        [cell addSubview:textView];
        
        [_contentCells addObject:cell];
        NSNumber *height = [NSNumber numberWithFloat:textHeight + kCellMargin];
        [_cellHeights addObject:height];
    }
    
    // add feedback button
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSLog(@"cell width %f, height %f", cell.contentView.frame.size.width, cell.contentView.frame.size.height);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = cell.contentView.frame;
    
    [button setTitle:NSLocalizedString(@"FeedbackButtonTitle", "Feedback button title") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    [_cellHeights addObject:[NSNumber numberWithFloat:button.frame.size.height]];
    
    [_contentCells addObject:cell];
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

- (void)sendMail:(id)sender {
    _mailComposer = [[MFMailComposeViewController alloc]init];
    _mailComposer.mailComposeDelegate = self;
    [_mailComposer setToRecipients:[NSArray arrayWithObject:@"support@ihomedec.com"]];
    [_mailComposer setSubject:NSLocalizedString(@"MailSubject", @"Feedback mail subject")];
    [_mailComposer setMessageBody:NSLocalizedString(@"MailBody", @"Feedback mail body") isHTML:NO];
    [self presentViewController:_mailComposer animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_contentCells count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cellHeights[indexPath.section] floatValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_contentCells objectAtIndex:indexPath.section];
}

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_contentTitles objectAtIndex:section];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
