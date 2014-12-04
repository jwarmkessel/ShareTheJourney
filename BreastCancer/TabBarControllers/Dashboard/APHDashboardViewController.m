//
//  APHOverviewViewController.m
//  BasicTabBar
//
//  Created by Henry McGilton on 9/7/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

/* Controllers */
#import "APHDashboardViewController.h"
#import "APHDashboardEditViewController.h"

/* Scoring */
#import "APHScoring.h"

static NSString * const kAPCBasicTableViewCellIdentifier       = @"APCBasicTableViewCell";
static NSString * const kAPCRightDetailTableViewCellIdentifier = @"APCRightDetailTableViewCell";

@interface APHDashboardViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray *rowItemsOrder;

@property (nonatomic, strong) APHScoring *distanceScore;
@property (nonatomic, strong) APHScoring *heartRateScore;

@property (nonatomic, strong) APHScoring *feelingScore;
@property (nonatomic, strong) APHScoring *moodScore;
@property (nonatomic, strong) APHScoring *energyScore;
@property (nonatomic, strong) APHScoring *sleepScore;
@property (nonatomic, strong) APHScoring *exerciseScore;


@property (nonatomic, strong) APCPresentAnimator *presentAnimator;

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
        
        _presentAnimator = [APCPresentAnimator new];
    }
    
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.rowItemsOrder = [NSMutableArray arrayWithArray:[defaults objectForKey:kAPCDashboardRowItemsOrder]];
    
    [self prepareData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Data

- (void)prepareData
{
    [self.items removeAllObjects];
    
    {
        NSMutableArray *rowItems = [NSMutableArray new];
        
        NSUInteger allScheduledTasks = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.countOfAllScheduledTasksForToday;
        NSUInteger completedScheduledTasks = ((APCAppDelegate *)[UIApplication sharedApplication].delegate).dataSubstrate.countOfCompletedScheduledTasksForToday;
        
        {
            APCTableViewItem *item = [APCTableViewItem new];
            item.caption = NSLocalizedString(@"Activities", @"");
            item.identifier = kAPCRightDetailTableViewCellIdentifier;
            item.editable = NO;
            item.textAlignnment = NSTextAlignmentRight;
            
            
            item.detailText = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)completedScheduledTasks, (unsigned long)allScheduledTasks];
            
            APCTableViewRow *row = [APCTableViewRow new];
            row.item = item;
            row.itemType = kAPCTableViewDashboardItemTypeProgress;
            [rowItems addObject:row];
        }
        
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
        section.sectionTitle = NSLocalizedString(@"Today", @"");
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
                    item.graphData = self.heartRateScore;
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %lu", @"Average: {value}"), [[self.heartRateScore averageDataPoint] integerValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyMood:{
                    
                    APHScoring *scoring = [[APHScoring alloc] initWithTask:@"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                              numberOfDays:-5
                                                                  valueKey:@"moodsurvey103" dataKey:nil];
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Mood", @"");
                    item.graphData = scoring;
                    item.detailText = [NSString stringWithFormat: NSLocalizedString(@"Average : %lu", @"Average: {value}"), [[scoring averageDataPoint] integerValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyEnergy:{
                    
                    APHScoring *scoring = [[APHScoring alloc] initWithTask:@"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                              numberOfDays:-5
                                                                  valueKey:@"moodsurvey104" dataKey:nil];
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Energy Level", @"");
                    item.graphData = scoring;
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %lu", @"Average: {value}"), [[self.heartRateScore averageDataPoint] integerValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryGreenColor];
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyExercise:{
                    
                    APHScoring *scoring = [[APHScoring alloc] initWithTask:@"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                              numberOfDays:-5
                                                                  valueKey:@"moodsurvey106" dataKey:nil];
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Exercise Level", @"");
                    item.graphData = scoring;
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %lu", @"Average: {value}"), [[self.heartRateScore averageDataPoint] integerValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailySleep:{
                    
                    APHScoring *scoring = [[APHScoring alloc] initWithTask:@"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                              numberOfDays:-5
                                                                  valueKey:@"moodsurvey105" dataKey:nil];
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Sleep Quality", @"");
                    item.graphData = scoring;
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %lu", @"Average: {value}"), [[self.heartRateScore averageDataPoint] integerValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    APCTableViewRow *row = [APCTableViewRow new];
                    row.item = item;
                    row.itemType = rowType;
                    [rowItems addObject:row];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyCognitive:
                {
                    APHScoring *scoring = [[APHScoring alloc] initWithTask:@"APHMoodSurvey-7259AC18-D711-47A6-ADBD-6CFCECDED1DF"
                                                              numberOfDays:-5
                                                                  valueKey:@"moodsurvey102" dataKey:nil];
                    
                    APCTableViewDashboardGraphItem *item = [APCTableViewDashboardGraphItem new];
                    item.caption = NSLocalizedString(@"Cognitive Function", @"");
                    item.graphData = scoring;
                    item.detailText = [NSString stringWithFormat:NSLocalizedString(@"Average : %lu", @"Average: {value} ft"), [[self.distanceScore averageDataPoint] integerValue]];
                    item.identifier = kAPCDashboardGraphTableViewCellIdentifier;
                    item.editable = YES;
                    item.tintColor = [UIColor appTertiaryRedColor];
                    
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
        section.sectionTitle = NSLocalizedString(@"Past 5 Days", @"");
        [self.items addObject:section];
    }
    
    [self.tableView reloadData];
}

#pragma mark - APCDashboardGraphTableViewCellDelegate methods

- (void)dashboardGraphViewCellDidTapExpandForCell:(APCDashboardLineGraphTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    APCTableViewDashboardGraphItem *graphItem = (APCTableViewDashboardGraphItem *)[self itemForIndexPath:indexPath];
    
    CGRect initialFrame = [cell convertRect:cell.bounds toView:self.view.window];
    self.presentAnimator.initialFrame = initialFrame;

    APCLineGraphViewController *graphViewController = [[UIStoryboard storyboardWithName:@"APHDashboard" bundle:nil] instantiateViewControllerWithIdentifier:@"GraphVC"];
    graphViewController.graphItem = graphItem;
//    graphViewController.transitioningDelegate = self;
//    graphViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:graphViewController animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    self.presentAnimator.presenting = YES;
    return self.presentAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    self.presentAnimator.presenting = NO;
    return self.presentAnimator;
}

@end
