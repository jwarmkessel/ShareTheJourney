// 
//  APHQuestionViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHQuestionViewController.h"
#import "APHMoodLogDictionaryKeys.h"


typedef  enum  _TypingDirection
{
    TypingDirectionAdding,
    TypingDirectionDeleting
}  TypingDirection;

static NSUInteger kMaximumNumberOfCharacters = 90;

static  NSString  *kExerciseSurveyStep102 = @"exercisesurvey102";
static  NSString  *kExerciseSurveyStep103 = @"exercisesurvey103";
static  NSString  *kExerciseSurveyStep104 = @"exercisesurvey104";
static  NSString  *kExerciseSurveyStep105 = @"exercisesurvey105";
static  NSString  *kExerciseSurveyStep106 = @"exercisesurvey106";

@interface APHQuestionViewController  ( )  <UITextViewDelegate>



@property  (nonatomic, weak)  IBOutlet  UINavigationBar      *navigator;
@property  (nonatomic, weak)  IBOutlet  UILabel              *counterDisplay;

@property  (nonatomic, weak)  IBOutlet  NSLayoutConstraint   *containerSpacing;
@property  (nonatomic, assign)          CGFloat               savedContainerSpacing;

@property  (nonatomic, strong)          NSMutableDictionary  *noteContentModel;
@property  (nonatomic, strong)          NSMutableArray       *noteModifications;


@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonConstraint;



@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)submitTapped:(id)sender;

@property (nonatomic, strong) RKSTStepResult *cachedResult;

@property (weak, nonatomic) IBOutlet UILabel *characterCounterLabel;
@end

@implementation APHQuestionViewController

#pragma  mark  -  Menu Controller Methods

- (BOOL)canBecomeFirstResponder
{
    return  YES;
}

#pragma  mark  -  Text View Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *updatedText = [self.scriptorium.text stringByReplacingCharactersInRange:range withString:text];
    
    BOOL shouldChangeText = NO;
    
    if (updatedText.length <= 90) {
        shouldChangeText = YES;
    
        self.characterCounterLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)updatedText.length, (unsigned long)kMaximumNumberOfCharacters];
        
        if (updatedText.length > 0) {
            [self.doneButton setEnabled:YES];
            [self.doneButton setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateNormal];
        } else {
            [self.doneButton setEnabled:NO];
            [self.doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    
    return shouldChangeText;
}

- (void)backBarButtonWasTapped:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark  -  Keyboard Notification Methods

- (void)keyboardWillEmerge:(NSNotification *)notification
{
    CGFloat  keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.savedContainerSpacing = self.containerSpacing.constant;
    
    double   animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.containerSpacing.constant = keyboardHeight;
    
    [UIView animateWithDuration:animationDuration animations:^{

        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UINavigation Buttons

- (void)cancelButtonTapped:(id)sender
{
//    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
//        [self.delegate stepViewControllerDidCancel:self];
//    }
}

#pragma  mark  -  View Controller Methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.scriptorium.text.length > 0) {
        [self.doneButton setEnabled:YES];
        [self.doneButton setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateNormal];
    }
    self.characterCounterLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)self.scriptorium.text.length, (unsigned long)kMaximumNumberOfCharacters];
    
    [self.scriptorium becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.scriptorium resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Done button is disabled.
    [self.doneButton setEnabled:NO];
    
    if ([self.step.identifier isEqualToString:kExerciseSurveyStep106]) {
        [self.doneButton setTitle:@"Finish" forState:UIControlStateNormal];
    }
    
    [self.view setBackgroundColor:[UIColor appSecondaryColor4]];
    
    [self.doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    
    self.scriptorium.text = @"";
    self.navigator.topItem.title = @"";
    
    [self.scriptorium setUserInteractionEnabled:YES];
    [self.scriptorium setEditable:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillEmerge:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self.scriptorium becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)submitTapped:(id)sender {
    [self.doneButton setEnabled:NO];
    [self.scriptorium resignFirstResponder];
    
    self.noteContentModel = [NSMutableDictionary new];
    
    [self.noteContentModel setObject:self.scriptorium.text forKey:@"result"];

    RKSTTextQuestionResult *content = [[RKSTTextQuestionResult alloc] initWithIdentifier:self.step.identifier];
    
    content.textAnswer = (NSString *)[self.noteContentModel objectForKey:@"result"];
    
    NSArray *resultsArray = @[content];
    
//    APCDataResult *contentModel = [[APCDataResult alloc] initWithIdentifier:self.step.identifier];
//
//    NSError *error = nil;
//    
//    contentModel.data = [NSJSONSerialization dataWithJSONObject:self.noteContentModel options:0 error:&error];
//    
//    if (error) {
//        APCLogError2(error);
//    }
//    
//    NSArray *resultsArray = @[contentModel];
    
    self.cachedResult = [[RKSTStepResult alloc] initWithStepIdentifier:self.step.identifier results:resultsArray];
    
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


@end
