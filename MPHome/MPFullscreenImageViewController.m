//
//  MPFullscreenImageViewController.m
//  MPHome
//
//  Created by oasis on 12/31/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPFullscreenImageViewController.h"
#import "ARViewController.h"

@interface MPFullscreenImageViewController ()<ARViewControllerDelegate>
{
    UIImage *_image;
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer;

@end

@implementation MPFullscreenImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (!(self = [super init]))
        return nil;
    _image = image;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]applicationFrame]];
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc]initWithImage:_image];
    self.imageView.frame = (CGRect) {.origin = CGPointMake(0.0f, 0.0f), .size = _image.size};
    [self.scrollView addSubview:self.imageView];
    
    self.scrollView.contentSize = _image.size;
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapGesture.numberOfTapsRequired = 1;
    twoFingerTapGesture.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapGesture];
    
    [self addDismissButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect scrollViewFrame = self.view.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.view.bounds.size;
    CGRect contentFrame = self.imageView.frame;
    
    if (contentFrame.size.width < boundsSize.width) {
        contentFrame.origin.x = (boundsSize.width - contentFrame.size.width) / 2.0f;
    }
    else {
        contentFrame.origin.x = 0.0f;
    }
    
    if (contentFrame.size.height < boundsSize.height) {
        contentFrame.origin.y = (boundsSize.height - contentFrame.size.height) / 2.0f;
    }
    else {
        contentFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    CGSize scrollViewSize = self.view.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoom = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoom animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer {
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)showAR:(id)sender {
    ARViewController *arViewController = [[ARViewController alloc]init];
    arViewController.delegate = self;
    
    [self presentViewController:arViewController animated:NO completion:nil];
}

- (BOOL)shouldAutorotate {
    // not support for now
    return NO;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents];
}


#pragma mark - ARViewControllerDelegate
- (void)didDismissARViewController {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
