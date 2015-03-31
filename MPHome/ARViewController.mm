//
//  ARViewController.m
//  MPHome
//
//  Created by oasis on 12/15/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "ARViewController.h"
#import <QCAR/QCAR.h>
#import <QCAR/TrackerManager.h>
#import <QCAR/ObjectTracker.h>
#import <QCAR/Trackable.h>
#import <QCAR/DataSet.h>
#import "AREAGLView.h"
#import "MPARSession.h"

@interface ARViewController()<MPARControl>
{
    AREAGLView *_eaglView;
    CGRect _viewFrame;
    
    QCAR::DataSet *_dataSetCurrent;
    QCAR::DataSet *_dataSetStones;
    
    MPARSession *_arSession;
    
    CGImageRef _arImageRef;
    NSInteger _arImageWidth;
    NSInteger _arImageHeight;
}
@end

@implementation ARViewController

- (instancetype)initWithImage:(CGImageRef)image width:(NSInteger)width height:(NSInteger)height {
    if (!(self = [super init]))
        return nil;
    
    _arImageRef = image;
    _arImageWidth = width;
    _arImageHeight = height;
    
    // Create ar session
    _arSession = [[MPARSession alloc] initWithDelegate:self];
    
    // Create the EAGLView with the screen dimensions
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    _viewFrame = screenBounds;
    
    // If this device has a retina display, scale the view bounds that will
    // be passed to QCAR; this allows it to calculate the size and position of
    // the viewport correctly when rendering the video background
    if (YES == _arSession.isRetinaDisplay) {
        _viewFrame.size.width *= 2.0;
        _viewFrame.size.height *= 2.0;
    }
    
    // TODO: auto focus
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseAR)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeAR)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    return self;
}

- (void)pauseAR {
    NSError *error = nil;
    if (![_arSession pauseAR:&error]) {
        NSLog(@"Error pausing AR: %@", [error description]);
    }
}

- (void)resumeAR {
    NSError *error = nil;
    if (![_arSession resumeAR:&error]) {
        NSLog(@"Error resuming AR: %@", [error description]);
    }
    // on resume, we reset the flash
    QCAR::CameraDevice::getInstance().setFlashTorchMode(false);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    // Create EAGLview
    _eaglView = [[AREAGLView alloc]initWithFrame:_viewFrame arSession:_arSession];
    [_eaglView setupArImage:_arImageRef width:_arImageWidth height:_arImageHeight];
    self.view = _eaglView;
    
    // TODO: show loading animation while AR is being initialized
    
    // MARK: Initialize AR session, QCAR starts to work
    [_arSession initAR:QCAR::GL_20 ARViewBoundsSize:_viewFrame.size orientation:UIInterfaceOrientationPortrait];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDismissButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_arSession stopAR:nil];
    
    // Be a good OpenGL ES citizen: now that QCAR is paused and the render
    // thread is not executing, inform the root view controller that the
    // EAGLView should finish any OpenGL ES commands
    [_eaglView finishOpenGLESCommands];
    [_eaglView freeOpenGLESResources];
}

- (void)addDismissButton {
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.tintColor = [UIColor whiteColor];
    
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

- (void)dismiss:(id)sender
{
    if (_delegate) {
        [_delegate didDismissARViewController];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:NULL];
    }
}

#pragma mark - MPARControl Protocol
// callback: the AR initialization is done
- (void)onInitARDone:(NSError *)error {
    // TODO: hide animation
    
    if (error == nil) {
        // If you want multiple targets being detected at once,
        // you can comment out this line
        //QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, 2);
        
        NSError *err = nil;
        // MARK: here we call startAR in onInitARDone:
        [_arSession startAR:QCAR::CameraDevice::CAMERA_BACK error:&err];
        
        // by default, we try to set the continuous auto focus mode
        QCAR::CameraDevice::getInstance().setFocusMode(QCAR::CameraDevice::FOCUS_MODE_CONTINUOUSAUTO);
    }
    else {
        NSLog(@"Error initializing AR: %@", [error description]);
    }
}

- (BOOL)doInitTrackers {
    // Initialize the image or marker tracker
    QCAR::TrackerManager &trackerManager = QCAR::TrackerManager::getInstance();
    
    QCAR::Tracker *trackerBase = trackerManager.initTracker(QCAR::ObjectTracker::getClassType());
    if (trackerBase == NULL) {
        NSLog(@"Failed to initialize ObjectTracker.");
        return NO;
    }
    NSLog(@"Successfully initialized ObjectTracker.");
    return YES;
}

- (BOOL)doLoadTrackersData {
    // MARK: Load tracker data file
    _dataSetStones = [self loadObjectTrackerDataSet:@"mpath_t02.xml"];
    
    if (_dataSetStones == NULL) {
        NSLog(@"Failed to load datasets.");
        return NO;
    }
    if (![self activateDataSet:_dataSetStones]) {
        NSLog(@"Failed to activate dataset.");
        return NO;
    }
    
    return YES;
}

- (BOOL)doStartTrackers {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker *tracker = trackerManager.getTracker(QCAR::ObjectTracker::getClassType());
    if (tracker == 0) {
        return NO;
    }
    
    // MARK: Start track
    tracker->start();
    return YES;
}

- (BOOL)doStopTrackers {
    QCAR::TrackerManager &trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker *tracker = trackerManager.getTracker(QCAR::ObjectTracker::getClassType());
    
    if (NULL != tracker) {
        tracker->stop();
        NSLog(@"INFO: successfully stopped tracker.");
        return YES;
    }
    else {
        NSLog(@"ERROR: failed to get the tracker from the tracker manager.");
        return NO;
    }
}

- (BOOL)doUnloadTrackersData {
    [self deactivateDataSet: _dataSetCurrent];
    _dataSetCurrent = nil;
    
    // get the image tracker
    QCAR::TrackerManager &trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker *objectTracker = static_cast<QCAR::ObjectTracker *>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    // destroy the data set
    if (!objectTracker->destroyDataSet(_dataSetStones)) {
        NSLog(@"Failed to destroy data set stones.");
    }
    
    NSLog(@"dataset destroyed.");
    return YES;
}

- (BOOL)doDeinitTrackers {
    return YES;
}

- (void)onQCARUpdate:(QCAR::State *)state {
    
}

#pragma mark - Private functions
- (QCAR::DataSet *)loadObjectTrackerDataSet:(NSString *)dataFile {
    NSLog(@"loadObjectTrackerDataSet (%@)", dataFile);
    QCAR::DataSet *dataSet = NULL;
    
    // Get the QCAR tracker manager image tracker
    QCAR::TrackerManager &trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker *objectTracker = static_cast<QCAR::ObjectTracker *>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    if (NULL == objectTracker) {
        NSLog(@"ERROR: failed to get the ObjectTracker from the tracker manager.");
    }
    else {
        dataSet = objectTracker->createDataSet();
        
        if (NULL != dataSet) {
            NSLog(@"INFO: successfully loaded data set.");
            
            // Load the data set from the app's resources location
            if (!dataSet->load([dataFile cStringUsingEncoding:NSASCIIStringEncoding], QCAR::STORAGE_APPRESOURCE)) {
                NSLog(@"ERROR: failed to load data set.");
                objectTracker->destroyDataSet(dataSet);
                dataSet = NULL;
            }
        }
        else {
            NSLog(@"ERROR: failed to create data set");
        }
    }
    
    return dataSet;
}

- (BOOL)activateDataSet:(QCAR::DataSet *)theDataSet {
    // if we've previously recorded an activation, deactivate it
    if (_dataSetCurrent != nil) {
        [self deactivateDataSet:_dataSetCurrent];
    }
    BOOL success = NO;
    
    // Get the image tracker
    QCAR::TrackerManager &trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker *objectTracker = static_cast<QCAR::ObjectTracker *>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    if (objectTracker == NULL) {
        NSLog(@"Failed to unload tracking data set because the ObjectTracker has not been initialized.");
    }
    else {
        // Activate the data set
        if (!objectTracker->activateDataSet(theDataSet)) {
            NSLog(@"Failed to activate data set.");
        }
        else {
            NSLog(@"Successfully activated data set.");
            _dataSetCurrent = theDataSet;
            success = YES;
        }
    }
    
    // we set the off target tracking mode to the current state
    if (success) {
        [self setExtendedTrackingForDataSet:_dataSetCurrent start:NO];
    }
    
    return success;
}

- (BOOL)deactivateDataSet:(QCAR::DataSet *)theDataSet {
    if ((_dataSetCurrent == nil) || (theDataSet != _dataSetCurrent)) {
        NSLog(@"Invalid request to deactivate data set.");
        return NO;
    }
    
    BOOL success = NO;
    
    // we deactivate the enhanced tracking
    [self setExtendedTrackingForDataSet:theDataSet start:NO];
    
    // get the image tracker:
    QCAR::TrackerManager &trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::ObjectTracker *objectTracker = static_cast<QCAR::ObjectTracker *>(trackerManager.getTracker(QCAR::ObjectTracker::getClassType()));
    
    if (objectTracker == NULL) {
        NSLog(@"Failed to unload tracking data set because the ObjectTracker has not been initialized.");
    }
    else {
        // Deactivate the data set
        if (!objectTracker->deactivateDataSet(theDataSet)) {
            NSLog(@"Failed to deactivate data set.");
        }
        else {
            success = YES;
        }
    }
    
    _dataSetCurrent = nil;
    
    return success;
}

- (BOOL)setExtendedTrackingForDataSet:(QCAR::DataSet *)theDataSet start:(BOOL) start {
    BOOL result = YES;
    
    for (int tIdx = 0; tIdx < theDataSet->getNumTrackables(); tIdx++) {
        QCAR::Trackable *trackable = theDataSet->getTrackable(tIdx);
        if (start) {
            if (!trackable->startExtendedTracking()) {
                NSLog(@"Failed to start extended tracking on: %s", trackable->getName());
                result = NO;
            }
        }
        else {
            if (!trackable->stopExtendedTracking()) {
                NSLog(@"Failed to stop extended tracking on: %s", trackable->getName());
                result = NO;
            }
        }
    }
    return result;
}

@end
