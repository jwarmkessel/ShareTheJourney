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
#import "APHCommonTaskSummaryViewController.h"

#import "APHNotesViewController.h"

static  NSString  *MainStudyIdentifier = @"com.breastcancer.dailyJournal";

static  NSString  *kDailyJournalStep101 = @"DailyJournalStep101";
static  NSString  *kDailyJournalStep102 = @"DailyJournalStep102";
static  NSString  *kDailyJournalStep103 = @"DailyJournalStep103";
static  NSString  *kDailyJournalStep104 = @"DailyJournalStep104";

@interface APHDailyJournalTaskViewController  ( ) <NSObject>

@property  (nonatomic, weak)  APCStepProgressBar  *progressor;

@end

@implementation APHDailyJournalTaskViewController

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma  mark  -  Task Creation Methods

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
        RKSTInstructionStep  *step = [[RKSTInstructionStep alloc] initWithIdentifier:kDailyJournalStep104];
        
        [steps addObject:step];
    }

    RKSTOrderedTask  *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Daily Journal" steps:steps];
    
    return  task;
}

#pragma  mark  -  Navigation Bar Button Action Methods

- (void)cancelButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{ } ];
}

- (void)doneButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{ } ];
}



/*********************************************************************************/
#pragma  mark  - Private methods
/*********************************************************************************/


/*********************************************************************************/
#pragma mark - Helpers
/*********************************************************************************/


/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/
/**
 * @brief Successful completion of a step that has no steps after it.
 */
- (void)taskViewControllerDidComplete:(RKSTTaskViewController *)taskViewController {
    
}

/**
 * @brief Reports an error during the task.
 */
- (void)taskViewController:(RKSTTaskViewController *)taskViewController didFailOnStep:(RKSTStep *)step withError:(NSError *)error {
    NSLog(@"Error");
}

/**
 * @brief The task was cancelled by participant or the developer.
 */
- (void)taskViewControllerDidCancel:(RKSTTaskViewController *)taskViewController {
    
    
}
/**
 * @brief Check whether there is "Learn More" content for this step
 * @return NO if there is no additional content to display.
 */
- (BOOL)taskViewController:(RKSTTaskViewController *)taskViewController hasLearnMoreForStep:(RKSTStep *)step {
    return YES;
}

/**
 * @brief The user has tapped the "Learn More" button no the step.
 * @discussion Present a dialog or modal view controller containing the
 * "Learn More" content for this step.
 */
- (void)taskViewController:(RKSTTaskViewController *)taskViewController learnMoreForStep:(RKSTStepViewController *)stepViewController {
    
}

/**
 * @brief Supply a custom view controller for a given step.
 * @discussion The delegate should provide a step view controller implementation for any custom step.
 * @return A custom view controller, or nil to use the default step controller for this step.
 */
- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step {
    
    NSDictionary  *controllers = @{
                                   kDailyJournalStep101 : [APHContentsViewController class],
                                   
                                   kDailyJournalStep104 : [APHCommonTaskSummaryViewController class]
                                   };
    
    Class  aClass = [controllers objectForKey:step.identifier];
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    
    controller.delegate = self;
    controller.title = @"Daily Journal";
    controller.step = step;
    
    
    return controller;
}

/**
 * @brief Control whether the task controller proceeds to the next or previous step.
 * @return YES, if navigation can proceed to the specified step.
 */
- (BOOL)taskViewController:(RKSTTaskViewController *)taskViewController shouldPresentStep:(RKSTStep *)step {
 
    return YES;
}

/**
 * @brief Tells the delegate that a stepViewController is about to be displayed.
 * @discussion Provides an opportunity to modify the step view controller before presentation.
 */
- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController {

    if (kDailyJournalStep101 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Log History", @"Log History");
    } else if (kDailyJournalStep102 == stepViewController.step.identifier) {
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Enter Daily Log", @"Enter Daily Log");
        
        APHNotesViewController  *stenographer = [[APHNotesViewController alloc] initWithNibName:nil bundle:nil];
        
        //[stenographer.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        stenographer.view.frame = CGRectMake(0.0, 0.0, stepViewController.view.frame.size.width, stepViewController.view.frame.size.height);
        
        [stepViewController addChildViewController:stenographer];
        
        [stepViewController.view addSubview:stenographer.view];
        [stenographer didMoveToParentViewController:stepViewController];
        
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
    
}

/*********************************************************************************/
#pragma mark - StepViewController Delegate Methods
/*********************************************************************************/

//- (void)stepViewControllerWillBePresented:(RKSTStepViewController *)viewController
//{
//    viewController.skipButton = nil;
//}

//- (void)stepViewControllerDidFinish:(RKSTStepViewController *)stepViewController navigationDirection:(RKSTStepViewControllerNavigationDirection)direction
//{
//    [super stepViewControllerDidFinish:stepViewController navigationDirection:direction];
//}

@end
