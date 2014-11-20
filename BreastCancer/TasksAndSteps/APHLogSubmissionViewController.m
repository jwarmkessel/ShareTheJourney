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
@property (nonatomic, strong) RKSTStepResult *cachedResult;
@property (nonatomic, strong) NSMutableDictionary *noteContent;
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
    
    [self.noteContent setObject:self.textView.text forKey:@"content"];
    
    RKSTDataResult *contentModel = [[RKSTDataResult alloc] initWithIdentifier:@"content"];
    
    contentModel.data = [NSKeyedArchiver archivedDataWithRootObject:self.noteContent];
    
    self.cachedResult = [[RKSTStepResult alloc] initWithStepIdentifier:@"DailyJournalStep103" results:@[contentModel]];
    
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
