// 
//  APHExerciseMotivationIntroViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHExerciseMotivationIntroViewController.h"

@interface APHExerciseMotivationIntroViewController ()
- (IBAction)nextButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *exerciseEveryDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseThreeTimesAWeekLabel;

@property (weak, nonatomic) IBOutlet UILabel *walkTenThousandStepsLabel;

@property (weak, nonatomic) IBOutlet UILabel *fiveThousandStepsLabel;

@property (weak, nonatomic) IBOutlet APCConfirmationView *exerciseEveryDaySelectedView;
@property (weak, nonatomic) IBOutlet APCConfirmationView *exerciseThreeTimesAWeekSelectedView;
@property (weak, nonatomic) IBOutlet APCConfirmationView *fiveThousandStepsSelectedView;

@property (weak, nonatomic) IBOutlet APCConfirmationView *walkTenThousandStepsSelectedView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) RKSTStepResult *cachedResult;
@property (nonatomic, strong) NSString *selectedGoal;
@end

@implementation APHExerciseMotivationIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor appSecondaryColor4]];
    
    [self.nextButton setEnabled:NO];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    
    NSArray *buttons = @[self.exerciseEveryDayLabel,
                         self.exerciseThreeTimesAWeekLabel,
                         self.fiveThousandStepsLabel,
                         self.walkTenThousandStepsLabel
                         ];
    
    NSArray *selectedViews = @[self.exerciseEveryDaySelectedView,
                               self.exerciseThreeTimesAWeekSelectedView,
                               self.fiveThousandStepsSelectedView,
                               self.walkTenThousandStepsSelectedView
                               ];
    
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
    [self.nextButton setEnabled:YES];
    [self.nextButton setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateNormal];
    
    NSInteger selectedViewTag = gesture.view.tag;
    UILabel *selectedLabel = (UILabel *) [self.view viewWithTag:selectedViewTag];
    self.selectedGoal = selectedLabel.text;
    NSLog(@"%@", selectedLabel.text);
    
    NSArray *selectedViews = @[self.exerciseEveryDaySelectedView, self.exerciseThreeTimesAWeekSelectedView, self.fiveThousandStepsSelectedView, self.walkTenThousandStepsSelectedView];
    
    for (APCConfirmationView *view in selectedViews) {
        [view setCompleted:NO];
    }
    
    APCConfirmationView *selectedView;
    selectedView.alpha = 0.3;
    
    switch (selectedViewTag)
    
    {
        case 1:
            
            selectedView = self.exerciseEveryDaySelectedView;
            [selectedView setAlpha:0];
            break;
            
        case 2:
            
            selectedView = self.exerciseThreeTimesAWeekSelectedView;
            [selectedView setAlpha:0];
            
            break;

        case 3:
            
            selectedView = self.fiveThousandStepsSelectedView;
            [selectedView setAlpha:0];
            
            break;
            
        case 4:
            
            selectedView = self.walkTenThousandStepsSelectedView;
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
    [self.nextButton setEnabled:NO];
    self.dict = [NSMutableDictionary new];
    [self.dict setObject:self.selectedGoal forKey:@"result"];

    RKSTDataResult *contentModel = [[RKSTDataResult alloc] initWithIdentifier:self.step.identifier];

    NSError *error = nil;
    NSData  *exerciseMotivationAnswers = [NSJSONSerialization dataWithJSONObject:self.dict options:0 error:&error];

    contentModel.data = exerciseMotivationAnswers;

    NSArray *resultsArray = @[contentModel];

    self.cachedResult = [[RKSTStepResult alloc] initWithStepIdentifier:self.step.identifier results:resultsArray];

    [self.delegate stepViewController:self didChangeResult:self.cachedResult];
    
    
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidFinish:navigationDirection:)] == YES) {
        [self.delegate stepViewControllerDidFinish:self navigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

- (RKSTStepResult *)result {
    
    return self.cachedResult;
}
@end
