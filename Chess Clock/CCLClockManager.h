//
//  CCLClockManager.h
//  Chess Clock
//
//  Created by Daylen Yang on 2/7/14.
//  Copyright (c) 2014 Daylen Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ACTIVE_INDEX {
    NOBODY, PLAYER_0, PLAYER_1, DONE
} ACTIVE_INDEX;

@interface CCLClockManager : NSObject

- (id)initWithBase:(long)baseSeconds increment:(long)incrementSeconds;

- (void)start; // Starts clock for player 0
- (void)swap; // Swaps the clock and increments
- (void)stop; // Stops the clocks

- (ACTIVE_INDEX)status;

- (NSString *)timeForPlayer:(int)index; // Index is 0 or 1

@end
