// 
//  APHDashboardViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
/* Controllers */
#import "APHDashboardViewController.h"
#import "APHDashboardEditViewController.h"
#import "APHAppDelegate.h"

static NSString * const kAPCBasicTableViewCellIdentifier       = @"APCBasicTableViewCell";
static NSString * const kAPCRightDetailTableViewCellIdentifier = @"APCRightDetailTableViewCell";

@interface APHDashboardViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray *rowItemsOrder;

@property (nonatomic, strong) APCScoring *stepScoring;
@property (nonatomic, strong) APCScoring *moodScoring;
@property (nonatomic, strong) APCScoring *energyScoring;
@property (nonatomic, strong) APCScoring *sleepScoring;
@property (nonatomic, strong) APCScoring *exerciseScoring;
@property (nonatomic, strong) APCScoring *cognitiveScoring;
@property (nonatomic, strong) APCScoring *customScoring;

@end

@implementation APHDashboardViewController

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _rowItemsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kAPCDashboardRowItemsOrder]];
        
        if (!_rowItemsOrder.count) {
            _rowItemsOrder = [[NSMutableArray alloc] initWithArray:@[
                                                                     @(kAPHDashboardItemTypeHealthKitSteps),
                                                                     @(kAPHDashboardItemTypeDailyMood),
                                                                     @(kAPHDashboardItemTypeDailyEnergy),
                                                                     @(kAPHDashboardItemTypeDailyExercise),
                                                                     @(kAPHDashboardItemTypeDailySleep),
                                                                     @(kAPHDashboardItemTypeDailyCognitive)
                                                                    ]];
            
            APCAppDelegate *appDelegate = (APCAppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *customSurveyQuestion = appDelegate.dataSubstrate.currentUser.customSurveyQuestion;
            if (customSurveyQuestion != nil && ![customSurveyQuestion isEqualToString:@""]) {
                _rowItemsOrder = [[NSMutableArray alloc] initWithArray:@[
                                                                         @(kAPHDashboardItemTypeHealthKitSteps),
                                                                         @(kAPHDashboardItemTypeDailyMood),
                                                                         @(kAPHDashboardItemTypeDailyEnergy),
                                                                         @(kAPHDashboardItemTypeDailyExercise),
                                                                         @(kAPHDashboardItemTypeDailySleep),
                                                                         @(kAPHDashboardItemTypeDailyCognitive),
                                                                         @(kAPHDashboardItemTypeDailyCustom)
                                                                         ]];
            }
            
            [defaults setObject:[NSArray arrayWithArray:_rowItemsOrder] forKey:kAPCDashboardRowItemsOrder];
            [defaults synchronize];
            
        }
        
        self.title = NSLocalizedString(@"Dashboard", @"Dashboard");
        
    }
    
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self prepareScoringObjects];
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.rowItemsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kAPCDashboardRowItemsOrder]];
    
    APCAppDelegate *appDelegate = (APCAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *customSurveyQuestion = appDelegate.dataSubstrate.currentUser.customSurveyQuestion;
    
    BOOL hasNoCustomQuestionItem = NO;
    
    for (NSUInteger i = 0; i < self.rowItemsOrder.count; i++)
    {
        if ([self.rowItemsOrder[i]  isEqual: @(kAPHDashboardItemTypeDailyCustom)]) {
            hasNoCustomQuestionItem = YES;
        }
    }
    
    if (customSurveyQuestion != nil && ![customSurveyQuestion isEqualToString:@""] && hasNoCustomQuestionItem == NO) {
        
        self.rowItemsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kAPCDashboardRowItemsOrder]];
        
        [self.rowItemsOrder addObject:@(kAPHDashboardItemTypeDailyCustom)];
        
        [defaults setObject:[NSArray arrayWithArray:_rowItemsOrder] forKey:kAPCDashboardRowItemsOrder];
        [defaults synchronize];
    }
    
    
    
    [self prepareScoringObjects];
    [self prepareData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Data

- (void)updateVisibleRowsInTableView:(NSNotification *) __unused notification
{
    [self prepareData];
}

- (void)prepareScoringObjects {
    
    HKQuantityType *stepQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    self.stepScoring= [[APCScoring alloc] initWithHealthKitQuantityType:stepQuantityType unit:[HKUnit countUnit] numberOfDays:-kNumberOfDaysToDisplay];

    self.moodScoring = [[APCScoring alloc] initWithTask:@"3-APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                           numberOfDays:-kNumberOfDaysToDisplay
                                               valueKey:@"moodsurvey103"
                                             latestOnly:NO];
    self.moodScoring.customMinimumPoint = 1.0;
    self.moodScoring.customMaximumPoint = 5.0;
    
    self.energyScoring = [[APCScoring alloc] initWithTask:@"3-APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                  numberOfDays:-kNumberOfDaysToDisplay
                                                      valueKey:@"moodsurvey104"
                                               latestOnly:NO];
    self.energyScoring.customMinimumPoint = 1.0;
    self.energyScoring.customMaximumPoint = 5.0;
    
    self.exerciseScoring = [[APCScoring alloc] initWithTask:@"3-APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                               numberOfDays:-kNumberOfDaysToDisplay
                                                   valueKey:@"moodsurvey106"
                                                 latestOnly:NO];
    self.exerciseScoring.customMinimumPoint = 1.0;
    self.exerciseScoring.customMaximumPoint = 5.0;
    
    self.sleepScoring = [[APCScoring alloc] initWithTask:@"3-APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                            numberOfDays:-kNumberOfDaysToDisplay
                                                valueKey:@"moodsurvey105"
                                              latestOnly:NO];
    self.sleepScoring.customMinimumPoint = 1.0;
    self.sleepScoring.customMaximumPoint = 5.0;
    
    self.cognitiveScoring = [[APCScoring alloc] initWithTask:@"3-APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                numberOfDays:-kNumberOfDaysToDisplay
                                                    valueKey:@"moodsurvey102"
                                                  latestOnly:NO];
    self.cognitiveScoring.customMinimumPoint = 1.0;
    self.cognitiveScoring.customMaximumPoint = 5.0;
    
    self.customScoring = [[APCScoring alloc] initWithTask:@"3-APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                             numberOfDays:-kNumberOfDaysToDisplay
                                                 valueKey:@"moodsurvey107"
                                               latestOnly:NO];
    self.customScoring.customMinimumPoint = 1.0;
    self.customScoring.customMaximumPoint = 5.0;
}

- (void)prepareData
{
    [self.items removeAllObjects];
    
    {
        NSMutableArray *rowItems = [NSMutableArray new];
        
        NSUInteger allScheduledTasks = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.countOfAllScheduledTasksForToday;
        NSUInteger completedScheduledTasks = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.countOfCompletedScheduledTasksForToday;
                
        {
            APCTableViewDashboardProgressItem *item = [APCTableViewDashboardProgressItem new];
            item.identifier = kAPCDashboardProgressTableViewCellIdentifier;
            item.editable = NO;
            item.progress = (CGFloat)completedScheduledTasks/allScheduledTasks;
            item.caption = NSLocalizedString(@"Activity Completion", @"Activity Completion");
            
            item.info = NSLocalizedString(@"The activity completion indicates the percentage of activities scheduled for today that you have completed.  You can complete more by going to the Activities section and tapping on any incomplete task.", @"");
            
            APCTableViewRow *row = [APCTableViewRow new];
            row.item = item;
            row.itemType = kAPCTableViewDashboardItemTypeProgress;
            [rowItems addObject:row];
        }
        
        for (NSNumber *typeNumber in self.rowItemsOrder) {
            
            APHDashboardItemType rowType = typeNumber.integerValue;

            switch (rowType) {

                case kAPHDashboardItemTypeHealthKitSteps:{
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Steps", @"");
                    item.graphData = self.stepScoring;
                    
                    if ([[self.stepScoring averageDataPoint] doubleValue] > 0) {
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %lu", @"Average: {value}"), [[self.stepScoring averageDataPoint] integerValue]];
                    }
                    
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    item.info = NSLocalizedString(@"This graph shows the number of steps that you took each day measured by your phone or fitness tracker (if you have one).", @"");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyMood:{
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Mood", @"");
                    item.graphData = self.moodScoring;
                    item.graphType = kAPCDashboardGraphTypeDiscrete;
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    item.minimumImage = [UIImage imageNamed:@"Breast-Cancer-Mood-5g"];
                    item.maximumImage = [UIImage imageNamed:@"Breast-Cancer-Mood-1g"];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"datasetValueKey != %@", @(NSNotFound)];
                    NSArray *scoringObjects = [[self.moodScoring allObjects] filteredArrayUsingPredicate:predicate];
                    
                    if ([[self.moodScoring averageDataPoint] doubleValue] > 0 && scoringObjects.count > 1) {
                        item.averageImage = [UIImage imageNamed:[NSString stringWithFormat:@"Breast-Cancer-Mood-%0.0fg", (double) 6 - [[self.moodScoring averageDataPoint] doubleValue]]];
                        item.detailText = [NSString stringWithFormat: NSLocalizedString(@"Average : ", @"Average:")];
                    }
                    
                    item.info = NSLocalizedString(@"This graph shows your answers to the daily check-in questions for mood each day. ", @"");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyEnergy:{

                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Energy Level", @"");
                    item.graphData = self.energyScoring;
                    item.graphType = kAPCDashboardGraphTypeDiscrete;
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryGreenColor];
                    
                    item.minimumImage = [UIImage imageNamed:@"Breast-Cancer-Energy-5g"];
                    item.maximumImage = [UIImage imageNamed:@"Breast-Cancer-Energy-1g"];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"datasetValueKey != %@", @(NSNotFound)];
                    NSArray *scoringObjects = [[self.moodScoring allObjects] filteredArrayUsingPredicate:predicate];
                    
                    if ([[self.energyScoring averageDataPoint] doubleValue] > 0 && scoringObjects.count > 1) {
                        item.averageImage = [UIImage imageNamed:[NSString stringWithFormat:@"Breast-Cancer-Energy-%0.0fg", (double) 6 - [[self.energyScoring averageDataPoint] doubleValue]]];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : ", @"")];
                    }
                    
                    
                    item.info = NSLocalizedString(@"This graph shows your answers to the daily check-in questions for energy each day.", @"");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyExercise:{
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Exercise Level", @"");
                    item.graphData = self.exerciseScoring;
                    item.graphType = kAPCDashboardGraphTypeDiscrete;
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    item.minimumImage = [UIImage imageNamed:@"Breast-Cancer-Exercise-5g"];
                    item.maximumImage = [UIImage imageNamed:@"Breast-Cancer-Exercise-1g"];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"datasetValueKey != %@", @(NSNotFound)];
                    NSArray *scoringObjects = [[self.moodScoring allObjects] filteredArrayUsingPredicate:predicate];
                    
                    if ([[self.exerciseScoring averageDataPoint] doubleValue] > 0 && scoringObjects.count > 1) {
                        item.averageImage = [UIImage imageNamed:[NSString stringWithFormat:@"Breast-Cancer-Exercise-%0.0fg", (double) 6 - [[self.exerciseScoring averageDataPoint] doubleValue]]];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : ", @"")];
                    }
                    
                    
                    item.info = NSLocalizedString(@"This graph shows your answers to the daily check-in questions for exercise each day.", @"");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailySleep:{
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Sleep Quality", @"");
                    item.graphData = self.sleepScoring;
                    item.graphType = kAPCDashboardGraphTypeDiscrete;
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    item.minimumImage = [UIImage imageNamed:@"Breast-Cancer-Sleep-5g"];
                    item.maximumImage = [UIImage imageNamed:@"Breast-Cancer-Sleep-1g"];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"datasetValueKey != %@", @(NSNotFound)];
                    NSArray *scoringObjects = [[self.moodScoring allObjects] filteredArrayUsingPredicate:predicate];
                    
                    if ([[self.sleepScoring averageDataPoint] doubleValue] > 0 && scoringObjects.count > 1) {
                        item.averageImage = [UIImage imageNamed:[NSString stringWithFormat:@"Breast-Cancer-Sleep-%0.0fg", (double) 6 - [[self.sleepScoring averageDataPoint] doubleValue]]];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : ", @"Average: ")];
                    }
                    
                    item.info = NSLocalizedString(@"This graph shows your answers to the daily check-in questions for sleep each day.", @"");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyCognitive:
                {
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Thinking", @"");
                    item.graphData = self.cognitiveScoring;
                    item.graphType = kAPCDashboardGraphTypeDiscrete;
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryRedColor];
                    
                    item.minimumImage = [UIImage imageNamed:@"Breast-Cancer-Clarity-5g"];
                    item.maximumImage = [UIImage imageNamed:@"Breast-Cancer-Clarity-1g"];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"datasetValueKey != %@", @(NSNotFound)];
                    NSArray *moodScoringObjects = [[self.moodScoring allObjects] filteredArrayUsingPredicate:predicate];
                    
                    if ([[self.cognitiveScoring averageDataPoint] doubleValue] > 0 && moodScoringObjects.count > 1) {
                        
                        item.averageImage = [UIImage imageNamed:[NSString stringWithFormat:@"Breast-Cancer-Clarity-%0.0fg", (double) 6 - [[self.cognitiveScoring averageDataPoint] doubleValue]]];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : ", @"Average: ")];
                    }
                    
                    
                    item.info = NSLocalizedString(@"This graph shows your answers to the daily check-in questions for your thinking each day.", @"");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                    
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyCustom:
                {
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Custom Question", @"");
                    item.graphData = self.customScoring;
                    item.graphType = kAPCDashboardGraphTypeDiscrete;
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryBlueColor];
                    
                    item.minimumImage = [UIImage imageNamed:@"Breast-Cancer-Custom-5g"];
                    item.maximumImage = [UIImage imageNamed:@"Breast-Cancer-Custom-1g"];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"datasetValueKey != %@", @(NSNotFound)];
                    NSArray *scoringObjects = [[self.moodScoring allObjects] filteredArrayUsingPredicate:predicate];
                    
                    if ([[self.customScoring averageDataPoint] doubleValue] > 0 && scoringObjects.count > 1) {
                        item.averageImage = [UIImage imageNamed:[NSString stringWithFormat:@"Breast-Cancer-Custom-%0.0fg", (double) 6 - [[self.customScoring averageDataPoint] doubleValue]]];
                        item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : ", @"Average: ")];
                    }
                    
                    item.info = NSLocalizedString(@"This graph shows your answers to the custom question that you created as part of your daily check-in questions.", nil);
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        APCTableViewSection *section = [APCTableViewSection new];
        section.rows = [NSArray arrayWithArray:rowItems];
        section.sectionTitle = NSLocalizedString(@"Recent Activity", @"");
        [self.items addObject:section];
    }
    
    [self.tableView reloadData];
}

@end
