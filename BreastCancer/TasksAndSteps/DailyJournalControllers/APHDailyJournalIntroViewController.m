//
//  APHDailyJournalIntroViewController.m
//  BreastCancer
//
//  Created by Henry McGilton on 11/10/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHDailyJournalIntroViewController.h"

@interface APHDailyJournalIntroViewController ()

@property  (nonatomic, weak)  IBOutlet  UIButton  *getStartedButton;

@end

@implementation APHDailyJournalIntroViewController

#pragma  mark  -  Button Action Methods

- (IBAction)getStartedWasTapped:(id)sender
{
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
            [self.delegate stepViewControllerDidFinish:self navigationDirection:RKSTStepViewControllerNavigationDirectionForward];
        }
    }
}

- (void)cancelButtonTapped:(id)sender
{
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
            [self.delegate stepViewControllerDidCancel:self];
        }
    }
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                          target:self
//                                                                                          action:@selector(cancelButtonTapped:)];
    
    [self.getStartedButton setBackgroundColor:[UIColor appPrimaryColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
