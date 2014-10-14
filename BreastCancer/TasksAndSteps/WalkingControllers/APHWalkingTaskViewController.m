//
//  APHWalkingTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHWalkingTaskViewController.h"

#import "APHWalkingIntroViewController.h"
#import "APHContentsViewController.h"
//#import "APHWalkingResultsViewController.h"
#import <objc/message.h>

static  NSString  *kWalkingStep101Key = @"Daily Journal Step 101";
static  NSString  *kWalkingStep102Key = @"Daily Journal Step 102";

@interface APHWalkingTaskViewController  ( )
{
//    NSInteger _count;
}

@end

@implementation APHWalkingTaskViewController

#pragma  mark  -  Initialisation


+ (RKTask *)createTask: (APCScheduledTask*) scheduledTask
{
    NSMutableArray  *steps = [NSMutableArray array];
    
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep101Key name:@"active step"];
        step.caption = NSLocalizedString(@"Measures Gait and Balance", @"");
        step.text = NSLocalizedString(@"You have 10 seconds to put this device in your pocket."
        @"After the phone vibrates, follow the instructions to begin.", @"");
        step.buzz = YES;
        step.vibration = YES;
        step.countDown = 10.0;
        [steps addObject:step];
    }
    {
        RKActiveStep* step = [[RKActiveStep alloc] initWithIdentifier:kWalkingStep102Key name:@"active step"];
        step.caption = NSLocalizedString(@"Walk out 20 Steps", @"");
        step.text = NSLocalizedString(@"Now please walk out 20 steps.", @"");
        [steps addObject:step];
    }
    
    RKTask  *task = [[RKTask alloc] initWithName:@"Daily Journal Task" identifier:@"Daily Journal Task" steps:steps];
    
    return  task;
}

- (instancetype)initWithTask:(id<RKLogicalTask>)task taskInstanceUUID:(NSUUID *)taskInstanceUUID
{
    self = [super initWithTask:task taskInstanceUUID:taskInstanceUUID];
    if (self) {
//        _count = 0;
    }
    return self;
}

#pragma  mark  -  Task View Controller Delegate Methods
- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldShowMoreInfoOnStep:(RKStep *)step
{
    return  NO;
}

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStep:(RKStep*)step
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
{
//    stepViewController.continueButtonOnToolbar = NO;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController didReceiveLearnMoreEventFromStepViewController:(RKStepViewController *)stepViewController
{
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{
    NSDictionary  *stepsToControllersMap = @{
                                             kWalkingStep101Key : [APHWalkingIntroViewController class],
                                             kWalkingStep102Key : [APHContentsViewController class]
                                           };
    
    RKStepViewController  *controller = nil;
    
    Class  classToCreate = stepsToControllersMap[step.identifier];
    controller = [[classToCreate alloc] initWithStep:step];
    controller.delegate = self;
    return  controller;
}


@end
