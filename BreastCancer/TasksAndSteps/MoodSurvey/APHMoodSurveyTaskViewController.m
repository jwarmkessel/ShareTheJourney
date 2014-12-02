//
//  APHMoodSurveyTaskViewController.m
//  BreastCancer
//
//  Created by Justin Warmkessel on 11/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHMoodSurveyTaskViewController.h"
#import "APHHeartAgeIntroStepViewController.h"
#import "APHMoodSurveyCustomView.h"

static  NSString  *MainStudyIdentifier = @"com.breastcancer.moodsurvey";

static  NSString  *kMoodSurveyStep101 = @"moodsurvey101";
static  NSString  *kMoodSurveyStep102 = @"moodsurvey102";
static  NSString  *kMoodSurveyStep103 = @"moodsurvey103";
static  NSString  *kMoodSurveyStep104 = @"moodsurvey104";
static  NSString  *kMoodSurveyStep105 = @"moodsurvey105";
static  NSString  *kMoodSurveyStep106 = @"moodsurvey106";
static  NSString  *kMoodSurveyStep107 = @"moodsurvey107";


@interface APHMoodSurveyTaskViewController ()

@property (strong, nonatomic) APHMoodSurveyCustomView *currentCustomView;

@end

@implementation APHMoodSurveyTaskViewController

/*********************************************************************************/
#pragma  mark  -  View Controller Methods
/*********************************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [RKSTHeadlineLabel appearance].labelFont = [UIFont systemFontOfSize:20];
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
        
        
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            RKSTImageAnswerOption *answerOption = [RKSTImageAnswerOption optionWithNormalImage:imageChoices[i]
                                                                                 selectedImage:selectedImageChoices[i]
                                                                                          text:nil
                                                                                         value:[NSNumber numberWithInt:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithImageOptions:answerChoices
                                                                                  style:RKChoiceAnswerStyleSingleChoice];

        
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
        


        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            RKSTImageAnswerOption *answerOption = [RKSTImageAnswerOption optionWithNormalImage:imageChoices[i]
                                                                                 selectedImage:selectedImageChoices[i]
                                                                                          text:nil
                                                                                         value:[NSNumber numberWithInt:i]];

            [answerChoices addObject:answerOption];
        }
        
        RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithImageOptions:answerChoices
                                                                                  style:RKChoiceAnswerStyleSingleChoice];
        
        
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
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            RKSTImageAnswerOption *answerOption = [RKSTImageAnswerOption optionWithNormalImage:imageChoices[i]
                                                                                 selectedImage:selectedImageChoices[i]
                                                                                          text:nil
                                                                                         value:[NSNumber numberWithInt:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithImageOptions:answerChoices
                                                                                  style:RKChoiceAnswerStyleSingleChoice];

        
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
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            RKSTImageAnswerOption *answerOption = [RKSTImageAnswerOption optionWithNormalImage:imageChoices[i]
                                                                                 selectedImage:selectedImageChoices[i]
                                                                                          text:nil
                                                                                         value:[NSNumber numberWithInt:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithImageOptions:answerChoices
                                                                                  style:RKChoiceAnswerStyleSingleChoice];

        
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
        
        NSMutableArray *answerChoices = [NSMutableArray new];
        
        for (int i = 0; i<[imageChoices count]; i++) {
            RKSTImageAnswerOption *answerOption = [RKSTImageAnswerOption optionWithNormalImage:imageChoices[i]
                                                                                 selectedImage:selectedImageChoices[i]
                                                                                          text:nil
                                                                                         value:[NSNumber numberWithInt:i]];
            
            [answerChoices addObject:answerOption];
        }
        
        RKSTAnswerFormat *format = [RKSTChoiceAnswerFormat choiceAnswerWithImageOptions:answerChoices
                                                                                  style:RKChoiceAnswerStyleSingleChoice];

        
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
    
    RKSTOrderedTask *task = [[RKSTOrderedTask alloc] initWithIdentifier:@"Heart Age Test"
                                                                  steps:steps];
    
    return task;
}

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/

- (RKSTStepViewController *)taskViewController:(RKSTTaskViewController *)taskViewController viewControllerForStep:(RKSTStep *)step {
    
    NSDictionary  *controllers = @{
                                   kMoodSurveyStep101 : [APHHeartAgeIntroStepViewController class],
//                                   kMoodSurveyStep102 : [APCSimpleTaskSummaryViewController class],
//                                   kMoodSurveyStep103 : [APCSimpleTaskSummaryViewController class],
//                                   kMoodSurveyStep104 : [APCSimpleTaskSummaryViewController class],
//                                   kMoodSurveyStep105 : [APCSimpleTaskSummaryViewController class],
//                                   kMoodSurveyStep106 : [APCSimpleTaskSummaryViewController class],
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

- (void)taskViewController:(RKSTTaskViewController *)taskViewController stepViewControllerWillAppear:(RKSTStepViewController *)stepViewController {
    
    RKSTQuestionStepViewController *stepVC = (RKSTQuestionStepViewController *)stepViewController;
    
    if (stepViewController.step.identifier != kMoodSurveyStep101 && stepViewController.step.identifier != kMoodSurveyStep107) {
    
        /**** use for setting custom views. **/
        UINib *nib = [UINib nibWithNibName:@"APHMoodSurveyCustomView" bundle:nil];
        APHMoodSurveyCustomView *restComfortablyView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        self.currentCustomView = restComfortablyView;
        
        [stepVC.view addSubview:restComfortablyView];
        
        [restComfortablyView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [restComfortablyView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[c(>=200)]" options:0 metrics:nil views:@{@"c":restComfortablyView}]];
        
        [stepVC.view addConstraint:[NSLayoutConstraint constraintWithItem:restComfortablyView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:stepVC.view
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:0.001
                                                                 constant:0]];
        
        [stepVC.view addConstraint:[NSLayoutConstraint constraintWithItem:restComfortablyView
                                                                attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                                   toItem:stepViewController.view
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.15
                                                                 constant:75]];
        
        [stepVC.view addConstraint:[NSLayoutConstraint constraintWithItem:restComfortablyView
                                                                attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                                   toItem:stepViewController.view
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1
                                                                 constant:0]];
        
        [stepVC.view addConstraint:[NSLayoutConstraint constraintWithItem:stepVC.view
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:restComfortablyView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0.0]];
        
        
        [stepVC.view layoutIfNeeded];
        
        stepViewController.continueButton = nil;
        stepViewController.skipButton = nil;

    }
}

- (void)stepViewController:(RKSTStepViewController *)stepViewController didChangeResult:(RKSTStepResult*)stepResult{
    
    
    if (stepViewController.step.identifier != kMoodSurveyStep101 && stepViewController.step.identifier != kMoodSurveyStep107) {
        self.currentCustomView.alpha = 0;
        
        RKSTQuestionResult *questionResult = (RKSTQuestionResult *) stepResult.firstResult;
        
        if (questionResult.answer != [NSNull null]) {
         
            NSNumber *number = (NSNumber *) questionResult.answer;
            
            
            NSDictionary  *questionAnswerDictionary = @{
                                                        kMoodSurveyStep102 : @[@"Perfectly crisp concentration",
                                                                               @"No issues with concentration",
                                                                               @"Occasional difficulties with concentration",
                                                                               @"Difficulties with concentration",
                                                                               @"No concentration"],
                                                        
                                                        kMoodSurveyStep103 : @[@"Ready to take on the world",
                                                                               @"Filled with energy through the day",
                                                                               @"Energy to make it through the day",
                                                                               @"Basic functions",
                                                                               @"No energy"],
                                                        
                                                        kMoodSurveyStep104 : @[@"The best I have felt",
                                                                               @"Better than usual",
                                                                               @"Normal",
                                                                               @"Down",
                                                                               @"Extremely down"],
                                                        
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
            
            NSArray *  questionAnswerChoices = [questionAnswerDictionary objectForKey:stepViewController.step.identifier];
            
            //These numbers have to relate to the output on the graphs in dashboard.
            int aNum = 0;
            
            switch ([number intValue]) {
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
            
            self.currentCustomView.questionChoiceLabel.text = [NSString stringWithFormat:@"%@ (%d)", [questionAnswerChoices objectAtIndex:[number intValue]], aNum];
            
            
            
            [UIView animateWithDuration:0.3 animations:^{
                self.currentCustomView.alpha = 1;
            }];

        }
    }
}


@end
