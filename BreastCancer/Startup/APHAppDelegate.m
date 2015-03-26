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

static NSString *const kJsonScheduleStringKey           = @"scheduleString";
static NSString *const kJsonTasksKey                    = @"tasks";
static NSString *const kJsonScheduleTaskIDKey           = @"taskID";
static NSString *const kJsonSchedulesKey                = @"schedules";

static NSString *const kMigrationTaskIdKey              = @"taskId";
static NSString *const kMigrationOffsetByDaysKey        = @"offsetByDays";
static NSString *const kMigrationGracePeriodInDaysKey   = @"gracePeriodInDays";
static NSString *const kMigrationRecurringKindKey       = @"recurringKind";


typedef NS_ENUM(NSUInteger, APHMigrationRecurringKinds)
{
    APHMigrationRecurringKindWeekly = 0,
    APHMigrationRecurringKindMonthly,
    APHMigrationRecurringKindQuarterly,
    APHMigrationRecurringKindSemiAnnual,
    APHMigrationRecurringKindAnnual
};

@interface APHAppDelegate ()

@property (nonatomic, strong) APHProfileExtender *profileExtender;

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
                                           kBridgeEnvironmentKey                : @(SBBEnvironmentProd),
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
                                           }];
    self.initializationOptions = dictionary;
    self.profileExtender = [[APHProfileExtender alloc] init];
}

- (NSDictionary *)migrateTasksAndSchedules:(NSDictionary *)currentTaskAndSchedules
{
    NSMutableDictionary *migratedTaskAndSchedules = nil;
    
    if (currentTaskAndSchedules == nil) {
        APCLogError(@"Nothing was loaded from the JSON file. Therefore nothing to migrate.");
    } else {
        migratedTaskAndSchedules = [currentTaskAndSchedules mutableCopy];
        
        NSArray *schedulesToMigrate = @[
                                        @{
                                           kMigrationTaskIdKey: @"9-PHQ8GAD7-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e",
                                           kMigrationOffsetByDaysKey: @(1),
                                           kMigrationGracePeriodInDaysKey: @(5),
                                           kMigrationRecurringKindKey: @(APHMigrationRecurringKindMonthly)
                                         },
                                        @{
                                            kMigrationTaskIdKey: @"c-Weekly-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e",
                                            kMigrationOffsetByDaysKey: @(5),
                                            kMigrationGracePeriodInDaysKey: @(5),
                                            kMigrationRecurringKindKey: @(APHMigrationRecurringKindWeekly)
                                         },
                                        @{
                                            kMigrationTaskIdKey: @"e-PAOFI-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e",
                                            kMigrationOffsetByDaysKey: @(2),
                                            kMigrationGracePeriodInDaysKey: @(5),
                                            kMigrationRecurringKindKey: @(APHMigrationRecurringKindMonthly)
                                         },
                                        @{
                                            kMigrationTaskIdKey: @"a-PSQI-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e",
                                            kMigrationOffsetByDaysKey: @(3),
                                            kMigrationGracePeriodInDaysKey: @(5),
                                            kMigrationRecurringKindKey: @(APHMigrationRecurringKindMonthly)
                                         },
                                        @{
                                            kMigrationTaskIdKey: @"b-SF36-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e",
                                            kMigrationOffsetByDaysKey: @(4),
                                            kMigrationGracePeriodInDaysKey: @(5),
                                            kMigrationRecurringKindKey: @(APHMigrationRecurringKindQuarterly)
                                         }
                                       ];
        
        NSArray *schedules = migratedTaskAndSchedules[kJsonSchedulesKey];
        NSMutableArray *migratedSchedules = [NSMutableArray new];
        
        for (NSDictionary *schedule in schedules) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", kMigrationTaskIdKey, schedule[kJsonScheduleTaskIDKey]];
            NSArray *matchedSchedule = [schedulesToMigrate filteredArrayUsingPredicate:predicate];
            
            if (matchedSchedule.count > 0) {
                NSDictionary *taskInfo = [matchedSchedule firstObject];
                
                NSMutableDictionary *updatedSchedule = [schedule mutableCopy];
                
                NSDate *launchDate = [NSDate date];
                
                NSDate *offsetDate = [launchDate dateByAddingDays:[taskInfo[kMigrationOffsetByDaysKey] integerValue]];
                
                NSDateComponents *componentForGracePeriodStartOn = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:offsetDate];
                
                NSString *gracePeriod = [NSString stringWithFormat:@"%ld", componentForGracePeriodStartOn.day];
                NSString *recurring = nil;
                
                switch ([taskInfo[kMigrationRecurringKindKey] integerValue]) {
                    case APHMigrationRecurringKindMonthly:
                        recurring = [NSString stringWithFormat:@"1/1"];
                        break;
                    case APHMigrationRecurringKindQuarterly:
                        recurring = [NSString stringWithFormat:@"1/3"];
                        break;
                    default:
                        recurring = [NSString stringWithFormat:@"*"];
                        break;
                }
                
                updatedSchedule[kJsonScheduleStringKey] = [NSString stringWithFormat:@"0 5 %@ %@ *", gracePeriod, recurring];
                
                [migratedSchedules addObject:updatedSchedule];
            } else {
                [migratedSchedules addObject:schedule];
            }
        }
        
        migratedTaskAndSchedules[kJsonSchedulesKey] = migratedSchedules;
    }
    
    return migratedTaskAndSchedules;
}

- (void)performMigrationAfterDataSubstrateFrom:(NSInteger) __unused previousVersion currentVersion:(NSInteger) __unused currentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSError *migrationError = nil;
    
    if (self.doesPersisteStoreExist == NO)
    {
        APCLogEvent(@"This application is being launched for the first time. We know this because there is no persistent store.");
    }
    else if ( [defaults objectForKey:@"previousVersion"] == nil)
    {
        APCLogEvent(@"The entire data model version %d", kTheEntireDataModelOfTheApp);
        
        NSError *jsonError = nil;
        NSString *resource = [[NSBundle mainBundle] pathForResource:@"APHTasksAndSchedules" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:resource];
        NSDictionary *tasksAndScheduledFromJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
        
        NSDictionary *migratedSchedules = [self migrateTasksAndSchedules:tasksAndScheduledFromJSON];
        
        [APCSchedule updateSchedulesFromJSON:migratedSchedules[kJsonSchedulesKey]
                                   inContext:self.dataSubstrate.persistentContext];
    }
    
    [defaults setObject:majorVersion forKey:@"shortVersionString"];
    [defaults setObject:minorVersion forKey:@"version"];
    
    if (!migrationError)
    {
        [defaults setObject:@(currentVersion) forKey:@"previousVersion"];
    }
    
}

- (id <APCProfileViewControllerDelegate>) profileExtenderDelegate {
    
    return self.profileExtender;
}

- (void) setUpAppAppearance
{
    [APCAppearanceInfo setAppearanceDictionary:@{
                                                 kPrimaryAppColorKey : [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000],

                                                 @"3-APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF":         [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000],
                                                 @"6-APHDailyJournal-80F09109-265A-49C6-9C5D-765E49AAF5D9" :      [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000],
                                                 @"4-APHExerciseSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF" :    [UIColor colorWithRed:0.937 green:0.004 blue:0.553 alpha:1.000],
                                                 @"8-Feedback-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e" :             [UIColor lightGrayColor],
                                                 @"7-MyThoughts-14ffde40-1551-4b48-aae2-8fef38d61b61" :           [UIColor lightGrayColor],
                                                 @"2-BCPTSymptomsSurvey-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e" :   [UIColor lightGrayColor],
                                                 @"e-PAOFI-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e":                 [UIColor lightGrayColor],
                                                 @"9-PHQ8GAD7-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e":              [UIColor lightGrayColor],
                                                 @"a-PSQI-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e":                  [UIColor lightGrayColor],
                                                 @"b-SF36-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e":                  [UIColor lightGrayColor],
                                                 @"c-Weekly-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e":                [UIColor lightGrayColor],
                                                 @"5-parqquiz-1E174061-5B02-11E4-8ED6-0800200C9A77":              [UIColor lightGrayColor],
                                                 @"1-BackgroundSurvey-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e":      [UIColor lightGrayColor],
                                                 }];
    
    [[UINavigationBar appearance] setTintColor:[UIColor appPrimaryColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName : [UIColor appSecondaryColor2],
                                                            NSFontAttributeName : [UIFont appNavBarTitleFont]
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

- (NSArray *)offsetForTaskSchedules
{
    return @[];
}

- (NSArray *)allSetTextBlocks
{
    NSArray *allSetBlockOfText = nil;
    
    NSString *activitiesAdditionalText = NSLocalizedString(@"You will be able to log, as often as you like, your mood, energy, sleep, thinking and excercise, and an activity of your choice.",
                                                           @"You will be able to log, as often as you like, your mood, energy, sleep, thinking and excercise, and an activity of your choice.");
    allSetBlockOfText = @[@{kAllSetActivitiesTextAdditional: activitiesAdditionalText}];
    
    return allSetBlockOfText;
}


/*********************************************************************************/
#pragma mark - Datasubstrate Delegate Methods
/*********************************************************************************/
- (void) setUpCollectors
{
    //
    // Set up location tracker
    //
    APCCoreLocationTracker * locationTracker = [[APCCoreLocationTracker alloc] initWithIdentifier: @"locationTracker"
                                                                           deferredUpdatesTimeout: 60.0 * 60.0
                                                                            andHomeLocationStatus: APCPassiveLocationTrackingHomeLocationUnavailable];
    
    if (locationTracker != nil)
    {
        [self.passiveDataCollector addTracker: locationTracker];
    }
}

/*********************************************************************************/
#pragma mark - APCOnboardingDelegate Methods
/*********************************************************************************/

- (APCScene *)inclusionCriteriaSceneForOnboarding:(APCOnboarding *) __unused onboarding
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
