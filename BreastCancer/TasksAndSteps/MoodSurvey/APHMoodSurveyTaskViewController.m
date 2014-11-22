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
static  NSString  *kMoodSurveyStep107 = @"moodsurvey107";


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
    
    // Biographic and Demographic
    {
        NSMutableArray *stepQuestions = [NSMutableArray array];
        RKSTFormStep *step = [[RKSTFormStep alloc] initWithIdentifier:kMoodSurveyStep102
                                                                title:nil
                                                             subtitle:NSLocalizedString(@"To calculate your heart age, please enter a few details about yourself.",
                                                                                        @"To calculate your heart age, please enter a few details about yourself.")];
        step.optional = NO;
    }
    
//        {
//            RKSTHealthKitCharacteristicTypeAnswerFormat *format = [RKSTHealthKitCharacteristicTypeAnswerFormat answerFormatWithCharacteristicType:[HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth]];
//            
//            RKSTFormItem *item = [[RKSTFormItem alloc] initWithIdentifier:kMoodSurveyStep103
//                                                                     text:NSLocalizedString(@"Date of birth", @"Date of birth")
//                                                             answerFormat:format];
//            [stepQuestions addObject:item];
//        }
//        
//        {
//            RKSTHealthKitCharacteristicTypeAnswerFormat *format = [RKSTHealthKitCharacteristicTypeAnswerFormat answerFormatWithCharacteristicType:[HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex]];
//            
//            RKSTFormItem *item = [[RKSTFormItem alloc] initWithIdentifier:kMoodSurveyStep104
//                                                                     text:NSLocalizedString(@"Gender", @"Gender")
//                                                             answerFormat:format];
//            [stepQuestions addObject:item];
//        }
//        
//        {
//            RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithTextOptions:@[@"African-American", @"Other"]
//                                                                                     style:RKChoiceAnswerStyleSingleChoice];
//        
//            RKSTFormItem *item = [[RKSTFormItem alloc] initWithIdentifier:kMoodSurveyStep105
//                                                                     text:NSLocalizedString(@"Ethnicity", @"Ethnicity")
//                                                             answerFormat:format];
//            [stepQuestions addObject:item];
//        }
//        
//        [step setFormItems:stepQuestions];
//        
//        [steps addObject:step];

    
    {
        
        NSArray* questionChoices = @[@"Perfectly crisp concentration",
                                      @"No issues with concentration",
                                      @"Occassioal difficulties with concentration",
                                      @"Difficulties with concentration",
                                      @"No concentration"];
        
        RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithTextOptions:questionChoices
                                                                                 style:RKChoiceAnswerStyleSingleChoice];
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep103 title:@"How were you feeling cognitively throughout the day?" answer:format];

        [steps addObject:step];
    }
    
    {
        
        NSArray* questionChoices = @[@"Ready to take on the world",
                                     @"Filled with energy through the day",
                                     @"Energy to make it through the day",
                                     @"Basic functions",
                                     @"No energy"];
        
        RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithTextOptions:questionChoices
                                                                                 style:RKChoiceAnswerStyleSingleChoice];
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep104 title:@"What is your overall mood so far today?" answer:format];
        
        [steps addObject:step];
    }
    
    {

        NSArray* questionChoices = @[@"The Best I have felt",
                                     @"Better than usual",
                                     @"Normal",
                                     @"Down",
                                     @"Extremely down"];
        
        RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithTextOptions:questionChoices
                                                                                 style:RKChoiceAnswerStyleSingleChoice];
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep105 title:@"What is your energy level like so far today?" answer:format];
        
        [steps addObject:step];
    }
    
    {
        
        NSArray* questionChoices = @[@"Eliminated all deficit sleep",
                                     @"Made up some deficit sleep",
                                     @"Almost enough sleep",
                                     @"Barely enough sleep",
                                     @"No real sleep"];
        
        RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithTextOptions:questionChoices
                                                                                 style:RKChoiceAnswerStyleSingleChoice];
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep106 title:@"Did you get enough quality sleep last night?" answer:format];
        
        [steps addObject:step];
    }
    
    {

        NSArray* questionChoices = @[@"Activities that make you breathe hard and sweat",
                                     @"Walking",
                                     @"Standing",
                                     @"Sitting",
                                     @"Lying down"];
        
        RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithTextOptions:questionChoices
                                                                                 style:RKChoiceAnswerStyleSingleChoice];
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep107 title:@"What level exercise are you getting today?" answer:format];
        
        [steps addObject:step];
    }
    
    RKSTOrderedTask *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Heart Age Test" steps:steps];
    
    return task;
}

- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step {
    
    NSDictionary  *controllers = @{
                                   kMoodSurveyStep101 : [APCSimpleTaskSummaryViewController class],
                                   kMoodSurveyStep102 : [APCSimpleTaskSummaryViewController class],
                                   kMoodSurveyStep103 : [APCSimpleTaskSummaryViewController class],
                                   kMoodSurveyStep104 : [APCSimpleTaskSummaryViewController class],
                                   kMoodSurveyStep105 : [APCSimpleTaskSummaryViewController class],
                                   kMoodSurveyStep106 : [APCSimpleTaskSummaryViewController class],
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


@end
