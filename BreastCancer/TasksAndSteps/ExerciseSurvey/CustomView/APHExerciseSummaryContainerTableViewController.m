//
//  APHExerciseSummaryContainerTableViewController.m
//  Share the Journey
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHExerciseSummaryContainerTableViewController.h"
#import "APHExerciseMotivationSummaryViewController.h"

static NSString* const  kSummaryStepIdentifier       = @"exercisesurvey107";
static NSString* const  kBreastCancerRibbonImageName = @"BreastCancer-Ribbon";

@interface APHExerciseSummaryContainerTableViewController ()
@property (weak, nonatomic) IBOutlet    UILabel* answer1Label;
@property (weak, nonatomic) IBOutlet    UILabel* answer2Label;
@property (weak, nonatomic) IBOutlet    UILabel* answer3Label;
@property (weak, nonatomic) IBOutlet    UILabel* answer4Label;
@property (weak, nonatomic) IBOutlet    UILabel* answer5Label;

@property (nonatomic, strong) APHExerciseMotivationSummaryViewController *parent;
@end

@implementation APHExerciseSummaryContainerTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.parent = (APHExerciseMotivationSummaryViewController *) self.parentViewController;
    
    if ([self.parent.step.identifier isEqualToString:kSummaryStepIdentifier]) {
        
        [self.changeYourGoalButton setTitle:@"Next" forState:UIControlStateNormal];
    }

}
- (void)setAnswers:(NSMutableArray *)answers {
    
    NSArray *answerLabels = @[self.answer1Label,
                              self.answer2Label,
                              self.answer3Label,
                              self.answer4Label,
                              self.answer5Label];
    
    int i = 0;
    
    for (UILabel *label in answerLabels) {
        label.text = [answers objectAtIndex:i];
        i++;
    }
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
    UIImageView *imgVew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBreastCancerRibbonImageName]];
    return imgVew;
}

- (IBAction)changeYourGoalHandler:(id)sender {
    [self.parent changeExerciseGoalAction];
}

- (void)doneButtonTapped:(id)sender
{
    if ([self.parent.step.identifier isEqualToString:kSummaryStepIdentifier]) {
        
        if ([self.parent.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
            [self.parent.delegate stepViewController:self.parent didFinishWithNavigationDirection:RKSTStepViewControllerNavigationDirectionForward];
        }
    }
}
@end
