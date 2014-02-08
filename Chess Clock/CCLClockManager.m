//
//  CCLClockManager.m
//  Chess Clock
//
//  Created by Daylen Yang on 2/7/14.
//  Copyright (c) 2014 Daylen Yang. All rights reserved.
//

#import "CCLClockManager.h"

#define TIMER_INTERVAL 50

@interface CCLClockManager()

@property ACTIVE_INDEX activeIndex;
@property NSTimeInterval player0;
@property NSTimeInterval player1;
@property NSTimeInterval increment;

@property NSDate *lastDate;

@end

@implementation CCLClockManager

- (id)initWithBase:(long)baseSeconds increment:(long)incrementSeconds
{
    self = [super init];
    if (self) {
        self.activeIndex = NOBODY;
        self.player0 = baseSeconds;
        self.player1 = baseSeconds;
        self.increment = incrementSeconds;
    }
    return self;
}

- (void)start
{
    self.lastDate = [NSDate date];
    self.activeIndex = PLAYER_0;
    [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL / 1000.0 target:self selector:@selector(updateInterval:) userInfo:nil repeats:YES];
}
- (void)swap
{
    switch (self.activeIndex) {
        case NOBODY:
            return;
        case PLAYER_0:
            self.player0 += self.increment;
            self.activeIndex = PLAYER_1;
            break;
        case PLAYER_1:
            self.player1 += self.increment;
            self.activeIndex = PLAYER_0;
            break;
    }
}
- (void)stop
{
    self.activeIndex = NOBODY;
}
- (void)updateInterval:(NSTimer *)timer
{
    if (self.activeIndex == NOBODY) {
        [timer invalidate];
        return;
    }
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self.lastDate];
    self.lastDate = [NSDate date];
    
    if (self.activeIndex == PLAYER_0) {
        self.player0 -= delta;
    } else {
        self.player1 -= delta;
    }
    
    if (self.player0 <= 0 || self.player1 <= 0) {
        [timer invalidate];
    }
}

- (ACTIVE_INDEX)status
{
    return self.activeIndex;
}

- (NSString *)timeForPlayer:(int)index
{
    assert(index == 0 || index == 1);
    return [CCLClockManager stringForTimeInterval:(index == 0) ? self.player0 : self.player1];
}

+ (NSString *)stringForTimeInterval:(NSTimeInterval)interval
{
    NSInteger time = (NSInteger) interval;
    NSInteger sec = time % 60;
    NSInteger min = (time / 60) % 60;
    return [NSString stringWithFormat:@"%i:%02i", min, sec];
    
}

@end
