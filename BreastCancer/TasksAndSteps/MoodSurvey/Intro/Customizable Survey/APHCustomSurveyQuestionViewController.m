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
@property  (nonatomic, assign) CGFloat savedContainerSpacing;
@end

@implementation APHCustomSurveyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Customize survey question";
    self.navigationController.navigationBar.topItem.title = @"Customize survey question";
    
    [self.textView setDelegate:self];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillEmerge:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    APCAppDelegate * delegate = (APCAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *customQuestion = delegate.dataSubstrate.currentUser.customSurveyQuestion;
    
    if (customQuestion != nil) {
        self.textView.text = customQuestion;
    }
        
}
#pragma  mark  -  TextView Delegate Methods   
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    APCAppDelegate * delegate = (APCAppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.dataSubstrate.currentUser.customSurveyQuestion = textView.text;
    
    if ([textView.text isEqualToString:@""]) {
        delegate.dataSubstrate.currentUser.customSurveyQuestion = nil;
    }
    
}

#pragma  mark  -  Keyboard Notification Methods

- (void)keyboardWillEmerge:(NSNotification *)notification
{
    CGFloat  keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    double   animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomSpaceConstraint.constant = keyboardHeight + 20;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)doneButtonHandler:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.textView resignFirstResponder];
}

@end
