// 
//  APHMoodSurveyTaskViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHMoodSurveyTaskViewController.h"
#import "APHHeartAgeIntroStepViewController.h"
#import "APHCustomSurveyIntroViewController.h"
#import "APHCustomSurveyQuestionViewController.h"
#import "APHDynamicMoodSurveyTask.h"

static  NSString  *MainStudyIdentifier  = @"com.breastcancer.moodsurvey";

static  NSString  *kMoodSurveyStep101   = @"moodsurvey101";
static  NSString  *kMoodSurveyStep102   = @"moodsurvey102";
static  NSString  *kMoodSurveyStep103   = @"moodsurvey103";
static  NSString  *kMoodSurveyStep104   = @"moodsurvey104";
static  NSString  *kMoodSurveyStep105   = @"moodsurvey105";
static  NSString  *kMoodSurveyStep106   = @"moodsurvey106";
static  NSString  *kMoodSurveyStep107   = @"moodsurvey107";
static  NSString  *kMoodSurveyStep108   = @"moodsurvey108";

static  NSString  *kCustomMoodSurveyStep101   = @"customMoodSurveyStep101";
static  NSString  *kCustomMoodSurveyStep102   = @"customMoodSurveyStep102";
static  NSString  *kCustomMoodSurveyStep103   = @"customMoodSurveyStep103";

static NSInteger const kNumberOfCompletionsUntilDisplayingCustomSurvey = 7;

@interface APHMoodSurveyTaskViewController ()

@property (strong, nonatomic) NSMutableDictionary *previousCachedAnswer;
@property (strong, nonatomic) NSString *customSurveyQuestion;

@end

@implementation APHMoodSurveyTaskViewController

/*********************************************************************************/
#pragma  mark  -  View Controller Methods
/*********************************************************************************/

//- (NSString *)createResultSummary {
//    
//    NSMutableDictionary *resultCollectionDictionary = [NSMutableDictionary new];
//    NSArray *arrayOfResults = self.result.results;
//    
//    for (RKSTStepResult *stepResult in arrayOfResults) {
//        if (stepResult.results.firstObject) {
//            RKSTChoiceQuestionResult *questionResult = stepResult.results.firstObject;
//            
//            if (questionResult.choiceAnswers != nil) {
//                resultCollectionDictionary[stepResult.identifier] = (NSNumber *)[questionResult.choiceAnswers firstObject];
//            }
//        }
//    }
//    NSError *error = nil;
//    
//    NSData  *moodAnswersJson = [NSJSONSerialization dataWithJSONObject:resultCollectionDictionary options:0 error:&error];
//
//    NSString *contentString = nil;
//
//    if (!error) {
//        contentString = [[NSString alloc] initWithData:moodAnswersJson encoding:NSUTF8StringEncoding];
//    } else {
//        APCLogError2(error);
//    }
//
//    return contentString;
//}

/*********************************************************************************/
#pragma mark - Initialize
/*********************************************************************************/

+ (id<RKSTTask>)createTask:(APCScheduledTask *)scheduledTask
{
    APHDynamicMoodSurveyTask *task = [[APHDynamicMoodSurveyTask alloc] init];
    
    return task;
}

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/


- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step {
    
    NSDictionary  *controllers = @{
                                   kMoodSurveyStep101 : [APHHeartAgeIntroStepViewController class],
                                   kMoodSurveyStep108 : [APCSimpleTaskSummaryViewController class]
                                   };
    
    Class  aClass = [controllers objectForKey:step.identifier];
    
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    
    if (step.identifier == kMoodSurveyStep108)
    {
        controller = [[aClass alloc] initWithNibName:nil bundle:[NSBundle appleCoreBundle]];
    }
    
    controller.delegate = self;
    controller.step = step;
    
    
    return controller;
}

- (void)taskViewControllerDidComplete:(RKSTTaskViewController *)taskViewController {
    [super taskViewControllerDidComplete:taskViewController];
    

    //Here we are keeping a count of the daily scales being completed. We are keeping track only up to 7.
    APCAppDelegate * delegate = (APCAppDelegate*)[UIApplication sharedApplication].delegate;
    if (delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter < kNumberOfCompletionsUntilDisplayingCustomSurvey) {
        delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter++;
    }
    
    NSString *string = [((APCAppDelegate*)[UIApplication sharedApplication].delegate) dataSubstrate].currentUser.customSurveyQuestion;
    
    
}


@end
