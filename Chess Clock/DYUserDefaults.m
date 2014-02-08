//
//  DYUserDefaults.m
//  Go To Bed
//
//  Created by Daylen Yang on 11/24/13.
//  Copyright (c) 2013 Daylen Yang. All rights reserved.
//

#import "DYUserDefaults.h"

@implementation DYUserDefaults

+ (NSDictionary *)defaultSettings
{
    return @{@"Base": @5, @"Increment": @0};
}
+ (NSDictionary *)getSettings
{
    NSDictionary *loadedSettings = [[NSUserDefaults standardUserDefaults] objectForKey:@"Notification Settings"];
    if (loadedSettings == nil) {
        // Create default preferences
        loadedSettings = [self defaultSettings];
        [DYUserDefaults setSettings:loadedSettings];
    }
    if ([loadedSettings objectForKey:@"Scheduled"] != nil) {
        [DYUserDefaults setSettings:loadedSettings];
    }
    return loadedSettings;
}
+ (void)setSettings:(NSDictionary *)settings
{
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"Notification Settings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)getSettingForKey:(id)key
{
    id setting = [[DYUserDefaults getSettings] objectForKey:key];
    if (setting == nil) {
        [self setSettingForKey:key value:[self defaultSettings][key]];
        return [self getSettingForKey:key];
    }
    return setting;
}
+ (void)setSettingForKey:(id)key value:(id)value
{
    NSMutableDictionary *settings = [[DYUserDefaults getSettings] mutableCopy];
    settings[key] = value;
    [DYUserDefaults setSettings:settings];
}




@end
