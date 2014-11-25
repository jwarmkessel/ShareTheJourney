//
//  APHExerciseMotivationSummaryViewController.m
//  BreastCancer
//
//  Created by Justin Warmkessel on 11/24/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHExerciseMotivationSummaryViewController.h"

@interface APHExerciseMotivationSummaryViewController ()


@end

@implementation APHExerciseMotivationSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor appSecondaryColor4]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
        [self.delegate stepViewControllerDidFinish:self navigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}


@end
