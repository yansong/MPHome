//
//  MPDetailViewController.m
//  MPHome
//
//  Created by oasis on 12/11/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPDetailViewController.h"
#import "Artwork.h"
#import "FakeDataLoader.h"
#import "PFDataLoader.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "TextFormatter.h"
#import <QuartzCore/QuartzCore.h>
#import "ARViewController.h"
#import "MPSpinnerView.h"

@interface MPDetailViewController()<ASNetworkImageNodeDelegate, ARViewControllerDelegate>
{
    Artwork* _artwork;
    UIScrollView *_scrollview;
    ASNetworkImageNode *_imageNode;
    CGFloat _contentHeight;
    CGFloat _contentWidth;
    CGRect _frameRect;
    MPSpinnerView *_spinner;
}
@end

@implementation MPDetailViewController

- (instancetype)initWithItemId:(NSString *)itemId{
    if (!(self = [super init]))
        return nil;
    _contentHeight = 0;
    [[PFDataLoader sharedInstance] getArtworkDetail:itemId completion:^(Artwork *artwork, NSError *error) {
        NSLog(@"Artwork %@", artwork);
        _artwork = artwork;
        
        // set frame width and height
        _frameRect = [[UIScreen mainScreen]applicationFrame];
        
        _contentWidth = _frameRect.size.width;
        _contentHeight = 0; // we start at 0
        
        [self buildDetailView];
    }];

    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)buildDetailView {
    _scrollview = [[UIScrollView alloc] initWithFrame:_frameRect];
    _scrollview.contentSize = _frameRect.size;
    _scrollview.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_scrollview];
    [self addImageView];
    [self addInfoBlockWithTitle:@"Artist" Content:_artwork.artistName];
    [self addInfoBlockWithTitle:@"Size" Content:[NSString stringWithFormat:@"%@ x %@", @(_artwork.width), @(_artwork.height)]];
    [self addInfoBlockWithTitle:@"Description" Content:_artwork.theDescription];
    
    // adjust scrollview height
    _scrollview.contentSize = CGSizeMake(_contentWidth, _contentHeight);
    //[self addARButton];
    [self addDismissButton];
}

- (void)addImageView {
    _imageNode = [[ASNetworkImageNode alloc]init];
    
    _imageNode.URL = [NSURL URLWithString:_artwork.featureUrlString];
    int width = [[UIScreen mainScreen]applicationFrame].size.width;
    int height = (float)_artwork.height / _artwork.width * width;
    
    _imageNode.frame = CGRectMake(0, _contentHeight, width, height);
    // height
    _contentHeight += height;
    
    NSLog(@"Fetching image from %@", _artwork.featureUrlString);
    
    _imageNode.delegate = self;
    [_scrollview addSubview:_imageNode.view];
    
    // Add spinner
    _spinner = [[MPSpinnerView alloc]initWithImage:[UIImage imageNamed:@"spinnerWhite"] Frame:_imageNode.frame];
    _spinner.backgroundColor = [UIColor blackColor];
    [_scrollview addSubview:_spinner];
}

- (void)addInfoBlockWithTitle:(NSString *)title Content:(NSString *)content {
    ASTextNode *textNode = [[ASTextNode alloc]init];
    textNode.attributedString = [TextFormatter formatTextForTitle:title Content:content];
    CGFloat blockHeight = [TextFormatter heightForText:textNode.attributedString Width:320];
    textNode.frame = CGRectMake(0, _contentHeight, _contentWidth, blockHeight);
    _contentHeight += blockHeight;
    
    [_scrollview addSubview:textNode.view];
}

- (void)addDismissButton {
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.tintColor = [UIColor whiteColor];
    //dismissButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    
    dismissButton.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    UIImage *buttonImage = [UIImage imageNamed:@"btnClose"];
    [dismissButton setImage:buttonImage forState:UIControlStateNormal];
    [dismissButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    dismissButton.layer.cornerRadius = 6;
    dismissButton.clipsToBounds = YES;
    [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[dismissButton]-20-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(dismissButton)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-25-[dismissButton]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(dismissButton)]];
}

- (void)addARButton {
    UIButton *arButton = [UIButton buttonWithType:UIButtonTypeSystem];
    arButton.translatesAutoresizingMaskIntoConstraints = NO;
    arButton.tintColor = [UIColor whiteColor];
    //dismissButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    
    arButton.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    UIImage *buttonImage = [UIImage imageNamed:@"btnAR"];
    [arButton setImage:buttonImage forState:UIControlStateNormal];
    [arButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    arButton.layer.cornerRadius = 6;
    arButton.clipsToBounds = NO;
    [arButton addTarget:self action:@selector(showAR:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:arButton];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-20-[arButton]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(arButton)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-25-[arButton]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(arButton)]];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)dismiss:(id)sender
{
    if (_delegate) {
        [_delegate didDismissDetailViewController];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:NULL];
    }
}

- (void)showAR:(id)sender {
    ARViewController *arViewController = [[ARViewController alloc]init];
    arViewController.delegate = self;
    
    [self presentViewController:arViewController animated:NO completion:nil];
}

# pragma mark - ASNetworkImageNodeDelegate
- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    NSLog(@"Image loaded");
    [_spinner removeFromSuperview];
    [self addARButton];
}

#pragma mark - ARViewControllerDelegate
- (void)didDismissARViewController {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
