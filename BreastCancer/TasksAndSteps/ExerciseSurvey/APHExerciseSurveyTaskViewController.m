//
//  APHExerciseSurveyTaskViewController.m
//  BreastCancer
//
//  Created by Justin Warmkessel on 11/23/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHExerciseSurveyTaskViewController.h"
#import "APHQuestionViewController.h"

static  NSString  *MainStudyIdentifier = @"com.breastcancer.exercisesurvey";

static  NSString  *kExerciseSurveyStep101 = @"exercisesurvey101";
static  NSString  *kExerciseSurveyStep102 = @"exercisesurvey102";
static  NSString  *kExerciseSurveyStep103 = @"exercisesurvey103";
static  NSString  *kExerciseSurveyStep104 = @"exercisesurvey104";
static  NSString  *kExerciseSurveyStep105 = @"exercisesurvey105";
static  NSString  *kExerciseSurveyStep106 = @"exercisesurvey106";
static  NSString  *kExerciseSurveyStep107 = @"exercisesurvey107";
static  NSString  *kExerciseSurveyStep108 = @"exercisesurvey108";

@interface APHExerciseSurveyTaskViewController ()

@end

@implementation APHExerciseSurveyTaskViewController

/*********************************************************************************/
#pragma  mark  -  View Controller Methods
/*********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

/*********************************************************************************/
#pragma  mark  -  Task Creation Methods
/*********************************************************************************/

+ (RKSTOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    
    {
        RKSTInstructionStep *step = [[RKSTInstructionStep alloc] initWithIdentifier:kExerciseSurveyStep101];
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kExerciseSurveyStep102];
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kExerciseSurveyStep103];
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kExerciseSurveyStep104];
        
        [steps addObject:step];
    }
    
    //The identifier gets set as the title in the navigation bar.
    RKSTOrderedTask  *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Journal" steps:steps];
    
    return  task;
}

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step {
    

    NSDictionary  *controllers = @{
                                   kExerciseSurveyStep102 : [APHQuestionViewController class],
                                   kExerciseSurveyStep103 : [APCStepViewController class],
                                   kExerciseSurveyStep104 : [APCStepViewController class]
                                   };
    
    Class  aClass = [controllers objectForKey:step.identifier];
    
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    
    if (step.identifier == kExerciseSurveyStep104 ) {
        controller = [[aClass alloc] initWithNibName:nil bundle:[NSBundle appleCoreBundle]];
    }
    
    controller.delegate = self;
    controller.step = step;
    
    
    return controller;
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController {
    
    
    if (kExerciseSurveyStep101 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Journal", @"Journal");
        
    } else if (kExerciseSurveyStep102 == stepViewController.step.identifier) {
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Enter Daily Log", @"Enter Daily Log");
        
    } else if (kExerciseSurveyStep103 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Log Submission", @"Log Submission");
        
        
    } else if (kExerciseSurveyStep104 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Log Complete", @"Log Complete");
    }
    
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController didChangeResult:(RKSTTaskResult *)result {
    NSLog(@"TaskVC didChangeResult");
    
}

- (void)taskViewControllerDidComplete: (RKSTTaskViewController *)taskViewController
{
    [super taskViewControllerDidComplete:taskViewController];
    
}

@end
