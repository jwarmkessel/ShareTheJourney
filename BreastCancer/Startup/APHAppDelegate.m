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
    NSDictionary *permissionsDescriptions = @{
                                              @(kSignUpPermissionsTypeLocation) : NSLocalizedString(@"Using your GPS enables the app to accurately determine distances travelled. Your actual location will never be shared.", @""),
                                              @(kSignUpPermissionsTypeCoremotion) : NSLocalizedString(@"Using the motion co-processor allows the app to determine your activity, helping the study better understand how activity level may influence disease.", @""),
                                              @(kSignUpPermissionsTypeMicrophone) : NSLocalizedString(@"Access to microphone is required for your Voice Recording Activity.", @""),
                                              @(kSignUpPermissionsTypeLocalNotifications) : NSLocalizedString(@"Allowing notifications enables the app to show you reminders.", @""),
                                              @(kSignUpPermissionsTypeHealthKit) : NSLocalizedString(@"On the next screen, you will be prompted to grant Share the Journey access to read and write some of your general and health information, such as height, weight and steps taken so you don't have to enter it again.", @""),
                                              };
    
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
                                                   @(kSignUpPermissionsTypeCoremotion),
                                                   @(kSignUpPermissionsTypeLocalNotifications)
                                                   ],
                                           kAppServicesDescriptionsKey : permissionsDescriptions,
                                           kAppProfileElementsListKey            : @[
                                                   @(kAPCUserInfoItemTypeEmail),
                                                   @(kAPCUserInfoItemTypeDateOfBirth),
                                                   @(kAPCUserInfoItemTypeHeight),
                                                   @(kAPCUserInfoItemTypeWeight)
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
                                                 kPrimaryAppColorKey : [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000],
                                                 @"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF": [UIColor appTertiaryRedColor]
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
    ORKInstructionStep* instruction = [[ORKInstructionStep alloc] initWithIdentifier:@"instruction"];
    instruction.title = @"Let's Test Your Understanding";
    instruction.text = @"We'll now ask you 5 simple questions about the study information you just read.\nPress Get Started when you're ready to start.";

    ORKTextChoiceAnswerFormat*  purposeChoice   = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice
                                                                                       textChoices:@[NSLocalizedString(@"Understand the symptoms of Breast Cancer recovery", nil),
                                                                                                     NSLocalizedString(@"Treat Breast Cancer", nil)]];
    ORKQuestionStep*    question1 = [ORKQuestionStep questionStepWithIdentifier:@"purpose"
                                                                          title:NSLocalizedString(@"What is the purpose of this study?", nil)
                                                                         answer:purposeChoice];
    ORKQuestionStep*    question2 = [ORKQuestionStep questionStepWithIdentifier:@"deidentified"
                                                                          title:NSLocalizedString(@"My name will be stored with my study data", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    ORKQuestionStep*    question3 = [ORKQuestionStep questionStepWithIdentifier:@"access"
                                                                          title:NSLocalizedString(@"Many researchers will be able to access my study data", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    ORKQuestionStep*    question4 = [ORKQuestionStep questionStepWithIdentifier:@"skipSurvey"
                                                                          title:NSLocalizedString(@"I will be able to skip any survey question", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    
    ORKQuestionStep*    question5 = [ORKQuestionStep questionStepWithIdentifier:@"stopParticipating"
                                                                          title:NSLocalizedString(@"I will be able to stop participating at any time", nil)
                                                                         answer:[ORKBooleanAnswerFormat new]];
    
    question1.optional = NO;
    question2.optional = NO;
    question3.optional = NO;
    question4.optional = NO;
    question5.optional = NO;
    
    return @[instruction, question1, question2, question3, question4, question5];
}

- (id<ORKTask>)makeConsent
{
    NSString*               docHtml   = nil;
    NSArray*                sections  = [super consentSectionsAndHtmlContent:&docHtml];
    ORKConsentDocument*     consent   = [[ORKConsentDocument alloc] init];
    ORKConsentSignature*    signature = [ORKConsentSignature signatureForPersonWithTitle:NSLocalizedString(@"Participant", nil)
                                                                        dateFormatString:nil
                                                                              identifier:@"participant"];

    consent.title                = NSLocalizedString(@"Consent", nil);
    consent.signaturePageTitle   = NSLocalizedString(@"Consent", nil);
    consent.signaturePageContent = NSLocalizedString(@"I agree to participate in this research Study.", nil);
    consent.sections             = sections;
    consent.htmlReviewContent    = docHtml;
    
    [consent addSignature:signature];
    
    
    ORKVisualConsentStep*   step         = [[ORKVisualConsentStep alloc] initWithIdentifier:@"visual" document:consent];
    ORKConsentReviewStep*   reviewStep   = nil;
    NSMutableArray*         consentSteps = [NSMutableArray arrayWithObject:step];
    
    [consentSteps addObjectsFromArray:[self quizSteps]];
    
#warning Reconsider if the the `signedIn` feature for consent is needed.
    if (!self.dataSubstrate.currentUser.isSignedIn)
    {
        reviewStep                  = [[ORKConsentReviewStep alloc] initWithIdentifier:@"reviewStep" signature:signature inDocument:consent];
        reviewStep.reasonForConsent = NSLocalizedString(@"By agreeing you confirm that you read the information and that you wish to take part in this research study.", nil);
        
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
