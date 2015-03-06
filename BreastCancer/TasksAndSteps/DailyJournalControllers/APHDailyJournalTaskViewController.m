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

+ (ORKOrderedTask *)createTask:(APCScheduledTask *) __unused scheduledTask
{
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    
    {
        ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:kDailyJournalStep101];
        
        [steps addObject:step];
    }

    {
        ORKStep  *step = [[ORKStep alloc] initWithIdentifier:kDailyJournalStep102];
        
        [steps addObject:step];
    }
    
    {
        ORKStep  *step = [[ORKStep alloc] initWithIdentifier:kDailyJournalStep103];
        
        [steps addObject:step];
    }
    
    {
        ORKStep  *step = [[ORKStep alloc] initWithIdentifier:kDailyJournalStep104];
        
        [steps addObject:step];
    }

    //The identifier gets set as the title in the navigation bar.
    ORKOrderedTask  *task = [[ORKOrderedTask alloc] initWithIdentifier:@"My Journal" steps:steps];
    
    return  task;
}

- (NSString *)createResultSummary {
    
    NSString *contentString = self.contentDictionary[kMoodLogNoteText];
    return contentString;
}

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

- (ORKStepViewController *)taskViewController:(ORKTaskViewController *) __unused taskViewController viewControllerForStep:(ORKStep *)step {
    
    self.showsProgressInNavigationBar = NO;
    
    
    NSDictionary  *controllers = @{
                                   kDailyJournalStep101 : [APHContentsViewController class],
                                   kDailyJournalStep102 : [APHNotesViewController class],
                                   kDailyJournalStep103 : [APHLogSubmissionViewController class],
                                   kDailyJournalStep104 : [APCSimpleTaskSummaryViewController class]
                                   };
    
    Class  aClass = [controllers objectForKey:step.identifier];
    
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    
    if (step.identifier == kDailyJournalStep104 ) {
        APCSimpleTaskSummaryViewController *stepVC = [[APCSimpleTaskSummaryViewController alloc] initWithNibName:nil bundle:[NSBundle appleCoreBundle]];
        
        (void)stepVC.view;
        stepVC.delegate = self;
        stepVC.step = step;
        stepVC.youCanCompareMessage.text = nil;
        
        controller = stepVC;
    } else {
        controller.delegate = self;
        controller.step = step;
    }
    
    return controller;
}

- (void)taskViewController:(ORKTaskViewController *)taskViewController stepViewControllerWillAppear:(ORKStepViewController *)stepViewController {
    
    stepViewController.navigationController.navigationBar.topItem.title = @"My Journal";

    if (kDailyJournalStep101 == stepViewController.step.identifier) {
        
    } else if (kDailyJournalStep102 == stepViewController.step.identifier) {
        
        if (self.previousCachedAnswerString != nil) {
            APHNotesViewController *notesStepViewController = (APHNotesViewController *) stepViewController;
            notesStepViewController.scriptorium.text = self.previousCachedAnswerString;
        }
        
    } else if (kDailyJournalStep103 == stepViewController.step.identifier) {
        
        ORKStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:@"DailyJournalStep102"];
        APCDataResult *contentResult = (APCDataResult *)[stepResult resultForIdentifier:@"content"];
        
        NSError* error;
        NSDictionary* stepResultJson = [NSJSONSerialization JSONObjectWithData:contentResult.data
                                                                       options:kNilOptions
                                                                         error:&error];
        
        APHLogSubmissionViewController *logSubmissionStepVC = (APHLogSubmissionViewController *) stepViewController;
        logSubmissionStepVC.textView.text = stepResultJson[kMoodLogNoteText];
        
        //Result of the text content
        self.contentDictionary = stepResultJson;

    } else if (kDailyJournalStep104 == stepViewController.step.identifier) {
        stepViewController.navigationController.navigationBar.topItem.title = @"Activity Complete";
        
    }
}

- (void)taskViewController:(ORKTaskViewController *)taskViewController didChangeResult:(ORKTaskResult *) __unused result {
    NSLog(@"TaskVC didChangeResult");
    
    if([self.currentStepViewController.step.identifier isEqualToString:kDailyJournalStep102]) {
        ORKStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:kDailyJournalStep102];
        
        if (stepResult) {
            APCDataResult *contentResult = (APCDataResult *)[stepResult resultForIdentifier:@"content"];
            NSError* error;
            NSDictionary* stepResultJson = [NSJSONSerialization JSONObjectWithData:contentResult.data
                                                                           options:kNilOptions
                                                                             error:&error];
            NSLog(@"%@", [[NSString alloc] initWithData:contentResult.data encoding:NSUTF8StringEncoding]);
            
            self.previousCachedAnswerString = stepResultJson[kMoodLogNoteText];
        }
    }
}


@end
