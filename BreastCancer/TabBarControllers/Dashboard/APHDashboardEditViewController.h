// 
//  APHDashboardEditViewController.h 
//  Share the Journey 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
// 
 
@import APCAppCore;

typedef NS_ENUM(APCTableViewItemType, APHDashboardItemType) {
    kAPHDashboardItemTypeHealthKitSteps,
    kAPHDashboardItemTypeDailyCognitive,
    kAPHDashboardItemTypeDailyMood,
    kAPHDashboardItemTypeDailyEnergy,
    kAPHDashboardItemTypeDailySleep,
    kAPHDashboardItemTypeDailyExercise
};

@interface APHDashboardEditViewController : APCDashboardEditViewController

@end
