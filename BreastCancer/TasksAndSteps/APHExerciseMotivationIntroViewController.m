//
//  APHExerciseMotivationIntroViewController.m
//  BreastCancer
//
//  Created by Justin Warmkessel on 11/24/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHExerciseMotivationIntroViewController.h"

@interface APHExerciseMotivationIntroViewController ()
- (IBAction)nextButtonTapped:(id)sender;

@end

@implementation APHExerciseMotivationIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor appSecondaryColor4]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UINavigation Buttons

- (void)cancelButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
        [self.delegate stepViewControllerDidCancel:self];
    }
}

- (IBAction)nextButtonTapped:(id)sender {
//    [self.scriptorium resignFirstResponder];
//    
//    [self.noteContentModel setObject:self.scriptorium.text forKey:APHMoodLogNoteTextKey];
//    
//    [self.noteChangesModel setObject:self.noteModifications forKey:APHMoodLogNoteModificationsKey];
//    
//    
//    RKSTDataResult *contentModel = [[RKSTDataResult alloc] initWithIdentifier:@"content"];
//    RKSTDataResult *changesModel = [[RKSTDataResult alloc] initWithIdentifier:@"changes"];
//    
//    contentModel.data = [NSKeyedArchiver archivedDataWithRootObject:self.noteContentModel];
//    changesModel.data = [NSKeyedArchiver archivedDataWithRootObject:self.noteChangesModel];
//    
//    NSArray *resultsArray = @[contentModel, changesModel];
//    
//    self.cachedResult = [[RKSTStepResult alloc] initWithStepIdentifier:@"DailyJournalStep102" results:resultsArray];
//    
//    [self.delegate stepViewController:self didChangeResult:self.cachedResult];
    
    
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
        [self.delegate stepViewControllerDidFinish:self navigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}
@end
