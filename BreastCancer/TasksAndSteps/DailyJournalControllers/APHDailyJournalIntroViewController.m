// 
//  APHDailyJournalIntroViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHDailyJournalIntroViewController.h"

@interface APHDailyJournalIntroViewController ()

@property  (nonatomic, weak)  IBOutlet  UIButton  *getStartedButton;

@end

@implementation APHDailyJournalIntroViewController

#pragma  mark  -  Button Action Methods

- (IBAction)getStartedWasTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
        [self.delegate stepViewController:self didFinishWithNavigationDirection:ORKStepViewControllerNavigationDirectionForward];
    }
}

- (void)cancelButtonTapped:(id)sender
{
//    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
//        [self.delegate stepViewControllerDidCancel:self];
//    }
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
