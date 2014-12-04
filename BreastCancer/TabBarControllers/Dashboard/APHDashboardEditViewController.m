//
//  APHDashboardEditViewController.m
//  CardioHealth
//
//  Created by Ramsundar Shandilya on 11/13/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
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
            
            //            @(kAPHDashboardItemTypeDailyFeeling),
            //            @(kAPHDashboardItemTypeDailyMood),
            //            @(kAPHDashboardItemTypeDailyEnergy),
            //            @(kAPHDashboardItemTypeDailySleep),
            //            @(kAPHDashboardItemTypeDailyExercise)
            
            switch (rowType) {
                case kAPHDashboardItemTypeDailyJournal:{
                    
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Daily Journal", @"");
                    
                    [self.items addObject:item];
                }
                    break;
                case kAPHDashboardItemTypeDailyFeeling:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Daily Feeling", @"");
                    
                    [self.items addObject:item];
                    
                }
                    break;
                case kAPHDashboardItemTypeDailyMood:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Daily Mood", @"");
                    
                    [self.items addObject:item];
                    
                }
                    break;
                case kAPHDashboardItemTypeDailyEnergy:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Daily Energy", @"");
                    
                    [self.items addObject:item];
                    
                }
                    break;
                case kAPHDashboardItemTypeDailySleep:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Daily Sleep", @"");
                    
                    [self.items addObject:item];
                    
                }
                    break;
                case kAPHDashboardItemTypeDailyExercise:
                {
                    APCTableViewDashboardItem *item = [APCTableViewDashboardItem new];
                    item.caption = NSLocalizedString(@"Daily Exercise", @"");
                    
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
