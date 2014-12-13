//
//  MPDetailViewController.m
//  MPHome
//
//  Created by oasis on 12/11/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPDetailViewController.h"
#import "Artwork.h"
#import "MPDataLoader.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "TextFormatter.h"

@interface MPDetailViewController()
{
    Artwork* _artwork;
    UIScrollView *_scrollview;
    ASNetworkImageNode *_imageNode;
    CGFloat _contentHeight;
}
@end

@implementation MPDetailViewController

- (instancetype)initWithItemId:(NSString *)itemId{
    if (!(self = [super init]))
        return nil;
    _contentHeight = 0;
    _artwork = [[MPDataLoader sharedInstance]loadDataById:itemId];
    CGRect fullscreenRect = [[UIScreen mainScreen]applicationFrame];
    _scrollview = [[UIScrollView alloc] initWithFrame:fullscreenRect];
    _scrollview.contentSize = CGSizeMake(320, 758);
    _scrollview.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_scrollview];
    [self addImageView];
    [self addInfoBlockWithTitle:@"Artist" Content:_artwork.artist];
    [self addInfoBlockWithTitle:@"Size" Content:[NSString stringWithFormat:@"%d x %d", _artwork.width, _artwork.height]];
    [self addInfoBlockWithTitle:@"Description" Content:_artwork.theDescription];
    
    // adjust scrollview height
    _scrollview.contentSize = CGSizeMake(320, _contentHeight);
    [self addDismissButton];
    return self;
}

- (void)addImageView {
    _imageNode = [[ASNetworkImageNode alloc]init];
    _imageNode.backgroundColor = [UIColor colorWithRed:0xe0/255.0 green:0xe0/255.0 blue:0xe0/255.0 alpha:1.0];
    
    _imageNode.URL = [NSURL URLWithString:_artwork.imageUrlString];
    //_imageNode.URL = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Gustav_Klimt_-_Hope%2C_II_-_Google_Art_Project.jpg/888px-Gustav_Klimt_-_Hope%2C_II_-_Google_Art_Project.jpg?uselang=en-gb"];
    int width = [[UIScreen mainScreen]applicationFrame].size.width;
    int height = (float)_artwork.height / _artwork.width * width;
    
    _imageNode.frame = CGRectMake(0, _contentHeight, width, height);
    // height
    _contentHeight += height;
    
    NSLog(@"Fetching image from %@", _artwork.imageUrlString);
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
    dismissButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[dismissButton]-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(dismissButton)]];
}

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:NULL];
}


@end
