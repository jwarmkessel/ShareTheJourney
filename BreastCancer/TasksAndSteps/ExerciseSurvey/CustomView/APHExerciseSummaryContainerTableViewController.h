//
//  APHExerciseSummaryContainerTableViewController.h
//  Share the Journey 
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class APCButton;

@interface APHExerciseSummaryContainerTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *answers;
@property (weak, nonatomic) IBOutlet APCButton *changeYourGoalButton;
- (IBAction)changeYourGoalHandler:(id)sender;

@end
