//
//  CCLViewController.m
//  Chess Clock
//
//  Created by Daylen Yang on 2/7/14.
//  Copyright (c) 2014 Daylen Yang. All rights reserved.
//

#import "CCLViewController.h"
#import "CCLClockManager.h"

#define TIMER_INTERVAL 50


@interface CCLViewController ()

@property (nonatomic) CCLClockManager *clockMan;

@property (weak, nonatomic) IBOutlet UILabel *topClock;
@property (weak, nonatomic) IBOutlet UILabel *bottomClock;

@property (nonatomic) UITapGestureRecognizer *topRecog;
@property (nonatomic) UITapGestureRecognizer *bottomRecog;

@end

@implementation CCLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.clockMan = [[CCLClockManager alloc] initWithBase:5 increment:0]; // TODO
    
    self.topRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    self.bottomRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    
    [self.topClock addGestureRecognizer:self.topRecog];
    [self.bottomClock addGestureRecognizer:self.bottomRecog];
    
    self.topRecog.delegate = self;
    self.bottomRecog.delegate = self;
    
    [self updateLabels:nil];
    [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL / 1000.0 target:self selector:@selector(updateLabels:) userInfo:nil repeats:YES];
}

- (void)updateLabels:(NSTimer *)timer
{
    NSLog(@"Updating labels");
    self.topClock.text = [self.clockMan timeForPlayer:1];
    self.bottomClock.text = [self.clockMan timeForPlayer:0];
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    if (self.clockMan.status == NOBODY) {
        NSLog(@"starting clock");
        [self.clockMan start];
    } else if (recognizer == self.topRecog && self.clockMan.status == PLAYER_1) {
        NSLog(@"Tapped top clock");
        [self.clockMan swap];
    } else if (recognizer == self.bottomRecog && self.clockMan.status == PLAYER_0) {
        NSLog(@"Tapped bottom clock");
        [self.clockMan swap];
    }
}


@end
