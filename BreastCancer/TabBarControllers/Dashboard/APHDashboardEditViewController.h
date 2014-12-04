//
//  APHDashboardEditViewController.h
//  CardioHealth
//
//  Created by Ramsundar Shandilya on 11/13/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

@import APCAppCore;

typedef NS_ENUM(APCTableViewItemType, APHDashboardItemType) {
    kAPHDashboardItemTypeDailyJournal,
    kAPHDashboardItemTypeDailyFeeling,
    kAPHDashboardItemTypeDailyMood,
    kAPHDashboardItemTypeDailyEnergy,
    kAPHDashboardItemTypeDailySleep,
    kAPHDashboardItemTypeDailyExercise
};

@interface APHDashboardEditViewController : APCDashboardEditViewController

@end
