//
//  CCLSettingsTableViewController.m
//  Chess Clock
//
//  Created by Daylen Yang on 2/7/14.
//  Copyright (c) 2014 Daylen Yang. All rights reserved.
//

#import "CCLSettingsTableViewController.h"
#import "DYUserDefaults.h"


@interface CCLSettingsTableViewController()

@property (weak, nonatomic) IBOutlet UITableViewCell *baseCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *incrementCell;

@property UIStepper *baseStep;
@property UIStepper *incrementStep;

@end

@implementation CCLSettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create some steppers
    self.baseStep = [[UIStepper alloc] init];
    self.incrementStep = [[UIStepper alloc] init];
    
    // Set stepper limits
    self.baseStep.minimumValue = 1;
    self.baseStep.maximumValue = 30;
    self.baseStep.stepValue = 1;
    self.incrementStep.minimumValue = 0;
    self.incrementStep.maximumValue = 15;
    self.incrementStep.stepValue = 1;
    
    // Add the target/action
    [self.baseStep addTarget:self action:@selector(stepped:) forControlEvents:UIControlEventValueChanged];
    [self.incrementStep addTarget:self action:@selector(stepped:) forControlEvents:UIControlEventValueChanged];
    
    // Populate text and steppers
    NSDictionary *settings = [DYUserDefaults getSettings];
    int base = [settings[@"Base"] intValue];
    int increment = [settings[@"Increment"] intValue];

    [self updateViewWithBase:base increment:increment];
    
    // Set the accessory view
    self.baseCell.accessoryView = self.baseStep;
    self.incrementCell.accessoryView = self.incrementStep;
    
}
- (IBAction)stepped:(id)sender
{
    
    // Update the view
    [self updateViewWithBase:(int)self.baseStep.value increment:(int)self.incrementStep.value];
}
- (void)updateViewWithBase:(int)base increment:(int)increment
{
    
    self.baseCell.detailTextLabel.text = [NSString stringWithFormat:@"%d min", base];
    self.incrementCell.detailTextLabel.text = [NSString stringWithFormat:@"%d sec", increment];
    
    self.baseStep.value = base;
    self.incrementStep.value = increment;

}

- (IBAction)closeSettings:(id)sender {
    // Store the step values into settings
    [DYUserDefaults setSettingForKey:@"Base" value:[NSNumber numberWithInt:self.baseStep.value]];
    [DYUserDefaults setSettingForKey:@"Increment" value:[NSNumber numberWithInt:self.incrementStep.value]];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
