// 
//  APHDashboardViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
/* Controllers */
#import "APHDashboardViewController.h"
#import "APHDashboardEditViewController.h"

static NSString * const kAPCBasicTableViewCellIdentifier       = @"APCBasicTableViewCell";
static NSString * const kAPCRightDetailTableViewCellIdentifier = @"APCRightDetailTableViewCell";

@interface APHDashboardViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray *rowItemsOrder;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) APCScoring *stepScoring;
@property (nonatomic, strong) APCScoring *moodScoring;
@property (nonatomic, strong) APCScoring *energyScoring;
@property (nonatomic, strong) APCScoring *sleepScoring;
@property (nonatomic, strong) APCScoring *exerciseScoring;
@property (nonatomic, strong) APCScoring *cognitiveScoring;

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
            
            [defaults setObject:[NSArray arrayWithArray:_rowItemsOrder] forKey:kAPCDashboardRowItemsOrder];
            [defaults synchronize];
            
        }
        
        self.title = NSLocalizedString(@"Dashboard", @"Dashboard");
        
        _dateFormatter = [NSDateFormatter new];
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
    
    [self prepareScoringObjects];
    [self prepareData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Data

- (void)updateVisibleRowsInTableView:(NSNotification *)notification
{
    [self prepareData];
}

- (void)prepareScoringObjects {
    
        HKQuantityType *stepQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        self.stepScoring= [[APCScoring alloc] initWithHealthKitQuantityType:stepQuantityType unit:[HKUnit countUnit] numberOfDays:-5];

        self.moodScoring = [[APCScoring alloc] initWithTask:@"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                numberOfDays:-5
                                                    valueKey:@"moodsurvey103"
                                                    dataKey:nil
                                                    sortKey:nil
                                                 groupBy:APHTimelineGroupDay];
    
        self.energyScoring = [[APCScoring alloc] initWithTask:@"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                  numberOfDays:-5
                                                      valueKey:@"moodsurvey104"
                                                      dataKey:nil
                                                      sortKey:nil
                                                   groupBy:APHTimelineGroupDay];
    
        self.exerciseScoring = [[APCScoring alloc] initWithTask:@"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                  numberOfDays:-5
                                                      valueKey:@"moodsurvey106"
                                                        dataKey:nil
                                                        sortKey:nil
                                                     groupBy:APHTimelineGroupDay];
    
        self.sleepScoring = [[APCScoring alloc] initWithTask:@"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                  numberOfDays:-5
                                                      valueKey:@"moodsurvey105"
                                                     dataKey:nil
                                                     sortKey:nil
                                                  groupBy:APHTimelineGroupDay];
    
        self.cognitiveScoring = [[APCScoring alloc] initWithTask:@"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                  numberOfDays:-5
                                                      valueKey:@"moodsurvey102"
                                                         dataKey:nil
                                                         sortKey:nil
                                                      groupBy:APHTimelineGroupDay];
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
            
            APCTableViewRow *row = [APCTableViewRow new];
            row.item = item;
            row.itemType = kAPCTableViewDashboardItemTypeProgress;
            [rowItems addObject:row];
        }
        
        
        APCTableViewSection *section = [APCTableViewSection new];
        NSDate *dateToday = [NSDate date];
        
        self.dateFormatter.dateFormat = @"MMMM d";
        
        section.sectionTitle = [NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"Today", @""), [self.dateFormatter stringFromDate:dateToday]];
        section.rows = [NSArray arrayWithArray:rowItems];
        section.rows = [NSArray arrayWithArray:rowItems];
        [self.items addObject:section];
    }
    
    {
        NSMutableArray *rowItems = [NSMutableArray new];
        
        for (NSNumber *typeNumber in self.rowItemsOrder) {
            
            APHDashboardItemType rowType = typeNumber.integerValue;

            switch (rowType) {

                case kAPHDashboardItemTypeHealthKitSteps:{
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Steps", @"");
                    item.graphData = self.stepScoring;
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %lu", @"Average: {value}"), [[self.stepScoring averageDataPoint] integerValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    /* Placeholder values.-- */
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
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
                    item.detailText = [NSString stringWithFormat: NSLocalizedString(@"Average : %0.0f", @"Average: {value}"), [[self.moodScoring averageDataPoint] doubleValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    /* Placeholder values.-- */
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
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
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f", @"Average: {value}"), [[self.energyScoring averageDataPoint] doubleValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryGreenColor];
                    
                    /* Placeholder values.-- */
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
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
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f", @"Average: {value}"), [[self.exerciseScoring averageDataPoint] doubleValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    /* Placeholder values.-- */
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
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
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f", @"Average: {value}"), [[self.sleepScoring averageDataPoint] doubleValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    /* Placeholder values.-- */
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyCognitive:
                {
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Cognitive Function", @"");
                    item.graphData = self.cognitiveScoring;
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %0.0f", @"Average: {value} ft"), [[self.cognitiveScoring averageDataPoint] doubleValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryRedColor];
                    
                    /* Placeholder values.-- */
                    item.info = NSLocalizedString(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"");
                    
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
