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
    // Do any additional setup after loading the view from its nib.
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

@end
