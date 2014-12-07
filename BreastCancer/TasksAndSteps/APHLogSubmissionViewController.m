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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonTapped:(id)sender {
    
    [self.submitButton setEnabled:NO];
    
    [self.noteContent setObject:self.textView.text forKey:@"content"];
    
    RKSTDataResult *contentModel = [[RKSTDataResult alloc] initWithIdentifier:self.step.identifier];
    
    NSError *error = nil;
    contentModel.data = [NSJSONSerialization dataWithJSONObject:self.noteContent options:0 error:&error];
    
    self.cachedResult = [[RKSTStepResult alloc] initWithStepIdentifier:self.step.identifier results:@[contentModel]];
    
    [self.delegate stepViewController:self didChangeResult:self.cachedResult];
    
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
        [self.delegate stepViewControllerDidFinish:self navigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

- (RKSTStepResult *)result {
    
    return self.cachedResult;
}


#pragma mark - UINavigation Buttons

- (void)cancelButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
        [self.delegate stepViewControllerDidCancel:self];
    }
}

@end
