//
//  APHDynamicMoodSurveyTask.m
//  Journey
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHDynamicMoodSurveyTask.h"

static  NSString  *MainStudyIdentifier  = @"com.breastcancer.moodsurvey";
static  NSString  *kMoodSurveyTaskIdentifier  = @"Mood Survey";

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

static NSInteger const kNumberOfCompletionsUntilDisplayingCustomSurvey = 6;

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

@property (nonatomic) NSInteger currentState;
@property (nonatomic) NSInteger currentCount;
@property (nonatomic, strong) NSDictionary *currentOrderedSteps;


@end
@implementation APHDynamicMoodSurveyTask

- (instancetype) init {
    
    NSArray* moodValueForIndex = @[@(5), @(4), @(3), @(2), @(1)];
    
    NSDictionary  *questionAnswerDictionary = @{
                                                kMoodSurveyStep102 : @[NSLocalizedString(@"Perfectly crisp", @""),
                                                                       NSLocalizedString(@"Crisp", @""),
                                                                       NSLocalizedString(@"Some difficulties", @""),
                                                                       NSLocalizedString(@"Difficulties", @""),
                                                                       NSLocalizedString(@"Poor", @"")
                                                                       ],
                                                
                                                kMoodSurveyStep103 : @[NSLocalizedString(@"The best I have felt", @""),
                                                                       NSLocalizedString(@"Better than usual", @""),
                                                                       NSLocalizedString(@"Normal", @""),
                                                                       NSLocalizedString(@"Down", @""),
                                                                       NSLocalizedString(@"Extremely down", @"")
                                                                       ],

                                                kMoodSurveyStep104 : @[NSLocalizedString(@"Ready to take on the world", @""),
                                                                       NSLocalizedString(@"Filled with energy", @""),
                                                                       NSLocalizedString(@"Enough to make it through the day", @""),
                                                                       NSLocalizedString(@"Low energy", @""),
                                                                       NSLocalizedString(@"No energy", @"")
                                                                      ],
                                                
                                                kMoodSurveyStep105 : @[NSLocalizedString(@"Eliminated all deficit sleep", @""),
                                                                       NSLocalizedString(@"Made up some deficit sleep", @""),
                                                                       NSLocalizedString(@"Almost enough sleep", @""),
                                                                       NSLocalizedString(@"Barely enough sleep", @""),
                                                                       NSLocalizedString(@"No real sleep", @"")
                                                                     ],
  
                                                kMoodSurveyStep106 : @[NSLocalizedString(@"Strenuous exercise (heart beats rapidly)", @""),
                                                                       NSLocalizedString(@"Moderate exercise (not exhausting)", @""),
                                                                       NSLocalizedString(@"Mild exercise (minimal effort)", @""),
                                                                       NSLocalizedString(@"Minimal exercise (no effort)", @""),
                                                                       NSLocalizedString(@"No exercise", @"")
                                                                       ],

                                                kMoodSurveyStep107 : @[NSLocalizedString(@"Great", @""),
                                                                       NSLocalizedString(@"Good", @""),
                                                                       NSLocalizedString(@"Average", @""),
                                                                       NSLocalizedString(@"Bad", @""),
                                                                       NSLocalizedString(@"Terrible", @"")
                                                                       ],
                                                };
    
    NSMutableArray *steps = [NSMutableArray array];
    
    {
        ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:kMoodSurveyStep101];
        step.detailText = nil;
        
        
        [steps addObject:step];
    }
    
    
    /**** Custom Survey Steps */
    
    {
        ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:kCustomMoodSurveyStep101];
        step.title = NSLocalizedString(@"Customize Survey", @"");
        step.detailText = NSLocalizedString(@"You now have the ability to create your own survey question. Tap next to enter your question.", @"");

        [steps addObject:step];
    }
    
    {
        ORKQuestionStep *step = [[ORKQuestionStep alloc] initWithIdentifier:kCustomMoodSurveyStep102];
        
        step.text = NSLocalizedString(@"Customize your question.", @"");
        
        ORKAnswerFormat *textAnswerFormat = [ORKAnswerFormat textAnswerFormatWithMaximumLength:100];
        
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
            
            ORKImageChoice *answerOption = [ORKImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        ORKImageChoiceAnswerFormat *format = [[ORKImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:kMoodSurveyStep102
                                                                        title:NSLocalizedString(@"How were you feeling cognitively throughout the day?", @"")
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
            
            ORKImageChoice *answerOption = [ORKImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        ORKImageChoiceAnswerFormat *format = [[ORKImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:kMoodSurveyStep103
                                                                        title:NSLocalizedString(@"What is your overall mood so far today?", @"")
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
            
            ORKImageChoice *answerOption = [ORKImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        ORKImageChoiceAnswerFormat *format = [[ORKImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:kMoodSurveyStep104
                                                                        title:NSLocalizedString(@"What is your energy level like so far today?", @"")
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
            
            ORKImageChoice *answerOption = [ORKImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        ORKImageChoiceAnswerFormat *format = [[ORKImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:kMoodSurveyStep105
                                                                        title:NSLocalizedString(@"Did you get enough quality sleep last night?", @"")
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
            
            ORKImageChoice *answerOption = [ORKImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        ORKImageChoiceAnswerFormat *format = [[ORKImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:kMoodSurveyStep106
                                                                        title:NSLocalizedString(@"What level exercise are you getting today?", @"")
                                                                       answer:format];
        
        [steps addObject:step];
    }
    
    {
        NSArray *imageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Custom-1g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Custom-2g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Custom-3g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Custom-4g"],
                                  [UIImage imageNamed:@"Breast-Cancer-Custom-5g"]];
        
        NSArray *selectedImageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Custom-1p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Custom-2p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Custom-3p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Custom-4p"],
                                          [UIImage imageNamed:@"Breast-Cancer-Custom-5p"]];
        
        NSArray *textDescriptionChoice = [questionAnswerDictionary objectForKey:kMoodSurveyStep107];
        
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            
            ORKImageChoice *answerOption = [ORKImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        ORKImageChoiceAnswerFormat *format = [[ORKImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:kMoodSurveyStep107
                                                                        title:NSLocalizedString(@"Custom Survey Question?", @"")
                                                                       answer:format];
        
        [steps addObject:step];
    }
    
    
    {
        
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:kMoodSurveyStep108
                                                                        title:NSLocalizedString(@"What level exercise are you getting today?", @"")
                                                                       answer:nil];
        
        [steps addObject:step];
    }
    self  = [super initWithIdentifier:kMoodSurveyTaskIdentifier steps:steps];
    
    return self;
}

- (ORKStep *)stepAfterStep:(ORKStep *)step withResult:(ORKTaskResult *)result
{
    BOOL completedNumberOfTimes = NO;
    
    //Check if we have reached the threshold to display customizing a survey question.
    APCAppDelegate * delegate = (APCAppDelegate*)[UIApplication sharedApplication].delegate;
        
    if (delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter == kNumberOfCompletionsUntilDisplayingCustomSurvey && delegate.dataSubstrate.currentUser.customSurveyQuestion == nil) {
        completedNumberOfTimes = YES;
        
        ORKStepResult *stepResult = [result stepResultForStepIdentifier:kCustomMoodSurveyStep102];
        NSString *skipQuestion = [stepResult.results.firstObject textAnswer];
        
        if (skipQuestion != nil) {
            if ([step.identifier isEqualToString:kMoodSurveyStep108])
            {
                [delegate.dataSubstrate.currentUser setCustomSurveyQuestion:skipQuestion];
            }
            
            self.customSurveyQuestion = skipQuestion;
        } else {
            [delegate.dataSubstrate.currentUser setCustomSurveyQuestion:skipQuestion];
            self.customSurveyQuestion = skipQuestion;
        }
    }
    
    if (delegate.dataSubstrate.currentUser.customSurveyQuestion) {
        self.customSurveyQuestion = delegate.dataSubstrate.currentUser.customSurveyQuestion;
    }

    //set the basic state
    [self setFlowState:0];
    
    
    if ([step.identifier isEqualToString:kMoodSurveyStep108] && delegate.dataSubstrate.currentUser.customSurveyQuestion && delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter == kNumberOfCompletionsUntilDisplayingCustomSurvey)
    {
        [self setFlowState:4];
    }
    else if (delegate.dataSubstrate.currentUser.customSurveyQuestion)
    {
        //Used only if the custom question is already being set in profile.
        [self setFlowState:1];
    }
    
    else if (self.customSurveyQuestion != nil && ![step.identifier isEqualToString:kCustomMoodSurveyStep102] && delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter != kNumberOfCompletionsUntilDisplayingCustomSurvey)
    {
        //If there is a custom question present custom survey
        [self setFlowState:2];
    }
    
    else if (completedNumberOfTimes && self.customSurveyQuestion == nil)

    {
        [self setFlowState:3];
        
    }

    else if (completedNumberOfTimes)
    
    {
        //This is the daily scales with custom survey question and with custom survey
        [self setFlowState:4];
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

- (ORKStep *)stepBeforeStep:(ORKStep *)step withResult:(ORKTaskResult *)result
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

- (ORKTaskProgress)progressOfCurrentStep:(ORKStep *)step withResult:(ORKTaskResult *)result
{
    
    return ORKTaskProgressMake([[self.currentOrderedSteps objectForKey:step.identifier] integerValue] - 1, self.currentOrderedSteps.count);
}

- (void) setFlowState:(NSInteger)state {
    
    self.currentState = state;
    
    switch (state) {
        case 0:
        {
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
            
            self.currentOrderedSteps    = @{
                                            kMoodSurveyStep101       : @(1),
                                            kMoodSurveyStep102       : @(2),
                                            kMoodSurveyStep103       : @(3),
                                            kMoodSurveyStep104       : @(4),
                                            kMoodSurveyStep105       : @(5),
                                            kMoodSurveyStep106       : @(6),
                                            kMoodSurveyStep108       : @(7)
                                            };
            
        }
            break;
        case 1:
        {
            self.backwardKeys           = @{
                                            kMoodSurveyStep101       : [NSNull null],
                                            kCustomMoodSurveyStep101 : [NSNull null],
                                            kCustomMoodSurveyStep102 : [NSNull null],
                                            kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                            kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeClarity),
                                            kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeMood),
                                            kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeEnergy),
                                            kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeSleep),
                                            kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeIntroduction),
                                            kMoodSurveyStep108       : @(APHDynamicMoodSurveyTypeConclusion),
                                            
                                            };
            
            self.keys                   = @{
                                            kMoodSurveyStep101       : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                            kCustomMoodSurveyStep101 : [NSNull null],
                                            kCustomMoodSurveyStep102 : [NSNull null],
                                            kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeMood),
                                            kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeEnergy),
                                            kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeSleep),
                                            kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeExercise),
                                            kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeConclusion),
                                            kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeClarity),
                                            kMoodSurveyStep108       : [NSNull null]
                                            };
            
            self.currentOrderedSteps    = @{
                                            kMoodSurveyStep101       : @(1),
                                            kMoodSurveyStep107       : @(2),
                                            kMoodSurveyStep102       : @(3),
                                            kMoodSurveyStep103       : @(4),
                                            kMoodSurveyStep104       : @(5),
                                            kMoodSurveyStep105       : @(6),
                                            kMoodSurveyStep106       : @(7),
                                            kMoodSurveyStep108       : @(8)
                                            };

        }
            break;
        case 2:
        {
            self.backwardKeys           = @{
                                            kMoodSurveyStep101       : [NSNull null],
                                            kCustomMoodSurveyStep101 : [NSNull null],
                                            kCustomMoodSurveyStep102 : [NSNull null],
                                            kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                            kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeClarity),
                                            kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeMood),
                                            kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeEnergy),
                                            kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeSleep),
                                            kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeIntroduction),
                                            kMoodSurveyStep108       : @(APHDynamicMoodSurveyTypeConclusion),
                                            
                                            };
            
            self.keys                   = @{
                                            kMoodSurveyStep101       : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                            kCustomMoodSurveyStep101 : [NSNull null],
                                            kCustomMoodSurveyStep102 : [NSNull null],
                                            kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeMood),
                                            kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeEnergy),
                                            kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeSleep),
                                            kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeExercise),
                                            kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeConclusion),
                                            kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeClarity),
                                            kMoodSurveyStep108       : [NSNull null]
                                            };
            
            self.currentOrderedSteps    = @{
                                            kMoodSurveyStep101       : @(1),
                                            kMoodSurveyStep107       : @(2),
                                            kMoodSurveyStep102       : @(3),
                                            kMoodSurveyStep103       : @(4),
                                            kMoodSurveyStep104       : @(5),
                                            kMoodSurveyStep105       : @(6),
                                            kMoodSurveyStep106       : @(7),
                                            kMoodSurveyStep108       : @(8)
                                            };


        }
            break;
            
        case 3:
        {
            self.backwardKeys           = @{
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
            
            self.keys                   = @{
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
            
            self.currentOrderedSteps    = @{
                                            kMoodSurveyStep101       : @(1),
                                            kCustomMoodSurveyStep101 : @(2),
                                            kCustomMoodSurveyStep102 : @(3),
                                            kMoodSurveyStep102       : @(4),
                                            kMoodSurveyStep103       : @(5),
                                            kMoodSurveyStep104       : @(6),
                                            kMoodSurveyStep105       : @(7),
                                            kMoodSurveyStep106       : @(8),
                                            kMoodSurveyStep108       : @(9)
                                            };

        }
            break;
            
        case 4:
        {
            self.backwardKeys           = @{
                                            kMoodSurveyStep101       : [NSNull null],
                                            kCustomMoodSurveyStep101 : @(APHDynamicMoodSurveyTypeIntroduction),
                                            kCustomMoodSurveyStep102 : @(APHDynamicMoodSurveyTypeCustomInstruction),
                                            kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                            kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeClarity),
                                            kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeMood),
                                            kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeEnergy),
                                            kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeSleep),
                                            kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeCustomQuestionEntry),
                                            kMoodSurveyStep108       : @(APHDynamicMoodSurveyTypeExercise),
                                            
                                            };
            
            self.keys                   = @{
                                            kMoodSurveyStep101       : @(APHDynamicMoodSurveyTypeCustomInstruction),
                                            kCustomMoodSurveyStep101 : @(APHDynamicMoodSurveyTypeCustomQuestionEntry),
                                            kCustomMoodSurveyStep102 : @(APHDynamicMoodSurveyTypeCustomSurvey),
                                            kMoodSurveyStep102       : @(APHDynamicMoodSurveyTypeMood),
                                            kMoodSurveyStep103       : @(APHDynamicMoodSurveyTypeEnergy),
                                            kMoodSurveyStep104       : @(APHDynamicMoodSurveyTypeSleep),
                                            kMoodSurveyStep105       : @(APHDynamicMoodSurveyTypeExercise),
                                            kMoodSurveyStep106       : @(APHDynamicMoodSurveyTypeConclusion),
                                            kMoodSurveyStep107       : @(APHDynamicMoodSurveyTypeClarity),
                                            kMoodSurveyStep108       : [NSNull null]
                                            };
            
            self.currentOrderedSteps    = @{
                                            kMoodSurveyStep101       : @(1),
                                            kCustomMoodSurveyStep101 : @(2),
                                            kCustomMoodSurveyStep102 : @(3),
                                            kMoodSurveyStep107       : @(4),
                                            kMoodSurveyStep102       : @(5),
                                            kMoodSurveyStep103       : @(6),
                                            kMoodSurveyStep104       : @(7),
                                            kMoodSurveyStep105       : @(8),
                                            kMoodSurveyStep106       : @(9),
                                            kMoodSurveyStep108       : @(10)
                                            };
        }
            break;
            
        default:{
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
            
            self.currentOrderedSteps    = @{
                                            kMoodSurveyStep101       : @(1),
                                            kMoodSurveyStep102       : @(2),
                                            kMoodSurveyStep103       : @(3),
                                            kMoodSurveyStep104       : @(4),
                                            kMoodSurveyStep105       : @(5),
                                            kMoodSurveyStep106       : @(6),
                                            kMoodSurveyStep108       : @(7)
                                            };
           
        }
            break;
    }
}

- (ORKQuestionStep *) customQuestionStep:(NSString *)question {
    
    NSArray* moodValueForIndex = @[@(5), @(4), @(3), @(2), @(1)];
    
    NSArray *imageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Custom-1g"],
                              [UIImage imageNamed:@"Breast-Cancer-Custom-2g"],
                              [UIImage imageNamed:@"Breast-Cancer-Custom-3g"],
                              [UIImage imageNamed:@"Breast-Cancer-Custom-4g"],
                              [UIImage imageNamed:@"Breast-Cancer-Custom-5g"]];
    
    NSArray *selectedImageChoices = @[[UIImage imageNamed:@"Breast-Cancer-Custom-1p"],
                                      [UIImage imageNamed:@"Breast-Cancer-Custom-2p"],
                                      [UIImage imageNamed:@"Breast-Cancer-Custom-3p"],
                                      [UIImage imageNamed:@"Breast-Cancer-Custom-4p"],
                                      [UIImage imageNamed:@"Breast-Cancer-Custom-5p"]];
    
    NSArray *textDescriptionChoice = @[NSLocalizedString(@"Great", @""),
                                      NSLocalizedString(@"Good", @""),
                                      NSLocalizedString(@"Average", @""),
                                      NSLocalizedString(@"Bad", @""),
                                      NSLocalizedString(@"Terrible", @"")
                                      ];
    
    NSMutableArray *answerChoices = [NSMutableArray new];
    
    for (int i = 0; i<[imageChoices count]; i++) {
        
        ORKImageChoice *answerOption = [ORKImageChoice choiceWithNormalImage:imageChoices[i] selectedImage:selectedImageChoices[i] text:textDescriptionChoice[i] value:[moodValueForIndex objectAtIndex:i]];
        
        [answerChoices addObject:answerOption];
    }
    
    ORKImageChoiceAnswerFormat *format = [[ORKImageChoiceAnswerFormat alloc] initWithImageChoices:answerChoices];
    
    ORKQuestionStep *questionStep = [ORKQuestionStep questionStepWithIdentifier:kMoodSurveyStep107
                                                                            title:self.customSurveyQuestion
                                                                           answer:format];
    
    return questionStep;
}

@end
