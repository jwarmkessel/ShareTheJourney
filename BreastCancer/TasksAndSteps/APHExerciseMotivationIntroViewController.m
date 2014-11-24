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

@property (weak, nonatomic) IBOutlet UILabel *walkingLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;

@property (weak, nonatomic) IBOutlet APCConfirmationView *walkingSelectedView;
@property (weak, nonatomic) IBOutlet APCConfirmationView *exerciseSelectedView;
@property (weak, nonatomic) IBOutlet APCConfirmationView *stepsSelectedView;



@property (nonatomic, strong) NSString *selectedGoal;
@end

@implementation APHExerciseMotivationIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor appSecondaryColor4]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    
    NSArray *buttons = @[self.walkingLabel, self.exerciseLabel, self.stepsLabel];
    NSArray *selectedViews = @[self.walkingSelectedView, self.exerciseSelectedView, self.stepsSelectedView];
    
    for (int i = 0; i<[buttons count]; i++) {
        UILabel *label = (UILabel *) buttons[i];
        APCConfirmationView *selectedView = (APCConfirmationView *)selectedViews[i];
        
        label.tag = i + 1;
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
        singleTap.numberOfTapsRequired = 1;
        [label addGestureRecognizer:singleTap];
        
        [label setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *singleTapSelected = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
        singleTapSelected.numberOfTapsRequired = 1;
        [selectedView addGestureRecognizer:singleTapSelected];
        [selectedView setUserInteractionEnabled:YES];
        
        selectedView.tag = i + 1;
    }
}

- (void)oneTap:(UIGestureRecognizer *)gesture {
    NSInteger selectedViewTag = gesture.view.tag;
    UILabel *selectedLabel = (UILabel *) [self.view viewWithTag:selectedViewTag];
    self.selectedGoal = selectedLabel.text;
    NSLog(@"%@", selectedLabel.text);
    
    NSArray *selectedViews = @[self.walkingSelectedView, self.exerciseSelectedView, self.stepsSelectedView];
    
    for (APCConfirmationView *view in selectedViews) {
        [view setCompleted:NO];
    }
    
    APCConfirmationView *selectedView;
    selectedView.alpha = 0.3;
    
    switch (selectedViewTag)
    
    {
        case 1:
            
            selectedView = self.walkingSelectedView;
            [selectedView setAlpha:0];
            break;
            
        case 2:
            
            selectedView = self.exerciseSelectedView;
            [selectedView setAlpha:0];
            
            break;

        case 3:
            
            selectedView = self.stepsSelectedView;
            [selectedView setAlpha:0];
            
            break;
            

        default:
            
            break;
    }
    
    [selectedView setCompleted:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [selectedView setAlpha:1];
    }];
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
