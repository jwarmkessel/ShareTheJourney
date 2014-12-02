//
//  APHQuestionViewController.m
//  Breast Cancer
//
//  Created by Justin Warmkessel on 11/23/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
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
@property  (nonatomic, strong)          NSMutableDictionary  *noteChangesModel;
@property  (nonatomic, strong)          NSMutableArray       *noteModifications;


@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonConstraint;



@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)submitTapped:(id)sender;

@property (nonatomic, strong) RKSTStepResult *cachedResult;

@property (weak, nonatomic) IBOutlet UILabel *characterCounterLabel;
@property (assign) NSUInteger charCounter;
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
    BOOL enableButtonFlag = YES;
    BOOL returnValue = YES;
    
    //This is basically counting characters but also keeping track of delete strings.
    if ([text isEqualToString:@""]) {
        if (self.charCounter > 0) {
            self.charCounter--;
            self.characterCounterLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)self.charCounter, kMaximumNumberOfCharacters];
            
            if (self.charCounter == 0) {
                enableButtonFlag = NO;
            }
        }
        
    } else if ([text isEqualToString:@" "] || ![text isEqualToString:@""]) {
        if (self.charCounter + 1 <= kMaximumNumberOfCharacters){
            self.charCounter++;
            self.characterCounterLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)self.charCounter, kMaximumNumberOfCharacters];
        } else {
            returnValue = NO;
            goto goToReturn;
        }
    }
    
    [self.doneButton setEnabled:enableButtonFlag];
    [self.doneButton setTitleColor:[UIColor appPrimaryColor] forState:UIControlStateNormal];
    
goToReturn:
    return returnValue;
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
    if ([self.delegate respondsToSelector:@selector(stepViewControllerDidCancel:)] == YES) {
        [self.delegate stepViewControllerDidCancel:self];
    }
}

#pragma  mark  -  View Controller Methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.characterCounterLabel.text = [NSString stringWithFormat:@"%lu / %lu", self.scriptorium.text.length, kMaximumNumberOfCharacters];
    
    [self.scriptorium becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.scriptorium resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.charCounter = 0;
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

    [self.scriptorium resignFirstResponder];
    
    self.noteContentModel = [NSMutableDictionary new];
    
    [self.noteContentModel setObject:self.scriptorium.text forKey:@"result"];
    [self.noteChangesModel setObject:self.noteModifications forKey:APHMoodLogNoteModificationsKey];
    
    RKSTDataResult *contentModel = [[RKSTDataResult alloc] initWithIdentifier:@"result"];
    RKSTDataResult *changesModel = [[RKSTDataResult alloc] initWithIdentifier:@"changes"];
        
    contentModel.data = [NSKeyedArchiver archivedDataWithRootObject:self.noteContentModel];
    changesModel.data = [NSKeyedArchiver archivedDataWithRootObject:self.noteChangesModel];
    
    NSArray *resultsArray = @[contentModel, changesModel];
    
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
