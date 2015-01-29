// 
//  APHExerciseMotivationSummaryViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHExerciseMotivationSummaryViewController.h"
#import "APHExerciseSummaryContainerTableViewController.h"

static NSString* const  kAPHExerciseSummaryContainerTableViewControllerSegue = @"APHExerciseSummaryContainerTableViewControllerSegue";
static NSString* const  kSummaryStepIdentifier                               = @"exercisesurvey107";

@interface APHExerciseMotivationSummaryViewController ()
@property (nonatomic, strong) RKSTStepResult *cachedResult;
@property (nonatomic, strong) APHExerciseSummaryContainerTableViewController *childViewController;
@end

@implementation APHExerciseMotivationSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor appSecondaryColor4]];
}

- (void) setAnswersInTableview:(NSMutableArray*)answers {
        
    [self.childViewController setAnswers:answers];
}

- (void)changeExerciseGoalAction {
    
    if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
        [self.delegate stepViewController:(RKSTStepViewController *)self didFinishWithNavigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

- (void)doneButtonTapped:(id)sender
{
    if ([self.step.identifier isEqualToString:kSummaryStepIdentifier]) {
        
        if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
            [self.delegate stepViewController:self didFinishWithNavigationDirection:RKSTStepViewControllerNavigationDirectionForward];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kAPHExerciseSummaryContainerTableViewControllerSegue]) {
        self.childViewController = (APHExerciseSummaryContainerTableViewController *) [segue destinationViewController];
    }
}

- (RKSTStepResult *)result {
    
    self.cachedResult = [[RKSTStepResult alloc] initWithIdentifier:self.step.identifier];
    
    return self.cachedResult;
}

@end
