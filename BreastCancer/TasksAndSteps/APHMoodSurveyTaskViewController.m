//
//  APHMoodSurveyTaskViewController.m
//  BreastCancer
//
//  Created by Justin Warmkessel on 11/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHMoodSurveyTaskViewController.h"

static  NSString  *MainStudyIdentifier = @"com.breastcancer.moodsurvey";

static  NSString  *kMoodSurveyStep101 = @"moodsurvey101";
static  NSString  *kMoodSurveyStep102 = @"moodsurvey102";
static  NSString  *kMoodSurveyStep103 = @"moodsurvey103";
static  NSString  *kMoodSurveyStep104 = @"moodsurvey104";
static  NSString  *kMoodSurveyStep105 = @"moodsurvey105";
static  NSString  *kMoodSurveyStep106 = @"moodsurvey106";


@interface APHMoodSurveyTaskViewController ()

@end

@implementation APHMoodSurveyTaskViewController

/*********************************************************************************/
#pragma  mark  -  View Controller Methods
/*********************************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*********************************************************************************/
#pragma mark - Initialize
/*********************************************************************************/

+ (RKSTOrderedTask *)createTask:(APCScheduledTask *)scheduledTask
{
    NSMutableArray *steps = [NSMutableArray array];
    
    {
        RKSTInstructionStep *step = [[RKSTInstructionStep alloc] initWithIdentifier:kMoodSurveyStep101];
        step.title = NSLocalizedString(@"Heart Age Test", @"Heart Age Test");
        step.text = NSLocalizedString(@"The following few details about you will be used to calculate your heart age.",
                                      @"Requesting user to provide information to calculate their heart age.");
        step.detailText = nil;
        
        
        [steps addObject:step];
    }
    
    // Biographic and Demogrphic
    {
        NSMutableArray *stepQuestions = [NSMutableArray array];
        RKSTFormStep *step = [[RKSTFormStep alloc] initWithIdentifier:kMoodSurveyStep102
                                                                title:nil
                                                             subtitle:NSLocalizedString(@"To calculate your heart age, please enter a few details about yourself.",
                                                                                        @"To calculate your heart age, please enter a few details about yourself.")];
        step.optional = NO;
        
        {
            RKSTHealthKitCharacteristicTypeAnswerFormat *format = [RKSTHealthKitCharacteristicTypeAnswerFormat answerFormatWithCharacteristicType:[HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth]];
            
            RKSTFormItem *item = [[RKSTFormItem alloc] initWithIdentifier:kMoodSurveyStep103
                                                                     text:NSLocalizedString(@"Date of birth", @"Date of birth")
                                                             answerFormat:format];
            [stepQuestions addObject:item];
        }
        
        {
            RKSTHealthKitCharacteristicTypeAnswerFormat *format = [RKSTHealthKitCharacteristicTypeAnswerFormat answerFormatWithCharacteristicType:[HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex]];
            
            RKSTFormItem *item = [[RKSTFormItem alloc] initWithIdentifier:kMoodSurveyStep104
                                                                     text:NSLocalizedString(@"Gender", @"Gender")
                                                             answerFormat:format];
            [stepQuestions addObject:item];
        }
        
        {
            RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithTextOptions:@[@"African-American", @"Other"]
                                                                                     style:RKChoiceAnswerStyleSingleChoice];
            
            RKSTFormItem *item = [[RKSTFormItem alloc] initWithIdentifier:kMoodSurveyStep105
                                                                     text:NSLocalizedString(@"Ethnicity", @"Ethnicity")
                                                             answerFormat:format];
            [stepQuestions addObject:item];
        }
        
        [step setFormItems:stepQuestions];
        
        [steps addObject:step];
    }
    
    {
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep106
                                                                        title:@"No question"
                                                                       answer:[RKSTBooleanAnswerFormat new]];
        step.optional = NO;
        
        [steps addObject:step];
    }
    
    RKSTOrderedTask *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Heart Age Test" steps:steps];
    
    return task;
}



@end
