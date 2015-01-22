// 
//  APHDailyJournalTaskViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
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

static NSString *kMoodLogNoteText = @"APHMoodLogNoteText";

@interface APHDailyJournalTaskViewController  ( ) <NSObject>

@property (nonatomic, strong) NSDictionary *contentDictionary;
@property (strong, nonatomic) NSString *previousCachedAnswerString;

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
        RKSTStep  *step = [[RKSTStep alloc] initWithIdentifier:kDailyJournalStep102];
        
        [steps addObject:step];
    }
    
    {
        RKSTStep  *step = [[RKSTStep alloc] initWithIdentifier:kDailyJournalStep103];
        
        [steps addObject:step];
    }
    
    {
        RKSTStep  *step = [[RKSTStep alloc] initWithIdentifier:kDailyJournalStep104];
        
        [steps addObject:step];
    }

    //The identifier gets set as the title in the navigation bar.
    RKSTOrderedTask  *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Daily Journal" steps:steps];
    
    return  task;
}

- (NSString *)createResultSummary {
    
    NSString *contentString = self.contentDictionary[kMoodLogNoteText];
    return contentString;
}

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

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
    controller.step = step;
    
    
    return controller;
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController {

    if (kDailyJournalStep101 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Daily Journal", @"Daily Journal");
    } else if (kDailyJournalStep102 == stepViewController.step.identifier) {
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Daily Journal", @"Daily Journal");
        
        if (self.previousCachedAnswerString != nil) {
            APHNotesViewController *notesStepViewController = (APHNotesViewController *) stepViewController;
            notesStepViewController.scriptorium.text = self.previousCachedAnswerString;
        }
        
    } else if (kDailyJournalStep103 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Daily Journal", @"Daily Journal");

        RKSTStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:@"DailyJournalStep102"];
        RKSTTextQuestionResult *contentResult = (RKSTTextQuestionResult *)[stepResult.results lastObject];
        
        APHLogSubmissionViewController *logSubmissionStepVC = (APHLogSubmissionViewController *) stepViewController;
        logSubmissionStepVC.textView.text = contentResult.textAnswer;
        

        //Result of the text content
        self.contentDictionary = @{kMoodLogNoteText : contentResult.textAnswer};

    } else if (kDailyJournalStep104 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Activity Complete", @"Activity Complete");
    }
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController didChangeResult:(RKSTTaskResult *)result {
    NSLog(@"TaskVC didChangeResult");
    
    if([self.currentStepViewController.step.identifier isEqualToString:kDailyJournalStep102]) {
        RKSTStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:kDailyJournalStep102];

        if (stepResult) {
            RKSTTextQuestionResult *contentResult = (RKSTTextQuestionResult *)[stepResult.results lastObject];

            self.previousCachedAnswerString = contentResult.textAnswer;
        }
    }
}

- (void)taskViewControllerDidComplete: (RKSTTaskViewController *)taskViewController
{
    [super taskViewControllerDidComplete:taskViewController];

}

@end
