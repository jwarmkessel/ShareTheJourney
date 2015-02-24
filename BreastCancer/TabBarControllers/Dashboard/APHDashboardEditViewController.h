// 
//  APHDashboardEditViewController.h 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
@import APCAppCore;

typedef NS_ENUM(APCTableViewItemType, APHDashboardItemType) {
    kAPHDashboardItemTypeHealthKitSteps,
    kAPHDashboardItemTypeDailyCognitive,
    kAPHDashboardItemTypeDailyMood,
    kAPHDashboardItemTypeDailyEnergy,
    kAPHDashboardItemTypeDailySleep,
    kAPHDashboardItemTypeDailyExercise,
    kAPHDashboardItemTypeDailyCustom
};

@interface APHDashboardEditViewController : APCDashboardEditViewController

@end
