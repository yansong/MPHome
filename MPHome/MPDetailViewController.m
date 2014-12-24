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

@interface MPDetailViewController()<ASNetworkImageNodeDelegate, ARViewControllerDelegate>
{
    Artwork* _artwork;
    UIScrollView *_scrollview;
    ASNetworkImageNode *_imageNode;
    CGFloat _contentHeight;
    
    CGImageRef _imageRef;
    NSInteger _imageWidth;
    NSInteger _imageHeight;
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
        [self buildDetailView];
    }];

    return self;
}

- (void)buildDetailView {
    CGRect fullscreenRect = [[UIScreen mainScreen]applicationFrame];
    _scrollview = [[UIScrollView alloc] initWithFrame:fullscreenRect];
    _scrollview.contentSize = CGSizeMake(320, 758);
    _scrollview.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_scrollview];
    [self addImageView];
    [self addInfoBlockWithTitle:@"Artist" Content:_artwork.artistName];
    [self addInfoBlockWithTitle:@"Size" Content:[NSString stringWithFormat:@"%@ x %@", @(_artwork.width), @(_artwork.height)]];
    [self addInfoBlockWithTitle:@"Description" Content:_artwork.theDescription];
    
    // adjust scrollview height
    _scrollview.contentSize = CGSizeMake(320, _contentHeight);
    //[self addARButton];
    [self addDismissButton];
}

- (void)addImageView {
    _imageNode = [[ASNetworkImageNode alloc]init];
    _imageNode.backgroundColor = [UIColor colorWithRed:0xe0/255.0 green:0xe0/255.0 blue:0xe0/255.0 alpha:1.0];
    
    _imageNode.URL = [NSURL URLWithString:_artwork.featureUrlString];
    int width = [[UIScreen mainScreen]applicationFrame].size.width;
    int height = (float)_artwork.height / _artwork.width * width;
    
    _imageNode.frame = CGRectMake(0, _contentHeight, width, height);
    // height
    _contentHeight += height;
    
    _imageNode.delegate = self;
    [_scrollview addSubview:_imageNode.view];
}

- (void)addInfoBlockWithTitle:(NSString *)title Content:(NSString *)content {
    ASTextNode *textNode = [[ASTextNode alloc]init];
    textNode.attributedString = [TextFormatter formatTextForTitle:title Content:content];
    CGFloat blockHeight = [TextFormatter heightForText:textNode.attributedString Width:320];
    textNode.frame = CGRectMake(0, _contentHeight, 320, blockHeight);
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
    ARViewController *arViewController = [[ARViewController alloc]initWithImage:_imageRef width:_imageWidth height:_imageHeight];
    arViewController.delegate = self;
    
    [self presentViewController:arViewController animated:NO completion:nil];
}

# pragma mark - ASNetworkImageNodeDelegate
- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    NSLog(@"Image loaded");
    _imageRef = [imageNode.image CGImage];
    _imageWidth = _artwork.width;
    _imageHeight = _artwork.height;
    
    [self addARButton];
}

#pragma mark - ARViewControllerDelegate
- (void)didDismissARViewController {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
