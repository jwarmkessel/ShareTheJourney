//
//  APHDynamicMoodSurveyTask.m
//  BreastCancer
//
//  Created by Justin Warmkessel on 2/5/15.
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

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

static NSInteger const kNumberOfCompletionsUntilDisplayingCustomSurvey = 2;

typedef NS_ENUM(NSUInteger, APHDynamicMoodSurveyType) {
    APHDynamicMoodSurveyTypeIntroduction = 0,
    APHDynamicMoodSurveyTypeCustomInstruction,
    APHDynamicMoodSurveyTypeCustomQuestionEntry,
    APHDynamicMoodSurveyTypeClarity,
    APHDynamicMoodSurveyTypeMood,
    APHDynamicMoodSurveyTypeEnergy,
    APHDynamicMoodSurveyTypeSleep,
    APHDynamicMoodSurveyTypeExercise,
    APHDynamicMoodSurveyTypeCustomSurvey,
    APHDynamicMoodSurveyTypeConclusion
};

@interface APHDynamicMoodSurveyTask()
@property (nonatomic, strong) NSDictionary *keys;
@property (nonatomic, strong) NSDictionary *backwardKeys;

@property (nonatomic, strong) NSString *customSurveyQuestion;

@property (nonatomic) NSInteger currentCount;
@end
@implementation APHDynamicMoodSurveyTask

- (instancetype) init {
    
    NSArray* moodValueForIndex = @[@(5), @(4), @(3), @(2), @(1)];
    
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
                                                                       @"Lying down"],
                                                
                                                kMoodSurveyStep107 : @[@"Great",
                                                                       @"Good",
                                                                       @"Average",
                                                                       @"Bad",
                                                                       @"Terrible"],
                                                };
    
    NSMutableArray *steps = [NSMutableArray array];
    
    {
        RKSTInstructionStep *step = [[RKSTInstructionStep alloc] initWithIdentifier:kMoodSurveyStep101];
        step.detailText = nil;
        
        
        [steps addObject:step];
    }
    
    
    /**** Custom Survey Steps */
    
    {
        RKSTInstructionStep *step = [[RKSTInstructionStep alloc] initWithIdentifier:kCustomMoodSurveyStep101];
        step.title = @"You now have the ability to create your own survey question. Tap next to enter your question.";
        
        [steps addObject:step];
    }
    
    {
        RKSTQuestionStep *step = [[RKSTQuestionStep alloc] initWithIdentifier:kCustomMoodSurveyStep102];
        
        step.text = @"Customize your question.";
        
        RKSTAnswerFormat *textAnswerFormat = [RKSTAnswerFormat textAnswerFormatWithMaximumLength:100];
        
        [step setAnswerFormat:textAnswerFormat];
        
        [steps addObject:step];
    }
    
    /*****/
    
    
    
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
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        
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
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        
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
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        
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
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        
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
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep106
                                                                        title:@"What level exercise are you getting today?"
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
        
        NSArray *textDescriptionChoice = [questionAnswerDictionary objectForKey:kMoodSurveyStep107];
        
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            
            RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep107
                                                                        title:@"Custom Survey Question?"
                                                                       answer:format];
        
        [steps addObject:step];
    }
    
    
    {
        
        RKSTQuestionStep *step = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep108
                                                                        title:@"What level exercise are you getting today?"
                                                                       answer:nil];
        
        [steps addObject:step];
    }
    self  = [super initWithIdentifier:@"Mood Survey" steps:steps];
    
    return self;
}

- (RKSTStep *)stepAfterStep:(RKSTStep *)step withResult:(RKSTTaskResult *)result
{
    BOOL completedNumberOfTimes = NO;
    
    //Check if we have reached the threshold to display customizing a survey question.
    APCAppDelegate * delegate = (APCAppDelegate*)[UIApplication sharedApplication].delegate;
        
    if (delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter == kNumberOfCompletionsUntilDisplayingCustomSurvey && delegate.dataSubstrate.currentUser.customSurveyQuestion == nil) {
        completedNumberOfTimes = YES;
        
        RKSTStepResult *stepResult = [result stepResultForStepIdentifier:kCustomMoodSurveyStep102];
        NSString *skipQuestion = [stepResult.results.firstObject textAnswer];
        
        if (skipQuestion != nil) {
            if ([step.identifier isEqualToString:kMoodSurveyStep108])
            {
                [delegate.dataSubstrate.currentUser setCustomSurveyQuestion:skipQuestion];
            }
            
            self.customSurveyQuestion = skipQuestion;
        } else {
            [delegate.dataSubstrate.currentUser setCustomSurveyQuestion:skipQuestion];
        }
    }
    
    if (delegate.dataSubstrate.currentUser.customSurveyQuestion) {
        self.customSurveyQuestion = delegate.dataSubstrate.currentUser.customSurveyQuestion;
    }
    


    //This is the daily scales without custom survey question and without custom survey
    
    self.backwardKeys           = @{
                                       kMoodSurveyStep101       : [NSNull null],
                                       kCustomMoodSurveyStep101 : [NSNull null],
                                       kCustomMoodSurveyStep102 : [NSNull null],
                                       kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeIntroduction),
                                       kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeClarity),
                                       kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeMood),
                                       kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeEnergy),
                                       kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeSleep),
                                       kMoodSurveyStep107       : [NSNull null],
                                       kMoodSurveyStep108       : @(APHDynamicMoodSurveyTypeExercise),
                                       
                                       };
    
    self.keys                   = @{
                                       kMoodSurveyStep101       : @(APHDynamicMoodSurveyTypeClarity),
                                       kCustomMoodSurveyStep101 : [NSNull null],
                                       kCustomMoodSurveyStep102 : [NSNull null],
                                       kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeMood),
                                       kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeEnergy),
                                       kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeSleep),
                                       kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeExercise),
                                       kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeConclusion),
                                       kMoodSurveyStep107       : [NSNull null],
                                       kMoodSurveyStep108       : [NSNull null]
                                       };
    
    
    if (delegate.dataSubstrate.currentUser.customSurveyQuestion) {////////////////////////////////////
        
        self.backwardKeys           = @{
                                        kMoodSurveyStep101       : [NSNull null],
                                        kCustomMoodSurveyStep101 : [NSNull null],
                                        kCustomMoodSurveyStep102 : [NSNull null],
                                        kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeIntroduction),
                                        kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeClarity),
                                        kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeMood),
                                        kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeEnergy),
                                        kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeSleep),
                                        kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeExercise),
                                        kMoodSurveyStep108       : @(APHDynamicMoodSurveyTypeConclusion),
                                        
                                        };
        
        self.keys                   = @{
                                        kMoodSurveyStep101       : @(APHDynamicMoodSurveyTypeClarity),
                                        kCustomMoodSurveyStep101 : [NSNull null],
                                        kCustomMoodSurveyStep102 : [NSNull null],
                                        kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeMood),
                                        kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeEnergy),
                                        kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeSleep),
                                        kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeExercise),
                                        kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                        kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeConclusion),
                                        kMoodSurveyStep108       : [NSNull null]
                                        };
    }
    
    else if (self.customSurveyQuestion != nil && ![step.identifier isEqualToString:kCustomMoodSurveyStep102] && delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter != kNumberOfCompletionsUntilDisplayingCustomSurvey)
    {
        //If there is a custom question present custom survey
        
        self.backwardKeys           = @{
                                         kMoodSurveyStep101       : [NSNull null],
                                         kCustomMoodSurveyStep101 : [NSNull null],
                                         kCustomMoodSurveyStep102 : [NSNull null],
                                         kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeIntroduction),
                                         kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeClarity),
                                         kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeMood),
                                         kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeEnergy),
                                         kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeSleep),
                                         kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeExercise),
                                         kMoodSurveyStep108       : @(APHDynamicMoodSurveyTypeConclusion),
                                         
                                         };
        
        self.keys                   = @{
                                         kMoodSurveyStep101       : @(APHDynamicMoodSurveyTypeClarity),
                                         kCustomMoodSurveyStep101 : [NSNull null],
                                         kCustomMoodSurveyStep102 : [NSNull null],
                                         kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeMood),
                                         kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeEnergy),
                                         kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeSleep),
                                         kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeExercise),
                                         kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                         kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeConclusion),
                                         kMoodSurveyStep108       : [NSNull null]
                                         };
    
    }
    
    else if (completedNumberOfTimes && self.customSurveyQuestion == nil)

    {

        self.backwardKeys       = @{
                                     kMoodSurveyStep101       : [NSNull null],
                                     kCustomMoodSurveyStep101 : @(APHDynamicMoodSurveyTypeIntroduction),
                                     kCustomMoodSurveyStep102 : @(APHDynamicMoodSurveyTypeCustomInstruction),
                                     kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeCustomQuestionEntry),
                                     kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeClarity),
                                     kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeMood),
                                     kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeEnergy),
                                     kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeSleep),
                                     kMoodSurveyStep107       : [NSNull null],
                                     kMoodSurveyStep108       : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                     
                                     };
        
        self.keys               = @{
                                     kMoodSurveyStep101       : @(APHDynamicMoodSurveyTypeCustomInstruction),
                                     kCustomMoodSurveyStep101 : @(APHDynamicMoodSurveyTypeCustomQuestionEntry),
                                     kCustomMoodSurveyStep102 : @(APHDynamicMoodSurveyTypeClarity),
                                     kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeMood),
                                     kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeEnergy),
                                     kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeSleep),
                                     kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeExercise),
                                     kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeConclusion),
                                     kMoodSurveyStep107       : [NSNull null],
                                     kMoodSurveyStep108       : [NSNull null]
                                     };
    }

    else if (completedNumberOfTimes)
    
    {
        //This is the daily scales with custom survey question and with custom survey
        
        self.backwardKeys       = @{
                                     kMoodSurveyStep101       : [NSNull null],
                                     kCustomMoodSurveyStep101 : @(APHDynamicMoodSurveyTypeIntroduction),
                                     kCustomMoodSurveyStep102 : @(APHDynamicMoodSurveyTypeCustomInstruction),
                                     kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeCustomQuestionEntry),
                                     kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeClarity),
                                     kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeMood),
                                     kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeEnergy),
                                     kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeSleep),
                                     kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeExercise),
                                     kMoodSurveyStep108       : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                     
                                     };
        
        self.keys               = @{
                                     kMoodSurveyStep101       : @(APHDynamicMoodSurveyTypeCustomInstruction),
                                     kCustomMoodSurveyStep101 : @(APHDynamicMoodSurveyTypeCustomQuestionEntry),
                                     kCustomMoodSurveyStep102 : @(APHDynamicMoodSurveyTypeClarity),
                                     kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeMood),
                                     kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeEnergy),
                                     kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeSleep),
                                     kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeExercise),
                                     kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                     kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeConclusion),
                                     kMoodSurveyStep108       : [NSNull null]
                                     };
    }

    
    if (step == nil)
    {
        step = self.steps[0];
        self.currentCount = 1;
    }
    
    else if ([[self.steps[self.steps.count - 1] identifier] isEqualToString:step.identifier])
    {
        step = nil;
    }
    else
    {
        NSNumber *index = (NSNumber *) self.keys[step.identifier];
        
        step = self.steps[[index intValue]];
        
        self.currentCount = [index integerValue];
    
    }
    
    if ([step.identifier isEqualToString:kMoodSurveyStep107] && self.customSurveyQuestion != nil) {
        step = [self customQuestionStep:self.customSurveyQuestion];
    }
    
    return step;
}

- (RKSTStep *)stepBeforeStep:(RKSTStep *)step withResult:(RKSTTaskResult *)result
{
    if ([[self.steps[0] identifier] isEqualToString:step.identifier]) {
        step = nil;
    }
    
    else
    {
        NSNumber *index = (NSNumber *) self.backwardKeys[step.identifier];
        
        step = self.steps[[index intValue]];
    }
    
    if ([step.identifier isEqualToString:kMoodSurveyStep107] && self.customSurveyQuestion != nil) {
        step = [self customQuestionStep:self.customSurveyQuestion];
    }
    
    return step;
}

- (RKSTTaskProgress)progressOfCurrentStep:(RKSTStep *)step withResult:(RKSTTaskResult *)result
{
    return RKSTTaskProgressMake(self.currentCount, [self.steps count]);
}

- (RKSTQuestionStep *) customQuestionStep:(NSString *)question {
    
    NSArray* moodValueForIndex = @[@(5), @(4), @(3), @(2), @(1)];
    
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
    
    NSArray *textDescriptionChoice = @[@"Great",
                                       @"Good",
                                       @"Average",
                                       @"Bad",
                                       @"Terrible"];
    
    
    NSMutableArray *answerChoices = [NSMutableArray new];
    
    for (int i = 0; i<[imageChoices count]; i++) {
        
        RKSTImageChoice *answerOption = [RKSTImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
        
        [answerChoices addObject:answerOption];
    }
    
    RKSTImageChoiceAnswerFormat *format = [[RKSTImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
    
    RKSTQuestionStep *questionStep = [RKSTQuestionStep questionStepWithIdentifier:kMoodSurveyStep107
                                                                            title:self.customSurveyQuestion
                                                                           answer:format];
    
    return questionStep;
}

@end
