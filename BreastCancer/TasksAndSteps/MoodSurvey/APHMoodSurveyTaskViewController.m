// 
//  APHMoodSurveyTaskViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHMoodSurveyTaskViewController.h"
#import "APHHeartAgeIntroStepViewController.h"
#import "APHMoodSurveyCustomView.h"

static  NSString  *MainStudyIdentifier  = @"com.breastcancer.moodsurvey";

static  NSString  *kMoodSurveyStep101   = @"moodsurvey101";
static  NSString  *kMoodSurveyStep102   = @"moodsurvey102";
static  NSString  *kMoodSurveyStep103   = @"moodsurvey103";
static  NSString  *kMoodSurveyStep104   = @"moodsurvey104";
static  NSString  *kMoodSurveyStep105   = @"moodsurvey105";
static  NSString  *kMoodSurveyStep106   = @"moodsurvey106";
static  NSString  *kMoodSurveyStep107   = @"moodsurvey107";


@interface APHMoodSurveyTaskViewController ()

@property (strong, nonatomic) APHMoodSurveyCustomView *currentCustomView;
@property (strong, nonatomic) NSMutableDictionary *previousCachedAnswer;

@end

@implementation APHMoodSurveyTaskViewController

/*********************************************************************************/
#pragma  mark  -  View Controller Methods
/*********************************************************************************/

- (NSString *)createResultSummary {
    
    NSMutableDictionary *resultCollectionDictionary = [NSMutableDictionary new];
    NSArray *arrayOfResults = self.result.results;
    
    for (RKSTStepResult *stepResult in arrayOfResults) {
        if (stepResult.results.firstObject) {
            RKSTChoiceQuestionResult *questionResult = stepResult.results.firstObject;
            
            if (questionResult.choiceAnswers != nil) {
                resultCollectionDictionary[stepResult.identifier] = questionResult.choiceAnswers;
            }
        }
    }
    NSError *error = nil;
    
    NSData  *moodAnswersJson = [NSJSONSerialization dataWithJSONObject:resultCollectionDictionary options:0 error:&error];

    NSString *contentString = nil;

    if (!error) {
        contentString = [[NSString alloc] initWithData:moodAnswersJson encoding:NSUTF8StringEncoding];
    } else {
        APCLogError2(error);
    }

    return contentString;
}

/*********************************************************************************/
#pragma mark - Initialize
/*********************************************************************************/

+ (RKSTOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    
    NSDictionary  *questionAnswerDictionary = @{
                                                kMoodSurveyStep102 : @[@"Perfectly crisp concentration",
                                                                       @"No issues with concentration",
                                                                       @"Occasional difficulties with concentration",
                                                                       @"Difficulties with concentration",
                                                                       @"No concentration"],
                                                
                                                kMoodSurveyStep103 : @[@"The best I have felt",
                                                                       @"Better than usual",
                                                                       @"Normal",
                                                                       @"Down",
                                                                       @"Extremely down"],
                                                
                                                kMoodSurveyStep104 : @[@"Ready to take on the world",
                                                                       @"Filled with energy through the day",
                                                                       @"Energy to make it through the day",
                                                                       @"Basic functions",
                                                                       @"No energy"],
                                                
                                                kMoodSurveyStep105 : @[@"Eliminated all deficit sleep",
                                                                       @"Made up some deficit sleep",
                                                                       @"Almost enough sleep",
                                                                       @"Barely enough sleep",
                                                                       @"No real sleep"],
                                                
                                                kMoodSurveyStep106 : @[@"Activities that make you breathe hard and sweat",
                                                                       @"Walking",
                                                                       @"Standing",
                                                                       @"Sitting",
                                                                       @"Lying down"]
                                                };
    
    NSMutableArray *steps = [NSMutableArray array];
    
    {
        RKSTInstructionStep *step = [[RKSTInstructionStep alloc] initWithIdentifier:kMoodSurveyStep101];
        step.detailText = nil;
        
        
        [steps addObject:step];
    }
    
    {
        NSArray *imageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Clarity-1g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Clarity-2g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Clarity-3g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Clarity-4g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Clarity-5g"]];
        
        NSArray *selectedImageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Clarity-1p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Clarity-2p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Clarity-3p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Clarity-4p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Clarity-5p"]];
        
        NSArray *textDescriptionChoice = [questionAnswerDictionary objectForKey:kMoodSurveyStep102];
        
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[APHMoodSurveyTaskViewController moodValueForIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithStyle:RKChoiceAnswerStyleSingleChoice imageChoices:answerChoices];
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep102
                                                                        title:@"How were you feeling cognitively throughout the day?"
                                                                       answer:format];

        [steps addObject:step];
    }
    
    {
        
        NSArray *imageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Mood-1g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Mood-2g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Mood-3g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Mood-4g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Mood-5g"]];
        
        NSArray *selectedImageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Mood-1p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Mood-2p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Mood-3p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Mood-4p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Mood-5p"]];
        
        NSArray *textDescriptionChoice = [questionAnswerDictionary objectForKey:kMoodSurveyStep103];
        
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[APHMoodSurveyTaskViewController moodValueForIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithStyle:RKChoiceAnswerStyleSingleChoice imageChoices:answerChoices];
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep103
                                                                        title:@"What is your overall mood so far today?"
                                                                       answer:format];
        
        [steps addObject:step];
    }
    
    {
        NSArray *imageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Energy-1g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Energy-2g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Energy-3g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Energy-4g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Energy-5g"]];
        
        NSArray *selectedImageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Energy-1p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Energy-2p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Energy-3p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Energy-4p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Energy-5p"]];
        
        NSArray *textDescriptionChoice = [questionAnswerDictionary objectForKey:kMoodSurveyStep104];
        
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[APHMoodSurveyTaskViewController moodValueForIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithStyle:RKChoiceAnswerStyleSingleChoice imageChoices:answerChoices];
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep104
                                                                        title:@"What is your energy level like so far today?"
                                                                       answer:format];
        
        [steps addObject:step];
    }
    
    {
        NSArray *imageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Sleep-1g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Sleep-2g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Sleep-3g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Sleep-4g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Sleep-5g"]];
        
        NSArray *selectedImageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Sleep-1p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Sleep-2p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Sleep-3p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Sleep-4p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Sleep-5p"]];
        
        NSArray *textDescriptionChoice = [questionAnswerDictionary objectForKey:kMoodSurveyStep105];
        
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[APHMoodSurveyTaskViewController moodValueForIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithStyle:RKChoiceAnswerStyleSingleChoice imageChoices:answerChoices];
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep105
                                                                        title:@"Did you get enough quality sleep last night?"
                                                                       answer:format];
        
        [steps addObject:step];
    }
    
    {
        NSArray *imageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Exercise-1g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Exercise-2g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Exercise-3g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Exercise-4g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Exercise-5g"]];
        
        NSArray *selectedImageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Exercise-1p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Exercise-2p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Exercise-3p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Exercise-4p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Exercise-5p"]];
        
        NSArray *textDescriptionChoice = [questionAnswerDictionary objectForKey:kMoodSurveyStep106];
        
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[APHMoodSurveyTaskViewController moodValueForIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithStyle:RKChoiceAnswerStyleSingleChoice imageChoices:answerChoices];
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep106
                                                                        title:@"What level exercise are you getting today?"
                                                                       answer:format];
        
        [steps addObject:step];
    }
    
    {
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep107
                                                                        title:@"What level exercise are you getting today?"
                                                                       answer:nil];
        
        [steps addObject:step];
    }
    
    RKSTOrderedTask *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Mood Survey"
                                                                  steps:steps];
    
    return task;
}

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step {
    
    NSDictionary  *controllers = @{
                                   kMoodSurveyStep101 : [APHHeartAgeIntroStepViewController class],
                                   kMoodSurveyStep107 : [APCSimpleTaskSummaryViewController class]
                                   };
    
    Class  aClass = [controllers objectForKey:step.identifier];
    
    APCStepViewController  *controller = [[aClass alloc] initWithNibName:nil bundle:nil];
    
    if (step.identifier == kMoodSurveyStep107 ) {
        controller = [[aClass alloc] initWithNibName:nil bundle:[NSBundle appleCoreBundle]];
    }
    
    controller.delegate = self;
    controller.step = step;
    
    
    return controller;
}

+ (NSNumber *) moodValueForIndex:(int)indexValue {

    int aNum = 0;
    
    switch (indexValue) {
        case 0:
            aNum = 5;
            break;
        case 1:
            aNum = 4;
            break;
            
        case 2:
            aNum = 3;
            break;
            
        case 3:
            aNum = 2;
            break;
            
        case 4:
            aNum = 1;
            break;
    }
    
    return @(aNum);
}

@end
