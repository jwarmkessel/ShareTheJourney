// 
//  APHExerciseSurveyTaskViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHExerciseSurveyTaskViewController.h"
#import "APHExerciseMotivationIntroViewController.h"
#import "APHQuestionViewController.h"
#import "APHExerciseMotivationSummaryViewController.h"

static  NSString  *MainStudyIdentifier = @"com.breastcancer.exercisesurvey";

static  NSString  *kExerciseSurveyStep101 = @"exercisesurvey101";
static  NSString  *kExerciseSurveyStep102 = @"exercisesurvey102";
static  NSString  *kExerciseSurveyStep103 = @"exercisesurvey103";
static  NSString  *kExerciseSurveyStep104 = @"exercisesurvey104";
static  NSString  *kExerciseSurveyStep105 = @"exercisesurvey105";
static  NSString  *kExerciseSurveyStep106 = @"exercisesurvey106";
static  NSString  *kExerciseSurveyStep107 = @"exercisesurvey107";
static  NSString  *kExerciseSurveyStep108 = @"exercisesurvey108";

static NSString *kWalkFiveThousandSteps = @"Walk 5,000 steps every day";
static NSString *kExerciseEverySingleDay = @"Exercise Every Single Day for at least 30 minutes";
static NSString *kExerciseThreeTimesPerWeek = @"Exercise at least 3 times per week for at least 30 minutes";
static NSString *kWalkTenThousandSteps = @"Walk 10,000 steps at least 3 times per week";

@interface APHExerciseSurveyTaskViewController ()

@property (nonatomic, strong) NSString *previousStepIdentifier;
@property (strong, nonatomic) NSMutableDictionary *previousCachedAnswer;
@end

@implementation APHExerciseSurveyTaskViewController

/*********************************************************************************/
#pragma  mark  -  View Controller Methods
/*********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.previousCachedAnswer = [NSMutableDictionary new];
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
        RKSTActiveStep *step = [[RKSTActiveStep alloc] initWithIdentifier:kExerciseSurveyStep101];
        
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
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kExerciseSurveyStep105];
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kExerciseSurveyStep106];
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kExerciseSurveyStep107];
        
        [steps addObject:step];
    }
    
    {
        RKSTActiveStep  *step = [[RKSTActiveStep alloc] initWithIdentifier:kExerciseSurveyStep108];
        
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
    

    NSDictionary  *controllers = @{kExerciseSurveyStep101 : [APHExerciseMotivationIntroViewController class],
                                   kExerciseSurveyStep102 : [APHQuestionViewController class],
                                   kExerciseSurveyStep103 : [APHQuestionViewController class],
                                   kExerciseSurveyStep104 : [APHQuestionViewController class],
                                   kExerciseSurveyStep105 : [APHQuestionViewController class],
                                   kExerciseSurveyStep106 : [APHQuestionViewController class],
                                   kExerciseSurveyStep107 : [APHExerciseMotivationSummaryViewController class],
                                   kExerciseSurveyStep108 : [APCSimpleTaskSummaryViewController class]
                                   };
    
    Class  aClass = [controllers objectForKey:step.identifier];
    
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    
    if (step.identifier == kExerciseSurveyStep108 ) {
        controller = [[aClass alloc] initWithNibName:nil bundle:[NSBundle appleCoreBundle]];
    } else if ( step.identifier == kExerciseSurveyStep107) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"APHExerciseMotivationSummaryViewController"
                                                                 bundle:nil];
        
        controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"APHExerciseMotivationSummaryViewController"];
    }
    
    controller.delegate = self;
    controller.step = step;
    
    
    return controller;
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController {
    
    NSDictionary *stepQuestions = @{
                                    kExerciseSurveyStep102 : @"Why is this your goal?",
                                    kExerciseSurveyStep103 : @"What will you gain?",
                                    kExerciseSurveyStep104 : @"How does this benefit you?",
                                    kExerciseSurveyStep105 : @"Why?",
                                    kExerciseSurveyStep106 : @"How will you reach your goal?",
                                    };
    
    if (kExerciseSurveyStep101 == stepViewController.step.identifier) {
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Exercise Motivation", @"Exercise Motivation");
        
    } else if (kExerciseSurveyStep102 == stepViewController.step.identifier) {
        self.previousStepIdentifier = kExerciseSurveyStep101;
        RKSTStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:kExerciseSurveyStep101];
        
        APHQuestionViewController *questionVC = (APHQuestionViewController *)stepViewController;
        questionVC.previousAnswer.text = [self extractResult:stepResult withIdentifier:kExerciseSurveyStep101];
        questionVC.currentQuestion.text = [stepQuestions objectForKey:stepViewController.step.identifier];
        
        questionVC.scriptorium.text = self.previousCachedAnswer[kExerciseSurveyStep102];
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Exercise Motivation", @"Exercise Motivation");
        
    } else if (kExerciseSurveyStep103 == stepViewController.step.identifier) {
        self.previousStepIdentifier = kExerciseSurveyStep102;
        
        RKSTStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:kExerciseSurveyStep102];
        
        APHQuestionViewController *questionVC = (APHQuestionViewController *)stepViewController;
        questionVC.previousAnswer.text = [self extractResult:stepResult withIdentifier:self.previousStepIdentifier];
        questionVC.currentQuestion.text = [stepQuestions objectForKey:stepViewController.step.identifier];
        
        questionVC.scriptorium.text = self.previousCachedAnswer[kExerciseSurveyStep103];
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Exercise Motivation", @"Exercise Motivation");
        
    } else if (kExerciseSurveyStep104 == stepViewController.step.identifier) {
        self.previousStepIdentifier = kExerciseSurveyStep103;
        RKSTStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:kExerciseSurveyStep103];
        
        APHQuestionViewController *questionVC = (APHQuestionViewController *)stepViewController;
        questionVC.previousAnswer.text = [self extractResult:stepResult withIdentifier:self.previousStepIdentifier];
        questionVC.currentQuestion.text = [stepQuestions objectForKey:stepViewController.step.identifier];
        
        questionVC.scriptorium.text = self.previousCachedAnswer[kExerciseSurveyStep104];
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Exercise Motivation", @"Exercise Motivation");
        
    } else if (kExerciseSurveyStep105 == stepViewController.step.identifier) {
        self.previousStepIdentifier = kExerciseSurveyStep104;
        RKSTStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:kExerciseSurveyStep104];
        
        APHQuestionViewController *questionVC = (APHQuestionViewController *)stepViewController;
        questionVC.previousAnswer.text = [self extractResult:stepResult withIdentifier:self.previousStepIdentifier];
        questionVC.currentQuestion.text = [stepQuestions objectForKey:stepViewController.step.identifier];
        
        questionVC.scriptorium.text = self.previousCachedAnswer[kExerciseSurveyStep105];
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Exercise Motivation", @"Exercise Motivation");
        
    } else if (kExerciseSurveyStep106 == stepViewController.step.identifier) {
        self.previousStepIdentifier = kExerciseSurveyStep105;
        RKSTStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:kExerciseSurveyStep105];
        
        APHQuestionViewController *questionVC = (APHQuestionViewController *)stepViewController;
        questionVC.previousAnswer.text = [self extractResult:stepResult withIdentifier:self.previousStepIdentifier];
        questionVC.currentQuestion.text = [stepQuestions objectForKey:stepViewController.step.identifier];

        questionVC.scriptorium.text = self.previousCachedAnswer[kExerciseSurveyStep106];
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Exercise Motivation", @"Exercise Motivation");
        
    } else if (kExerciseSurveyStep107 == stepViewController.step.identifier) {
//        self.previousStepIdentifier = kExerciseSurveyStep106;
//        APHExerciseMotivationSummaryViewController *questionSummaryVC = (APHExerciseMotivationSummaryViewController *)stepViewController;
//        
//        NSArray *summaryLabels = @[questionSummaryVC.questionResult1, questionSummaryVC.questionResult2, questionSummaryVC.questionResult3, questionSummaryVC.questionResult4, questionSummaryVC.questionResult5];
//        
//        NSArray *stepIdentifiers = @[kExerciseSurveyStep101, kExerciseSurveyStep102, kExerciseSurveyStep103, kExerciseSurveyStep104, kExerciseSurveyStep105, kExerciseSurveyStep106, kExerciseSurveyStep107, kExerciseSurveyStep108];
//        
//        for (int i = 0; i < [summaryLabels count]; i++) {
//            NSString *stringIdentifier = [NSString stringWithFormat:@"exercisesurvey10%d", i+2];
//            RKSTStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:stepIdentifiers[i + 1]];
//            UILabel *label = (UILabel *) summaryLabels[i];
//            label.text = (NSString *) [self extractResult:stepResult withIdentifier:stringIdentifier];
//
//        }
//        
//        RKSTStepResult *stepResult = [taskViewController.result stepResultForStepIdentifier:stepIdentifiers[0]];
//        
//        NSString *selectedGoal = [self extractResult:stepResult withIdentifier:kExerciseSurveyStep101];
//        
//        NSArray *arrayOfGoalChoices = @[kExerciseEverySingleDay, kExerciseThreeTimesPerWeek, kWalkFiveThousandSteps, kWalkTenThousandSteps];
//
//        NSDictionary *goalImages = @{
//                                        kExerciseEverySingleDay : @"banner_exersiseeveryday",
//                                        kExerciseThreeTimesPerWeek : @"banner_exersise3x",
//                                        kWalkFiveThousandSteps : @"banner_5ksteps",
//                                        kWalkTenThousandSteps : @"banner_10ksteps"
//                                        };
//        
//        for (NSString *goalString in arrayOfGoalChoices) {
//            if ([goalString isEqualToString:selectedGoal]) {
//                
//                [questionSummaryVC.titleImageView setImage:[UIImage imageNamed:goalImages[goalString]]];
//                
//            }
//        }
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Exercise Goal Review", @"Exercise Goal Review");
        
        
    } else if (kExerciseSurveyStep108 == stepViewController.step.identifier) {
        
        taskViewController.navigationBar.topItem.title = NSLocalizedString(@"Activity Complete", @"Activity Complete");
    }
    
}

- (void)taskViewController:(RKSTTaskViewController *)taskViewController didChangeResult:(RKSTTaskResult *)result {
    NSLog(@"TaskVC didChangeResult");
    
    if (![self.currentStepViewController.step.identifier isEqualToString:kExerciseSurveyStep108]) {
        
        RKSTStepResult *stepResult = [result stepResultForStepIdentifier:self.currentStepViewController.step.identifier];
        
        RKSTDataResult *contentResult = (RKSTDataResult *)[stepResult resultForIdentifier:self.currentStepViewController.step.identifier];
        
        NSError* error;
        NSDictionary* stepResultJson = [NSJSONSerialization JSONObjectWithData:contentResult.data
                                                                       options:kNilOptions
                                                                         error:&error];
        NSLog(@"%@", [[NSString alloc] initWithData:contentResult.data encoding:NSUTF8StringEncoding]);
        
        self.previousCachedAnswer[self.currentStepViewController.step.identifier] = stepResultJson[@"result"];
    }
}

- (void)taskViewControllerDidComplete: (RKSTTaskViewController *)taskViewController
{
    [super taskViewControllerDidComplete:taskViewController];
    
}

/*********************************************************************************/
#pragma  mark  -  Helper Methods
/*********************************************************************************/
- (NSString *)extractResult:(RKSTStepResult *)result withIdentifier:(NSString *)identifier {
    
    RKSTDataResult *contentResult = (RKSTDataResult *)[result resultForIdentifier:identifier];
    
    NSError* error;
    NSDictionary* stepResultJson = [NSJSONSerialization JSONObjectWithData:contentResult.data
                                                         options:kNilOptions
                                                           error:&error];
    NSLog(@"%@", [[NSString alloc] initWithData:contentResult.data encoding:NSUTF8StringEncoding]);
    
    return [stepResultJson valueForKey:@"result"];
}
@end
