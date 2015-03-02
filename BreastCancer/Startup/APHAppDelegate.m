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
static NSString* const  kStudyIdentifier            = @"BreastCancer";
static NSString* const  kAppPrefix                  = @"breastcancer";
static NSString* const  kVideoShownKey              = @"VideoShown";
static NSString* const  kConsentPropertiesFileName  = @"APHConsentSection";

// Uncomment this when you uncomment the code in
// -setUpCollectors, below.
// static  NSTimeInterval  kPassiveLocationDeferredUpdatesTimeout = 1.0 * 60.0;

@interface APHAppDelegate ()

@property (nonatomic, strong) APHProfileExtender* profileExtender;

@end

@implementation APHAppDelegate


- (void) setUpInitializationOptions
{
    [APCUtilities setRealApplicationName: @"Share the Journey"];
    
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
                                                 @"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF": [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000],
                                                 @"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF": [UIColor lightGrayColor],
                                                 @"Feedback-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e" : [UIColor lightGrayColor],
                                                 @"MyThoughts-14ffde40-1551-4b48-aae2-8fef38d61b61" : [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000],
                                                 @"APHDailyJournal-80F09109-265A-49C6-9C5D-765E49AAF5D9" : [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000],
                                                 @"APHExerciseSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF" : [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000],
                                                 @"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF" : [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000],                                                 }];
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


- (ORKTaskViewController *)consentViewController
{
    APCConsentTask*         task = [[APCConsentTask alloc] initWithIdentifier:@"Consent"
                                                           propertiesFileName:kConsentPropertiesFileName];
    ORKTaskViewController*  consentVC = [[ORKTaskViewController alloc] initWithTask:task
                                                                       taskRunUUID:[NSUUID UUID]];
    
    return consentVC;
}

@end
