//
//  APHSpecialSurveyTaskViewController.m
//  Parkinson
//
//  Created by Henry McGilton on 9/15/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHSpecialSurveyTaskViewController.h"

@interface APHSpecialSurveyTaskViewController ()

@end

@implementation APHSpecialSurveyTaskViewController

#pragma  mark  -  Initialisation

+ (RKTask *)createTask: (APCScheduledTask*) scheduledTask
{
    RKTask * task = [scheduledTask.task generateRKTaskFromTaskDescription];
    return  task;
}

- (instancetype)initWithTask:(id<RKLogicalTask>)task taskInstanceUUID:(NSUUID *)taskInstanceUUID
{
    self = [super initWithTask:task taskInstanceUUID:taskInstanceUUID];
    return self;
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
