// 
//  APHAppDelegate.m 
//  Share the Journey 
// 
// Copyright (c) 2015, Sage Bionetworks. All rights reserved. 
// 
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
// 
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// 
// 2.  Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution. 
// 
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission. No license is granted to the trademarks of 
// the copyright holders even if such marks are included in this software. 
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
// 
 
@import APCAppCore;
#import "APHAppDelegate.h"
#import "APHProfileExtender.h"

/*********************************************************************************/
#pragma mark - Initializations Options
/*********************************************************************************/
static NSString* const  kStudyIdentifier            = @"studyname";
static NSString* const  kAppPrefix                  = @"studyname";
static NSString* const  kVideoShownKey              = @"VideoShown";
static NSString* const  kConsentPropertiesFileName  = @"APHConsentSection";

static NSString *const kJsonScheduleStringKey           = @"scheduleString";
static NSString *const kJsonTasksKey                    = @"tasks";
static NSString *const kJsonScheduleTaskIDKey           = @"taskID";
static NSString *const kJsonSchedulesKey                = @"schedules";

static NSString *const kPersonalHealthSurveyTaskId      = @"9-PHQ8GAD7-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e";
static NSString *const kWeeklyScheduleTaskId            = @"c-Weekly-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e";
static NSString *const kAssessmentOfFunctioningTaskId   = @"e-PAOFI-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e";
static NSString *const kSleepQualitySurveyTaskId        = @"a-PSQI-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e";
static NSString *const kGeneralHealthSurveyTaskId       = @"b-SF36-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e";

static NSInteger const kPersonalHealthSurveyOffset      = 2;
static NSInteger const kAssessmentOfFunctioningOffset   = 3;
static NSInteger const kSleepQualitySurveyOffset        = 4;
static NSInteger const kGeneralHealthSurveyOffset       = 5;

static NSInteger const kWeeklyScheduleDayOffset         = 6;

static NSInteger const kExpectedNumOfCompInScheduleStr  = 5;

static NSInteger const kMonthObject                     = 3;
static NSInteger const kMonthOfDayObject                = 2;


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
                                                   ]
                                           }];
    self.initializationOptions = dictionary;
    self.profileExtender = [[APHProfileExtender alloc] init];
}


- (NSDictionary *) tasksAndSchedulesWillBeLoaded {
    
    NSString                    *resource = [[NSBundle mainBundle] pathForResource:self.initializationOptions[kTasksAndSchedulesJSONFileNameKey]
                                                                            ofType:@"json"];
    
    NSData                      *jsonData = [NSData dataWithContentsOfFile:resource];
    NSError                     *error;
    NSDictionary                *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                              options:NSJSONReadingMutableContainers
                                                                                error:&error];
    if (dictionary == nil) {
        APCLogError2 (error);
    }
    
    NSArray                     *schedules = [dictionary objectForKey:kJsonSchedulesKey];
    NSMutableDictionary         *newDictionary = [dictionary mutableCopy];
    NSMutableArray              *newSchedulesArray = [NSMutableArray new];

    for (NSDictionary *schedule in schedules) {
        
        NSString *taskIdentifier = [schedule objectForKey:kJsonScheduleTaskIDKey];
        
        if ([taskIdentifier isEqualToString:kPersonalHealthSurveyTaskId] || [taskIdentifier  isEqualToString: kAssessmentOfFunctioningTaskId] || [taskIdentifier  isEqualToString: kSleepQualitySurveyTaskId] || [taskIdentifier  isEqualToString: kGeneralHealthSurveyTaskId]) {
            
            NSDate              *date = [NSDate date];
            NSDateComponents    *dateComponent = [[NSDateComponents alloc] init];
            
            NSInteger daysOffset = 0;
            
            if ([taskIdentifier  isEqualToString: kPersonalHealthSurveyTaskId])
            {
                daysOffset = kPersonalHealthSurveyOffset;
                
            }
            else if ([taskIdentifier  isEqualToString: kAssessmentOfFunctioningTaskId])
            {
                daysOffset = kAssessmentOfFunctioningOffset;
            }
            else if ([taskIdentifier  isEqualToString: kSleepQualitySurveyTaskId])
            {
                daysOffset = kSleepQualitySurveyOffset;
            }
            else if ([taskIdentifier  isEqualToString: kGeneralHealthSurveyTaskId])
            {
                daysOffset = kGeneralHealthSurveyOffset;
                
            }
            
            [dateComponent setDay:daysOffset];
            
            NSDate              *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponent
                                                                                         toDate:date
                                                                                        options:0];
            
            NSCalendar          *cal = [NSCalendar currentCalendar];
            
            NSDateComponents    *components = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth)
                                                     fromDate:newDate];
            NSString            *scheduleString = [schedule objectForKey:kJsonScheduleStringKey];
            NSMutableArray      *scheduleObjects = [[scheduleString componentsSeparatedByString:@" "] mutableCopy];


            [scheduleObjects replaceObjectAtIndex:kMonthOfDayObject withObject:@([components day])];

            if ([taskIdentifier  isEqualToString: kGeneralHealthSurveyTaskId])
            {
                //Change to every third of the month using /3
                NSString *newMonthExpression = [NSString stringWithFormat:@"%ld/3", (long)[components month]];
                
                [scheduleObjects replaceObjectAtIndex:kMonthObject withObject:newMonthExpression];
            }
            
            NSString            *newScheduleString = [scheduleObjects componentsJoinedByString:@" "];
            
            [schedule setValue:newScheduleString
                        forKey:kJsonScheduleStringKey];
            
            [newSchedulesArray addObject:schedule];
            
        }
        else if ( [taskIdentifier isEqualToString: kWeeklyScheduleTaskId])
        {
            NSDate              *date = [NSDate date];
            NSDateComponents    *dateComponent = [[NSDateComponents alloc] init];
            [dateComponent setDay:kWeeklyScheduleDayOffset];
            
            NSDate              *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponent
                                                                                         toDate:date
                                                                                        options:0];
            
            NSCalendar          *cal = [NSCalendar currentCalendar];
            NSDateComponents    *components = [cal components:(NSCalendarUnitWeekday)
                                                     fromDate:newDate];
            
            NSInteger           nonZeroBasedDay = components.weekday;
            NSInteger           zeroBasedDay = nonZeroBasedDay - 1;
            NSString            *scheduleString = [schedule objectForKey:kJsonScheduleStringKey];
            NSMutableArray      *scheduleObjects = [[scheduleString componentsSeparatedByString:@" "] mutableCopy];
            
            if ([scheduleObjects count] == kExpectedNumOfCompInScheduleStr) {
                [scheduleObjects removeLastObject];
                
                [scheduleObjects addObject:[NSString stringWithFormat:@"%ld", (long)zeroBasedDay]];
            }
            
            NSString            *newScheduleString = [scheduleObjects componentsJoinedByString:@" "];
            
            [schedule setValue:newScheduleString
                        forKey:kJsonScheduleStringKey];
            
            [newSchedulesArray addObject:schedule];
            
        }
        else {
            [newSchedulesArray addObject:schedule];
        }
    }
    
    [newDictionary setValue:[dictionary objectForKey:kJsonTasksKey]
                     forKey:kJsonTasksKey];
    
    [newDictionary setValue:newSchedulesArray
                     forKey:kJsonSchedulesKey];
    
    return newDictionary;
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
                                                 @"c-Weekly-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e":                [UIColor lightGrayColor],
                                                 @"1-BackgroundSurvey-394848ce-ca4f-4abe-b97e-fedbfd7ffb8e":      [UIColor lightGrayColor],
                                                 }];
    
    [[UINavigationBar appearance] setTintColor:[UIColor appPrimaryColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName : [UIColor appSecondaryColor2],
                                                            NSFontAttributeName : [UIFont appNavBarTitleFont]
                                                            }];
    
    [[UIView appearance] setTintColor:[UIColor appPrimaryColor]];
    
    //  Enable server bypass
    self.dataSubstrate.parameters.bypassServer = YES;
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
//  Turning off location tracking for verison 1.0 release
//    APCCoreLocationTracker * locationTracker = [[APCCoreLocationTracker alloc] initWithIdentifier: @"locationTracker"
//                                                                           deferredUpdatesTimeout: 60.0 * 60.0
//                                                                            andHomeLocationStatus: APCPassiveLocationTrackingHomeLocationUnavailable];
//    [self.passiveDataCollector addTracker: locationTracker];
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
