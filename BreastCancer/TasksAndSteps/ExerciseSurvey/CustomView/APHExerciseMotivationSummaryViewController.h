//
//  APHExerciseMotivationSummaryViewController.h 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import <APCAppCore/APCAppCore.h>

@interface APHExerciseMotivationSummaryViewController : APCStepViewController
@property (weak, nonatomic)  NSString *questionResult1;
@property (weak, nonatomic)  NSString *questionResult2;
@property (weak, nonatomic)  NSString *questionResult3;
@property (weak, nonatomic)  NSString *questionResult4;
@property (weak, nonatomic)  NSString *questionResult5;

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIButton *changeExerciseGoalButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeYourExeriseGoalHeightConstant;
- (void) setAnswersInTableview:(NSMutableArray*)answers;
- (IBAction)changeExerciseGoalAction:(id)sender;
@end
