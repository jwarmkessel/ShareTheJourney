// 
//  APHAppDelegate.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
@import APCAppCore;
#import "APHAppDelegate.h"
#import "APHProfileExtender.h"

/*********************************************************************************/
#pragma mark - Initializations Options
/*********************************************************************************/
static NSString *const kStudyIdentifier = @"BreastCancer";
static NSString *const kAppPrefix       = @"breastcancer";
static NSString *const kVideoShownKey = @"VideoShown";

// Uncomment this when you uncomment the code in
// -setUpCollectors, below.
// static  NSTimeInterval  kPassiveLocationDeferredUpdatesTimeout = 1.0 * 60.0;

@interface APHAppDelegate ()

@property (nonatomic, strong) APHProfileExtender* profileExtender;

@end

@implementation APHAppDelegate


- (void) setUpInitializationOptions
{
    NSMutableDictionary * dictionary = [super defaultInitializationOptions];
    [dictionary addEntriesFromDictionary:@{
                                           kStudyIdentifierKey                  : kStudyIdentifier,
                                           kAppPrefixKey                        : kAppPrefix,
                                           kBridgeEnvironmentKey                : @(SBBEnvironmentStaging),
                                           kHKReadPermissionsKey                : @[
                                                   HKQuantityTypeIdentifierBodyMass,
                                                   HKQuantityTypeIdentifierHeight,
                                                   HKQuantityTypeIdentifierStepCount,
                                                   HKQuantityTypeIdentifierDistanceWalkingRunning,
                                                   @{kHKCategoryTypeKey : HKCategoryTypeIdentifierSleepAnalysis}
                                                   ],
                                           kHKWritePermissionsKey                : @[
//                                                   HKQuantityTypeIdentifierBodyMass,
//                                                   HKQuantityTypeIdentifierHeight
                                                   ],
                                           kAppServicesListRequiredKey           : @[
                                                   @(kSignUpPermissionsTypeLocation),
                                                   @(kSignUpPermissionsTypeCoremotion)
                                                   ],
                                           kAppProfileElementsListKey            : @[
                                                   @(kAPCUserInfoItemTypeEmail),
                                                   @(kAPCUserInfoItemTypeDateOfBirth),
                                                   @(kAPCUserInfoItemTypeHeight),
                                                   @(kAPCUserInfoItemTypeWeight),
                                                   @(kAPCUserInfoItemTypeWakeUpTime),
                                                   @(kAPCUserInfoItemTypeSleepTime),
                                                   //@(kAPCUserInfoItemTypeCustomSurvey)
                                                   ],
                                           kAnalyticsOnOffKey  : @(YES),
                                           kAnalyticsFlurryAPIKeyKey : @"3V2CN572C3R782W2DBBN"
                                           }];
    self.initializationOptions = dictionary;
    self.profileExtender = [[APHProfileExtender alloc] init];
}

- (id <APCProfileViewControllerDelegate>) profileExtenderDelegate {
    
    return self.profileExtender;
}

- (void) setUpAppAppearance
{
    [APCAppearanceInfo setAppearanceDictionary:@{
                                                 kPrimaryAppColorKey : [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000]
                                                 }];
    [[UINavigationBar appearance] setTintColor:[UIColor appPrimaryColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName : [UIColor appSecondaryColor2],
                                                            NSFontAttributeName : [UIFont appMediumFontWithSize:17.0f]
                                                            }];
    
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
}

- (void) showOnBoarding
{
    [super showOnBoarding];
    [self showStudyOverview];
}

- (void) showStudyOverview
{
    APCStudyOverviewViewController *studyController = [[UIStoryboard storyboardWithName:@"APCOnboarding" bundle:[NSBundle appleCoreBundle]] instantiateViewControllerWithIdentifier:@"StudyOverviewVC"];
    [self setUpRootViewController:studyController];
}

- (BOOL) isVideoShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kVideoShownKey];
}

/*********************************************************************************/
#pragma mark - Datasubstrate Delegate Methods
/*********************************************************************************/
- (void) setUpCollectors
{
	/*
	 NOTE:  when you uncomment this, you'll also have to
	 uncomment kPassiveLocationDeferredUpdatesTimeout,
	 at the top of this file.
	 */

//    self.dataSubstrate.passiveLocationTracking = [[APCPassiveLocationTracking alloc]
//                                                  initWithDeferredUpdatesTimeout:kPassiveLocationDeferredUpdatesTimeout
//                                                  andHomeLocationStatus:APCPassiveLocationTrackingHomeLocationUnavailable];
//
//    [self.dataSubstrate.passiveLocationTracking start];

    return;

}

/*********************************************************************************/
#pragma mark - APCOnboardingDelegate Methods
/*********************************************************************************/

- (APCScene *)inclusionCriteriaSceneForOnboarding:(APCOnboarding *)onboarding
{
    APCScene *scene = [APCScene new];
    scene.name = @"APHInclusionCriteriaViewController";
    scene.storyboardName = @"APHOnboarding";
    scene.bundle = [NSBundle mainBundle];
    
    return scene;
}

/*********************************************************************************/
#pragma mark - Consent
/*********************************************************************************/

- (NSArray*)quizSteps
{
    ORKTextChoiceAnswerFormat*  purposeChoice   = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice
                                                                                       textChoices:@[NSLocalizedString(@"Understand the symptoms of Breast Cancer recovery", nil),
                                                                                                     NSLocalizedString(@"Treat Breast Cancer", nil)]];
    ORKQuestionStep*    question1 = [ORKQuestionStep questionStepWithIdentifier:@"purpose"
                                                                          title:NSLocalizedString(@"What is the purpose of this study?", nil)
                                                                         answer:purposeChoice];
    ORKQuestionStep*    question2 = [ORKQuestionStep questionStepWithIdentifier:@"deidentified"
                                                                          title:NSLocalizedString(@"My name will be stored with my Study data", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    ORKQuestionStep*    question3 = [ORKQuestionStep questionStepWithIdentifier:@"access"
                                                                          title:NSLocalizedString(@"Many researchers will be able to access my study data", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    ORKQuestionStep*    question4 = [ORKQuestionStep questionStepWithIdentifier:@"skipSurvey"
                                                                          title:NSLocalizedString(@"I will be albe to skip any survey question", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    
    ORKQuestionStep*    question5 = [ORKQuestionStep questionStepWithIdentifier:@"stopParticipating"
                                                                          title:NSLocalizedString(@"I will be able to stop participating at any time", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    
    question1.optional = NO;
    question2.optional = NO;
    question3.optional = NO;
    question4.optional = NO;
    question5.optional = NO;
    
    return @[question1, question2, question3, question4, question5];
}

- (id<ORKTask>)makeConsent
{
    NSArray*                sections  = [super consentSections];
    ORKConsentDocument*     consent   = [[ORKConsentDocument alloc] init];
    ORKConsentSignature*    signature = [ORKConsentSignature signatureForPersonWithTitle:NSLocalizedString(@"Participant", nil)
                                                                        dateFormatString:nil
                                                                              identifier:@"participant"];

    consent.title                = NSLocalizedString(@"Consent", nil);
    consent.signaturePageTitle   = NSLocalizedString(@"Consent", nil);
    consent.signaturePageContent = NSLocalizedString(@"I agree to participate in this research Study.", nil);
    consent.sections             = sections;
    
    [consent addSignature:signature];
    
    
    ORKVisualConsentStep*   step         = [[ORKVisualConsentStep alloc] initWithIdentifier:@"visual" document:consent];
    ORKConsentReviewStep*   reviewStep   = nil;
    NSMutableArray*         consentSteps = [NSMutableArray arrayWithObject:step];
    
    [consentSteps addObjectsFromArray:[self quizSteps]];
    
#warning Reconsider if the the `signedIn` feature for consent is needed.
    if (!self.dataSubstrate.currentUser.isSignedIn)
    {
        reviewStep                  = [[ORKConsentReviewStep alloc] initWithIdentifier:@"reviewStep" signature:signature inDocument:consent];
        reviewStep.reasonForConsent = NSLocalizedString(@"By agreeing you confirm that you have read the terms and conditions, that you understand them and that you wish to take part in this research study.", nil);
        
        [consentSteps addObject:reviewStep];
    }
    
    ORKOrderedTask* task = [[ORKOrderedTask alloc] initWithIdentifier:@"consent" steps:consentSteps];
    
    return task;
}

- (ORKTaskViewController *)consentViewController
{
    id<ORKTask> task = [self makeConsent];
    
    ORKTaskViewController*  consentVC = [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:[NSUUID UUID]];
    
    return consentVC;
}

@end
