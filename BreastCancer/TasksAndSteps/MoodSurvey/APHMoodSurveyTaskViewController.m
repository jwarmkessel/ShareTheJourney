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
#import <QuartzCore/QuartzCore.h>

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

static NSInteger const kNumberOfCompletionsUntilDisplayingCustomSurvey = 7;

@interface APHMoodSurveyTaskViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableDictionary *previousCachedAnswer;
@property (strong, nonatomic) UIImageView *customSurveylearnMoreView;

@end

@implementation APHMoodSurveyTaskViewController

/*********************************************************************************/
#pragma  mark  -  View Controller Methods
/*********************************************************************************/

- (NSString *)createResultSummary {
    
    NSMutableDictionary *resultCollectionDictionary = [NSMutableDictionary new];
    NSArray *arrayOfResults = self.result.results;
    
    for (ORKStepResult *stepResult in arrayOfResults) {
        if (stepResult.results.firstObject) {
            
            if ( ![stepResult.results.firstObject isKindOfClass:[ORKTextQuestionResult class]]) {
                ORKChoiceQuestionResult *questionResult = stepResult.results.firstObject;
                
                if (questionResult.choiceAnswers != nil) {
                    resultCollectionDictionary[stepResult.identifier] = (NSNumber *)[questionResult.choiceAnswers firstObject];
                }
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

+ (id<ORKTask>)createTask:(APCScheduledTask *)scheduledTask
{
    APHDynamicMoodSurveyTask *task = [[APHDynamicMoodSurveyTask alloc] init];
    
    return task;
}

/*********************************************************************************/
#pragma  mark  - TaskViewController delegates
/*********************************************************************************/


- (ORKStepViewController *)taskViewController:(ORKTaskViewController *)taskViewController viewControllerForStep:(ORKStep *)step {
    
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

- (void)taskViewControllerDidComplete:(ORKTaskViewController *)taskViewController {
    [super taskViewControllerDidComplete:taskViewController];
    

    //Here we are keeping a count of the daily scales being completed. We are keeping track only up to 7.
    APCAppDelegate * delegate = (APCAppDelegate*)[UIApplication sharedApplication].delegate;
    if (delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter < kNumberOfCompletionsUntilDisplayingCustomSurvey) {
        delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter++;
    }
}

- (BOOL)taskViewController:(ORKTaskViewController *)taskViewController hasLearnMoreForStep:(ORKStep *)step {
    
    BOOL hasLearnMore = NO;
    
    if ([step.identifier isEqualToString:kCustomMoodSurveyStep101]) {
        hasLearnMore = YES;
    }
    
    return hasLearnMore;
}

- (void)taskViewController:(ORKTaskViewController *)taskViewController learnMoreForStep:(ORKStepViewController *)stepViewController {
    
    //[stepViewController.view setUserInteractionEnabled:NO];
    
    UIImage *blurredImage = [self.view blurredSnapshotDark];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.customSurveylearnMoreView = imageView;
    imageView.alpha = 0;
    [imageView setBounds:[UIScreen mainScreen].bounds];

    [stepViewController.view addSubview:imageView];
    imageView.image = blurredImage;
    
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 1;
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeLearnMore:)];
    [imageView setUserInteractionEnabled:YES];

    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    
    [imageView addGestureRecognizer:tapGesture];

    UIView *learnMoreBubble = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [learnMoreBubble setBackgroundColor:[UIColor whiteColor]];
    learnMoreBubble.layer.cornerRadius = 5;
    learnMoreBubble.layer.masksToBounds = YES;
    
    [imageView addSubview:learnMoreBubble];
    
    [learnMoreBubble setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // SET THE WIDTH
    [imageView addConstraint:[NSLayoutConstraint
                              constraintWithItem:learnMoreBubble
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:imageView
                              attribute:NSLayoutAttributeWidth
                              multiplier:0.9
                              constant:0.0]];
    
    [imageView addConstraint:[NSLayoutConstraint
                              constraintWithItem:learnMoreBubble
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:imageView
                              attribute:NSLayoutAttributeHeight
                              multiplier:0.2
                              constant:0.0]];
    
    [imageView addConstraint:[NSLayoutConstraint
                              constraintWithItem:learnMoreBubble
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:imageView
                              attribute:NSLayoutAttributeCenterY
                              multiplier:0.6
                              constant:0.0]];
    
    [imageView addConstraint:[NSLayoutConstraint
                              constraintWithItem:learnMoreBubble
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:imageView
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0.0]];
    
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, learnMoreBubble.bounds.size.width, 100.0)];
    [learnMoreBubble addSubview:textView];
    
    [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [learnMoreBubble addConstraint:[NSLayoutConstraint
                              constraintWithItem:textView
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:learnMoreBubble
                              attribute:NSLayoutAttributeWidth
                              multiplier:0.8
                              constant:0.0]];
    
    [learnMoreBubble addConstraint:[NSLayoutConstraint
                              constraintWithItem:textView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:learnMoreBubble
                              attribute:NSLayoutAttributeHeight
                              multiplier:0.8
                              constant:0.0]];
    
    [learnMoreBubble addConstraint:[NSLayoutConstraint
                              constraintWithItem:textView
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:learnMoreBubble
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1
                              constant:0.0]];
    
    [learnMoreBubble addConstraint:[NSLayoutConstraint
                              constraintWithItem:textView
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:learnMoreBubble
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0.0]];
    
    textView.text = @"Here are some examples of what other users have come up with: \n\n"
                    "How is your performance on the treadmill?,\nHow was your morning run?";
    textView.textColor = [UIColor darkGrayColor];
    [textView setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    textView.numberOfLines = 0;
    textView.adjustsFontSizeToFitWidth  = YES;
    
}

- (void)removeLearnMore:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.customSurveylearnMoreView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.customSurveylearnMoreView removeFromSuperview];
    }];
}

@end
