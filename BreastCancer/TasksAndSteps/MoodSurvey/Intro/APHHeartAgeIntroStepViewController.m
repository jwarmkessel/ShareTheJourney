// 
//  APHHeartAgeIntroStepViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHHeartAgeIntroStepViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface APHHeartAgeIntroStepViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;
@property (weak, nonatomic) IBOutlet UITextView *purposeTextView;
@end

@implementation APHHeartAgeIntroStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *viewBackgroundColor = [UIColor appSecondaryColor4];
    
    [self.view setBackgroundColor:viewBackgroundColor];

    [self.getStartedButton setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateNormal];
    
    CALayer *btnLayer = [self.getStartedButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    [btnLayer setBorderColor:[UIColor appPrimaryColor].CGColor];
    [btnLayer setBorderWidth:1.0];
    
}

- (IBAction)getStartedWasTapped:(id)sender
{
    [self.getStartedButton setEnabled:NO];
    if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
        [self.delegate stepViewController:self didFinishWithNavigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

@end
