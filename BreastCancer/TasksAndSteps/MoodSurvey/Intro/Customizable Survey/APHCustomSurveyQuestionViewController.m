//
//  APHCustomSurveyQuestionViewController.m
//  Journey
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHCustomSurveyQuestionViewController.h"
#import "APHHeartAgeIntroStepViewController.h"

static NSInteger const doneButtonYOffset = 20;
static NSInteger const kMaximumNumberOfCharacters = 90;

@interface APHCustomSurveyQuestionViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *characterCounterLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property  (nonatomic, assign) CGFloat savedContainerSpacing;
@end

@implementation APHCustomSurveyQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = NSLocalizedString(@"Custom Daily Scale", @"");
    
    [self.textView setDelegate:self];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillEmerge:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL) __unused animated {
    APCAppDelegate * delegate = (APCAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *customQuestion = delegate.dataSubstrate.currentUser.customSurveyQuestion;
    
    if (customQuestion != nil) {
        self.textView.text = customQuestion;
        self.characterCounterLabel.text = [NSString     stringWithFormat:@"%lu / %lu", (unsigned long)self.textView.text.length, (unsigned long)kMaximumNumberOfCharacters];
    }
        
}
#pragma  mark  -  TextView Delegate Methods   

#pragma  mark  -  Text View Delegate Methods

- (BOOL)textView:(UITextView *) __unused textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *updatedText = [self.textView.text stringByReplacingCharactersInRange:range withString:text];
    
    BOOL shouldChangeText = NO;
    
    if (updatedText.length <= kMaximumNumberOfCharacters) {
        shouldChangeText = YES;
        
        self.characterCounterLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)updatedText.length, (unsigned long)kMaximumNumberOfCharacters];
    }
    
    return shouldChangeText;
}

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
    
    self.bottomSpaceConstraint.constant = keyboardHeight - doneButtonYOffset;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)doneButtonHandler:(id) __unused sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillDisappear:(BOOL) __unused animated {
    [self.textView resignFirstResponder];
}

@end
