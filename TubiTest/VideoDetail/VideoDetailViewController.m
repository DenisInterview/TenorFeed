//
//  VideoDetailViewController.m
//  TubiTest
//
//  Created by Denis Kalashnikov on 2/16/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

#import "VideoDetailViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface VideoDetailViewController ()
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerLayer = [self playerLayer:self.videoURL];
    [self.view.layer insertSublayer:self.playerLayer
                              below:self.closeButton.layer];
    [self.playerLayer.player play];
}

- (AVPlayerLayer*)playerLayer:(NSURL*)mediaURL {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:[[AVPlayer alloc] initWithURL:mediaURL]];
        _playerLayer.frame = self.view.bounds;
    }
    return _playerLayer;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(replayMovie:) name: AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)replayMovie:(NSNotification *)notification {
    AVPlayerItem *player = [notification object];
    [player seekToTime:kCMTimeZero completionHandler:nil];
    [self.playerLayer.player play];
}

- (void)appDidEnterBackground {
    [self.playerLayer.player pause];
}

- (void)appDidBecomeActive {
    [self.playerLayer.player play];
}

- (IBAction)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CGRect frame = self.playerLayer.frame;
        frame.size = size;
        self.playerLayer.frame = frame;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

    }];
    
}
@end
