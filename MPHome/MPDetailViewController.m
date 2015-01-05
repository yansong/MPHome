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
#import "MPSpinnerView.h"
#import "MPFullscreenImageViewController.h"

static const CGFloat kOuterHPadding = 10.0f;

@interface MPDetailViewController()<ASNetworkImageNodeDelegate, MPFullscreenViewControllerDelegate>
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
        _frameRect.origin.y += 44.0f;
        _frameRect.size.height -= 44.0f;
        
        _contentWidth = _frameRect.size.width;
        _contentHeight = 0; // we start at 0
        
        [self buildDetailView];
    }];
    self.view.backgroundColor = [UIColor whiteColor];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    NSLog(@"ViewDidLoad");
}

- (void)adjustView {
    // ???: Don't know why, but when returning from fullscreen view, the scroll view moves down 64px, and heigh decreased same
    CGRect rect = _scrollview.frame;
    //NSLog(@"Scrollview %f, %f, %f, %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    rect.size.height += rect.origin.y;
    rect.origin.y = 0;
    _scrollview.frame = rect;
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    NSLog(@"Entered foreground");
    [self adjustView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //NSLog(@"viewWillAppear");
    [self adjustView];
}

- (void)buildDetailView {
    _scrollview = [[UIScrollView alloc] initWithFrame:_frameRect];
    _scrollview.contentSize = _frameRect.size;
    _scrollview.backgroundColor = [UIColor whiteColor];
    
    self.title = _artwork.title;
    
    [self.view addSubview:_scrollview];
    [self addImageView];
    
    [self addInfoBlockWithTitle:NSLocalizedString(@"Artist", "Artist name") Content:_artwork.artistName];
    [self addSeparatorAt:_contentHeight++];
    [self addInfoBlockWithTitle:NSLocalizedString(@"Size", "Artwork size")
                        Content:[NSString stringWithFormat:@"%@ x %@", @(_artwork.width), @(_artwork.height)]];
    [self addSeparatorAt:_contentHeight++];
    
    [self addInfoBlockWithTitle:NSLocalizedString(@"Year", "Created year") Content:_artwork.createYear];
    [self addSeparatorAt:_contentHeight++];
    [self addInfoBlockWithTitle:NSLocalizedString(@"Description", "Description of the artwork")
                        Content:_artwork.theDescription];
    
    // adjust scrollview height
    _scrollview.contentSize = CGSizeMake(_contentWidth, _contentHeight);
}

- (void)addImageView {
    _imageNode = [[ASNetworkImageNode alloc]init];
    
    _imageNode.URL = [NSURL URLWithString:_artwork.featureUrlString];
    int width = [[UIScreen mainScreen]applicationFrame].size.width;
    int height = (float)_artwork.height / _artwork.width * width;
    
    _imageNode.frame = CGRectMake(0, _contentHeight, width, height);
    // height
    _contentHeight += height;
    
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
    textNode.frame = CGRectMake(kOuterHPadding, _contentHeight + kOuterHPadding, _contentWidth - 2 * kOuterHPadding, blockHeight + 2 * kOuterHPadding);
    _contentHeight += blockHeight + 2 * kOuterHPadding;
    
    [_scrollview addSubview:textNode.view];
}

- (void)addSeparatorAt:(CGFloat)y{
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(3, y, 320, 1)];
    separator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    [_scrollview addSubview:separator];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}


- (void)imageViewTapped {
    NSLog(@"Image node tapped");
    MPFullscreenImageViewController *fullscreenVC = [[MPFullscreenImageViewController alloc]initWithImage:_imageNode.image];
    fullscreenVC.delegate = self;

    [self presentViewController:fullscreenVC animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - ASNetworkImageNodeDelegate
- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    NSLog(@"Image loaded");
    [_spinner removeFromSuperview];
    
    // enable tap to show fullscreen image view
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapped)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
}

#pragma mark - MPFullscreenViewControllerDelegate
- (void)didDismissFullscreenViewController {
    [self dismissViewControllerAnimated:NO completion:NULL];
    [UIViewController attemptRotationToDeviceOrientation];
}

@end
