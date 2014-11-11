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

static  NSString  *MainStudyIdentifier = @"com.breastcancer.dailyJournal";

static  NSString  *kDailyJournalStep101 = @"DailyJournalStep101";
static  NSString  *kDailyJournalStep102 = @"DailyJournalStep102";
static  NSString  *kDailyJournalStep103 = @"DailyJournalStep103";

@interface APHDailyJournalTaskViewController  ( ) <NSObject>

@property (strong, nonatomic) RKDataArchive *taskArchive;

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
    
    [self beginTask];
}

#pragma  mark  -  Task Creation Methods

+ (RKTask *)createTask:(APCScheduledTask *)scheduledTask
{
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    
    {
        RKIntroductionStep  *step = [[RKIntroductionStep alloc] initWithIdentifier:kDailyJournalStep101 name:@"Daily Journal"];
        step.caption = @"Daily Journal";
        step.explanation = @"";
        step.instruction = @"";
        [steps addObject:step];
    }
    
    {
        RKIntroductionStep  *step = [[RKIntroductionStep alloc] initWithIdentifier:kDailyJournalStep102 name:@"active step"];
        step.caption = @"Mood Log";
        [steps addObject:step];
    }

    RKTask  *task = [[RKTask alloc] initWithName:@"Daily Journal" identifier:@"Mood Logs Task" steps:steps];
    
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

#pragma  mark  -  Task View Controller Delegate Methods

- (BOOL)taskViewController:(RKTaskViewController *)taskViewController shouldPresentStepViewController:(RKStepViewController *)stepViewController
{
    return  YES;
}

- (void)taskViewController:(RKTaskViewController *)taskViewController willPresentStepViewController:(RKStepViewController *)stepViewController
{
    if (kDailyJournalStep102 == stepViewController.step.identifier) {
        stepViewController.continueButton = nil;
    } else if (kDailyJournalStep103 == stepViewController.step.identifier) {
        stepViewController.continueButton = [[UIBarButtonItem alloc] initWithTitle:@"Well done!" style:stepViewController.continueButton.style target:stepViewController.continueButton.target action:stepViewController.continueButton.action];
        stepViewController.continueButton = nil;
    }
}

- (RKStepViewController *)taskViewController:(RKTaskViewController *)taskViewController viewControllerForStep:(RKStep *)step
{
    NSDictionary  *controllers = @{
                                   kDailyJournalStep101 : [APHDailyJournalIntroViewController class],
                                   kDailyJournalStep102 : [APHContentsViewController class],
                                   kDailyJournalStep103 : [APHCommonTaskSummaryViewController class]
                                  };
    
    Class  aClass = [controllers objectForKey:step.identifier];
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    controller.resultCollector = self;
    controller.delegate = self;
    controller.title = @"Daily Journal";
    controller.step = step;
    
    return controller;
}

/*********************************************************************************/
#pragma  mark  - Private methods
/*********************************************************************************/

- (void)beginTask
{
    if (self.taskArchive)
    {
        [self.taskArchive resetContent];
    }
    
    self.taskArchive = [[RKDataArchive alloc] initWithItemIdentifier:[RKItemIdentifier itemIdentifierForTask:self.task] studyIdentifier:MainStudyIdentifier taskInstanceUUID:self.taskInstanceUUID extraMetadata:nil fileProtection:RKFileProtectionCompleteUnlessOpen];
    
}

/*********************************************************************************/
#pragma mark - Helpers
/*********************************************************************************/

-(void)sendResult:(RKResult*)result
{
    //TODO
    // In a real application, consider adding to the archive on a concurrent queue.
    NSError *err = nil;
    if (![result addToArchive:self.taskArchive error:&err])
    {
        // Error adding the result to the archive; archive may be invalid. Tell
        // the user there's been a problem and stop the task.
        NSLog(@"Error adding %@ to archive: %@", result, err);
    }
}


/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/
- (void)taskViewController:(RKTaskViewController *)taskViewController didProduceResult:(RKResult *)result {
    
    NSLog(@"didProduceResult = %@", result);
    
    if ([result isKindOfClass:[RKSurveyResult class]]) {
        RKSurveyResult* sresult = (RKSurveyResult*)result;
        
        for (RKQuestionResult* qr in sresult.surveyResults) {
            NSLog(@"%@ = [%@] %@ ", [[qr itemIdentifier] stringValue], [qr.answer class], qr.answer);
        }
    }
    
    
    [self sendResult:result];
    
    [super taskViewController:taskViewController didProduceResult:result];
}

- (void)taskViewControllerDidFail: (RKTaskViewController *)taskViewController withError:(NSError*)error{
    NSLog(@"taskViewControllerDidFail %@", error);

    [self.taskArchive resetContent];
    self.taskArchive = nil;
    
}

- (void)taskViewControllerDidCancel:(RKTaskViewController *)taskViewController{
    
    [taskViewController suspend];
    
    [self.taskArchive resetContent];
    self.taskArchive = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)taskViewControllerDidComplete: (RKTaskViewController *)taskViewController{
    
    [taskViewController suspend];
    
    NSError *err = nil;
    NSURL *archiveFileURL = [self.taskArchive archiveURLWithError:&err];
    if (archiveFileURL)
    {
        NSURL *documents = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        NSURL *outputUrl = [documents URLByAppendingPathComponent:[archiveFileURL lastPathComponent]];
        
        // This is where you would queue the archive for upload. In this demo, we move it
        // to the documents directory, where you could copy it off using iTunes, for instance.
        [[NSFileManager defaultManager] moveItemAtURL:archiveFileURL toURL:outputUrl error:nil];
        
        NSLog(@"outputUrl= %@", outputUrl);
        
        // When done, clean up:
        self.taskArchive = nil;
        if (archiveFileURL)
        {
            [[NSFileManager defaultManager] removeItemAtURL:archiveFileURL error:nil];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [super taskViewControllerDidComplete:taskViewController];
}

/*********************************************************************************/
#pragma mark - StepViewController Delegate Methods
/*********************************************************************************/

- (void)stepViewControllerWillBePresented:(RKStepViewController *)viewController
{
    viewController.skipButton = nil;
    viewController.continueButton = nil;
}

- (void)stepViewControllerDidFinish:(RKStepViewController *)stepViewController navigationDirection:(RKStepViewControllerNavigationDirection)direction
{
    [super stepViewControllerDidFinish:stepViewController navigationDirection:direction];
    
    stepViewController.continueButton = nil;
}

@end
