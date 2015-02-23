// 
//  APHDashboardEditViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHDashboardEditViewController.h"

@implementation APHDashboardEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareData];
}

- (void)prepareData
{
    [self.items removeAllObjects];
    
    {
        for (NSNumber *typeNumber in self.rowItemsOrder) {
            
            APHDashboardItemType rowType = typeNumber.integerValue;
                        
            switch (rowType) {
                case kAPHDashboardItemTypeHealthKitSteps:{
                    
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Steps", @"");
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    [self.items addObject:item];
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyMood:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Mood", @"");
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    [self.items addObject:item];
                    
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyEnergy:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Energy Level", @"");
                    item.tintColor = [UIColor appTertiaryGreenColor];
                    
                    [self.items addObject:item];
                    
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyExercise:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Exercise Level", @"");
                    item.tintColor = [UIColor appTertiaryYellowColor];
                    
                    [self.items addObject:item];
                    
                }
                    break;
                    
                case kAPHDashboardItemTypeDailySleep:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Sleep Quality", @"");
                    item.tintColor = [UIColor appTertiaryPurpleColor];
                    
                    [self.items addObject:item];
                    
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyCognitive:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Cognitive Function", @"");
                    item.tintColor = [UIColor appTertiaryRedColor];
                    
                    [self.items addObject:item];
                    
                }
                    break;
                    
                case kAPHDashboardItemTypeDailyCustom:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Custom Question", @"");
                    item.tintColor = [UIColor appTertiaryBlueColor];
                    
                    [self.items addObject:item];
                }
                    break;

                default:
                    break;
            }
        }
        
    }
}

@end
