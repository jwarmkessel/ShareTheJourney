//
//  APHDailyJournalTaskViewController.m
//  BreastCancer
//
//  Created by Henry McGilton on 9/3/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHDailyJournalTaskViewController.h"

#import "APHDailyJournalTaskViewController.h"
#import "APHDailyJournalIntroViewController.h"
#import "APHContentsViewController.h"

#import "APHNotesViewController.h"
#import "APHLogSubmissionViewController.h"

static  NSString  *MainStudyIdentifier = @"com.breastcancer.dailyJournal";

static  NSString  *kDailyJournalStep101 = @"DailyJournalStep101";
static  NSString  *kDailyJournalStep102 = @"DailyJournalStep102";
static  NSString  *kDailyJournalStep103 = @"DailyJournalStep103";
static  NSString  *kDailyJournalStep104 = @"DailyJournalStep104";

@interface APHDailyJournalTaskViewController  ( ) <NSObject>

@end

@implementation APHDailyJournalTaskViewController

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
        RKSTInstructionStep *step = [[RKSTInstructionStep alloc] initWithIdentifier:kDailyJournalStep101];
        
        [steps addObject:step];
    }

    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kDailyJournalStep102];
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kDailyJournalStep103];
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kDailyJournalStep104];
        
        [steps addObject:step];
    }

    RKSTOrderedTask  *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Daily Journal" steps:steps];
    
    return  task;
}

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

/**
 * @brief Supply a custom view controller for a given step.
 * @discussion The delegate should provide a step view controller implementation for any custom step.
 * @return A custom view controller, or nil to use the default step controller for this step.
 */
- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step {
    
    NSDictionary  *controllers = @{
                                   kDailyJournalStep101 : [APHContentsViewController class],
                                   kDailyJournalStep102 : [APHNotesViewController class],
                                   kDailyJournalStep103 : [APHLogSubmissionViewController class],
                                   kDailyJournalStep104 : [APCSimpleTaskSummaryViewController class]
                                   };
    
    Class  aClass = [controllers objectForKey:step.identifier];
    
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    
    if (step.identifier == kDailyJournalStep104 ) {
        controller = [[aClass alloc] initWithNibName:nil bundle:[NSBundle appleCoreBundle]];
    }
    
    
    controller.delegate = self;
    controller.title = @"Daily Journal";
    controller.step = step;
    
    
    return controller;
}

/**
 * @brief Control whether the task controller proceeds to the next or previous step.
 * @return YES, if navigation can proceed to the specified step.
 */
//- (BOOL)taskViewController:(RKSTTaskViewController *)taskViewController shouldPresentStep:(RKSTStep *)step {
// 
//    return YES;
//}

/**
 * @brief Tells the delegate that a stepViewController is about to be displayed.
 * @discussion Provides an opportunity to modify the step view controller before presentation.
 */
- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController {

    
    if (kDailyJournalStep101 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Log History", @"Log History");
    } else if (kDailyJournalStep102 == stepViewController.step.identifier) {
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Enter Daily Log", @"Enter Daily Log");
        
    } else if (kDailyJournalStep103 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Log Submission", @"Log Submission");

    } else if (kDailyJournalStep104 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Log Complete", @"Log Complete");
        
    }
    
}

/**
 * @brief Tells the delegate that task result object has changed.
 */
- (void)taskViewController:(RKSTTaskViewController *)taskViewController didChangeResult:(RKSTTaskResult *)result {
    NSLog(@"TaskVC didChangeResult");
    
}

- (void)taskViewControllerDidComplete: (RKSTTaskViewController *)taskViewController
{
    [super taskViewControllerDidComplete:taskViewController];

}

@end
