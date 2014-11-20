//
//  APHLogSubmissionViewController.m
//  BreastCancer
//
//  Created by Justin Warmkessel on 11/18/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

@import APCAppleCore;

#import "APHLogSubmissionViewController.h"

@interface APHLogSubmissionViewController ()
- (IBAction)submitButtonTapped:(id)sender;

@end

@implementation APHLogSubmissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonTapped:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
        [self.delegate stepViewControllerDidFinish:self navigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

#pragma mark - UINavigation Buttons

- (void)cancelButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
        [self.delegate stepViewControllerDidCancel:self];
    }
}

@end
