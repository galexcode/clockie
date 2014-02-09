//
//  CCLViewController.m
//  Chess Clock
//
//  Created by Daylen Yang on 2/7/14.
//  Copyright (c) 2014 Daylen Yang. All rights reserved.
//

#import "CCLViewController.h"
#import "CCLClockManager.h"
#import "DYUserDefaults.h"

#define TIMER_INTERVAL 50


@interface CCLViewController ()

@property (nonatomic) CCLClockManager *clockMan;

@property (weak, nonatomic) IBOutlet UILabel *topClock;
@property (weak, nonatomic) IBOutlet UILabel *bottomClock;

@property (nonatomic) UILongPressGestureRecognizer *topRecog;
@property (nonatomic) UILongPressGestureRecognizer *bottomRecog;


@end

@implementation CCLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self resetClockManager];
    
    self.topRecog = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    self.bottomRecog = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    
    self.topRecog.minimumPressDuration = 0.0;
    self.bottomRecog.minimumPressDuration = 0.0;
    
    [self.topClock addGestureRecognizer:self.topRecog];
    [self.bottomClock addGestureRecognizer:self.bottomRecog];
    
    self.topRecog.delegate = self;
    self.bottomRecog.delegate = self;
    
    self.topClock.transform = CGAffineTransformMakeRotation(M_PI);
    
    
}

- (void)resetClockManager
{
    NSDictionary *settings = [DYUserDefaults getSettings];
    int base = [settings[@"Base"] intValue] * 60;
    int increment = [settings[@"Increment"] intValue];
    
	self.clockMan = [[CCLClockManager alloc] initWithBase:base increment:increment];
    [self updateLabels:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.clockMan.status == NOBODY || self.clockMan.status == DONE) {
        [self resetClockManager];
    }
}

- (void)updateLabels:(NSTimer *)timer
{
    self.topClock.text = [self.clockMan timeForPlayer:1];
    self.bottomClock.text = [self.clockMan timeForPlayer:0];

    switch (self.clockMan.status) {
        case NOBODY: case DONE:
            self.bottomClock.backgroundColor = [UIColor whiteColor];
            self.topClock.backgroundColor = [UIColor whiteColor];
            [timer invalidate];
            break;
        case PLAYER_0:
            self.bottomClock.backgroundColor = [UIColor orangeColor];
            self.topClock.backgroundColor = [UIColor whiteColor];
            break;
        case PLAYER_1:
            self.topClock.backgroundColor = [UIColor orangeColor];
            self.bottomClock.backgroundColor = [UIColor whiteColor];
            break;
    }
    
}

- (void)handleTapFrom:(UILongPressGestureRecognizer *)recognizer
{
    switch (self.clockMan.status) {
        case NOBODY:
            // Start the clock
            [self.clockMan startForIndex:(recognizer == self.topRecog) ? PLAYER_0 : PLAYER_1];
            [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL / 1000.0 target:self selector:@selector(updateLabels:) userInfo:nil repeats:YES];
            break;
        case DONE:
            // Do nothing. The user must reset.
            break;
        case PLAYER_0:
            if (recognizer == self.bottomRecog) {
                [self.clockMan swap];
            }
            break;
        case PLAYER_1:
            if (recognizer == self.topRecog) {
                [self.clockMan swap];
            }
            break;
    }
    
}
- (IBAction)pauseOrReset:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset Clocks" otherButtonTitles:nil];
    switch (self.clockMan.status) {
        case PLAYER_0: case PLAYER_1:
            // Pause
            [self.clockMan stop];
            break;
        case NOBODY: case DONE:
            // Reset
            [actionSheet showInView:self.view];
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self resetClockManager];
    }
}


@end
