//
//  APHCustomSurveyQuestionViewController.m
//  Journey
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHCustomSurveyQuestionViewController.h"
#import "APHHeartAgeIntroStepViewController.h"

@interface APHCustomSurveyQuestionViewController () <UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property  (nonatomic, assign)          CGFloat               savedContainerSpacing;
@end

@implementation APHCustomSurveyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.doneButton setBackgroundImage:[UIImage imageWithColor:[UIColor appPrimaryColor]] forState:UIControlStateNormal];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.textView setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillEmerge:) name:UIKeyboardWillShowNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doneButtonHandler:)];
    

}

#pragma  mark  -  Keyboard Notification Methods

- (void)keyboardWillEmerge:(NSNotification *)notification
{
    CGFloat  keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    double   animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomSpaceConstraint.constant = keyboardHeight;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)doneButtonHandler:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.textView resignFirstResponder];
}

@end
