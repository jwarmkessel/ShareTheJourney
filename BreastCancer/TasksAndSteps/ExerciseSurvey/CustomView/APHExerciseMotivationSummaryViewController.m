// 
//  APHExerciseMotivationSummaryViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHExerciseMotivationSummaryViewController.h"
#import "APHExerciseSummaryContainerTableViewController.h"

@interface APHExerciseMotivationSummaryViewController ()

@property (nonatomic, strong) APHExerciseSummaryContainerTableViewController *childViewController;
@end

@implementation APHExerciseMotivationSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor appSecondaryColor4]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doneButtonTapped:)];
    
    if ([self.step.identifier isEqualToString:@"exercisesurvey107"]) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    
        self.changeYourExeriseGoalHeightConstant.constant = 0;
        self.changeExerciseGoalButton.alpha = 0;
        self.changeExerciseGoalButton.enabled = NO;
        [self.view layoutIfNeeded];
    }
}

- (void) setAnswersInTableview:(NSMutableArray*)answers {
        
    [self.childViewController setAnswers:answers];
}

- (IBAction)changeExerciseGoalAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
        [self.delegate stepViewController:self didFinishWithNavigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonTapped:(id)sender
{
    if ([self.step.identifier isEqualToString:@"exercisesurvey107"]) {
        
        if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
            [self.delegate stepViewController:self didFinishWithNavigationDirection:RKSTStepViewControllerNavigationDirectionForward];
        }

    } else if ([self.step.identifier isEqualToString:@"exercisesurvey100"]) {

//        if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
//            [self.delegate stepViewControllerDidCancel:self];
//        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString: @"APHExerciseSummaryContainerTableViewControllerSegue"]) {
        self.childViewController = (APHExerciseSummaryContainerTableViewController *) [segue destinationViewController];
    }
}


@end
