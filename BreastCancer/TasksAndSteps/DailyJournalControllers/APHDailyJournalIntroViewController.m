// 
//  APHDailyJournalIntroViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
// 
 
#import "APHDailyJournalIntroViewController.h"

@interface APHDailyJournalIntroViewController ()

@property  (nonatomic, weak)  IBOutlet  UIButton  *getStartedButton;

@end

@implementation APHDailyJournalIntroViewController

#pragma  mark  -  Button Action Methods

- (IBAction)getStartedWasTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
        [self.delegate stepViewControllerDidFinish:self navigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

- (void)cancelButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
        [self.delegate stepViewControllerDidCancel:self];
    }
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.getStartedButton setBackgroundColor:[UIColor appPrimaryColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
