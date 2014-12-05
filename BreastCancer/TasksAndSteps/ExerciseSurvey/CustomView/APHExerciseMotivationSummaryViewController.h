// 
//  APHExerciseMotivationSummaryViewController.h 
//  Share the Journey 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
// 
 
#import <APCAppCore/APCAppCore.h>

@interface APHExerciseMotivationSummaryViewController : APCStepViewController
@property (weak, nonatomic) IBOutlet UILabel *questionResult1;
@property (weak, nonatomic) IBOutlet UILabel *questionResult2;
@property (weak, nonatomic) IBOutlet UILabel *questionResult3;
@property (weak, nonatomic) IBOutlet UILabel *questionResult4;
@property (weak, nonatomic) IBOutlet UILabel *questionResult5;

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@end
