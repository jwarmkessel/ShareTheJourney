// 
//  APHLogSubmissionViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
@import APCAppCore;

#import "APHLogSubmissionViewController.h"

@interface APHLogSubmissionViewController ()
- (IBAction)submitButtonTapped:(id)sender;
@property (nonatomic, strong) RKSTStepResult *cachedResult;
@property (nonatomic, strong) NSMutableDictionary *noteContent;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation APHLogSubmissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.editable = NO;
    self.noteContent = [NSMutableDictionary dictionary];
    
    [self.submitButton setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateNormal];
}

- (IBAction)submitButtonTapped:(id)sender {
    
    [self.submitButton setEnabled:NO];
    
    [self.noteContent setObject:self.textView.text forKey:@"content"];
    
    APCDataResult *contentModel = [[APCDataResult alloc] initWithIdentifier:self.step.identifier];
    
    NSError *error = nil;
    contentModel.data = [NSJSONSerialization dataWithJSONObject:self.noteContent options:0 error:&error];
    
    self.cachedResult = [[RKSTStepResult alloc] initWithStepIdentifier:self.step.identifier results:@[contentModel]];
    
    [self.delegate stepViewControllerResultDidChange:self];
    
    if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
        [self.delegate stepViewController:self didFinishWithNavigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

- (RKSTStepResult *)result {
    
    if (!self.cachedResult) {
        self.cachedResult = [[RKSTStepResult alloc] initWithIdentifier:self.step.identifier];
    }
    
    return self.cachedResult;
}


#pragma mark - UINavigation Buttons

//- (void)cancelButtonTapped:(id)sender
//{
////    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
////        [self.delegate stepViewControllerDidCancel:self];
////    }
//}

@end
