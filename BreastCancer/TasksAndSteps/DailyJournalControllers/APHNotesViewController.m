//
//  APHNotesViewController.m
//  Breast Cancer
//
//  Created by Henry McGilton on 10/7/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHNotesViewController.h"
#import "APHCustomTextView.h"
#import "APHMoodLogDictionaryKeys.h"

@import APCAppleCore;

typedef  enum  _TypingDirection
{
    TypingDirectionAdding,
    TypingDirectionDeleting
}  TypingDirection;

static  NSCharacterSet  *whitespaceAndNewLineSet = nil;

static  NSUInteger  kMaximumNumberOfWordsPerLog = 150;
static  NSUInteger  kThresholdForLimitWarning   = 140;

@interface APHNotesViewController  ( )  <UITextViewDelegate>

@property  (nonatomic, weak)  IBOutlet  APHCustomTextView    *scriptorium;

@property  (nonatomic, weak)  IBOutlet  UINavigationBar      *navigator;
@property  (nonatomic, weak)  IBOutlet  UILabel              *counterDisplay;

@property  (nonatomic, weak)  IBOutlet  NSLayoutConstraint   *containerSpacing;
@property  (nonatomic, assign)          CGFloat               savedContainerSpacing;

@property  (nonatomic, strong)          NSMutableDictionary  *noteContentModel;
@property  (nonatomic, strong)          NSMutableDictionary  *noteChangesModel;
@property  (nonatomic, strong)          NSMutableArray       *noteModifications;

@end

@implementation APHNotesViewController

+ (void)initialize
{
    whitespaceAndNewLineSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
}

#pragma  mark  -  Menu Controller Methods

- (BOOL)canBecomeFirstResponder
{
    return  YES;
}

- (void)displayWordCount:(NSUInteger)count
{
    NSString  *numberOfWordsDisplay = [NSString stringWithFormat:@"%lu of %lu words", (unsigned long)count, kMaximumNumberOfWordsPerLog];
    if (count < kThresholdForLimitWarning) {
        self.counterDisplay.textColor = [UIColor grayColor];
    } else {
        self.counterDisplay.textColor = [UIColor redColor];
    }
    self.counterDisplay.text = numberOfWordsDisplay;
}

- (NSUInteger)countWords:(NSString *)words
{
    typedef  enum  _WordState
    {
        WordStateInWord,
        WordStateNotInWord
    }  WordState;
    
    WordState  state = WordStateNotInWord;
    
    NSString  *text = self.scriptorium.text;
    NSUInteger  length = [text length];
    
    NSUInteger  count = 0;
    
    for (NSUInteger  i = 0; i < length;  i++) {
        unichar  character = [text characterAtIndex:i];
        if (state == WordStateNotInWord) {
            if ([whitespaceAndNewLineSet characterIsMember:character] == YES) {
                continue;
            } else {
                state = WordStateInWord;
                count = count + 1;
            }
        } else {
            if ([whitespaceAndNewLineSet characterIsMember:character] == NO) {
                continue;
            } else {
                state = WordStateNotInWord;
            }
        }
    }
    return  count;
}

#pragma  mark  -  Text View Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL  answer = YES;
    
    NSDictionary  *record = nil;
    
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
    
    NSUInteger  preCount = [self countWords:self.scriptorium.text];
    if ([text length] != 0) {
        if (preCount >= kMaximumNumberOfWordsPerLog) {
            answer = NO;
        } else {
            record = @{
                       APHMoodLogEditTimeStampKey : @(timestamp),
                       APHMoodLogEditingTypeKey : APHMoodLogEditingTypeAddingKey,
                       };
        }
    } else {
        record = @{
                   APHMoodLogEditTimeStampKey : @(timestamp),
                   APHMoodLogEditingTypeKey : APHMoodLogEditingTypeDeletingKey,
                   };
    }
    if (record != nil) {
        [self.noteModifications addObject: record];
    }
    
    NSUInteger  count = [self countWords:self.scriptorium.text];
    [self displayWordCount:count];
    
    return  answer;
}

#pragma  mark  -  Bar Button Methods

- (void)cancelButtonTapped:(UIBarButtonItem *)sender
{
    [self.scriptorium resignFirstResponder];
    if (self.delegate != nil) {
        [self.delegate notesDidCancel:self];
    }
}

- (void)doneButtonTapped:(UIBarButtonItem *)sender
{
    [self.scriptorium resignFirstResponder];
    
    [self.noteContentModel setObject:self.scriptorium.text forKey:APHMoodLogNoteTextKey];
    
    [self.noteChangesModel setObject:self.noteModifications forKey:APHMoodLogNoteModificationsKey];
    
    if (self.delegate != nil) {
        [self.delegate controller:self notesDidCompleteWithNote:self.noteContentModel andChanges:self.noteChangesModel];
    }
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
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.containerSpacing.constant = keyboardHeight;
    }];
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scriptorium.text = @"";
    self.navigator.topItem.title = @"";
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO];
    
    if (self.note == nil) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillEmerge:) name:UIKeyboardWillShowNotification object:nil];
        
        UIBarButtonItem  *cancellor = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped:)];
        cancellor.tintColor = [UIColor appPrimaryColor];
        self.navigator.topItem.leftBarButtonItem = cancellor;
        
        UIBarButtonItem  *finisher = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain  target:self action:@selector(doneButtonTapped:)];
        finisher.tintColor = [UIColor appPrimaryColor];
        self.navigator.topItem.rightBarButtonItem = finisher;
        
        NSTimeInterval  timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
        
        self.noteContentModel = [NSMutableDictionary dictionary];
        [self.noteContentModel setObject:@(timestamp) forKey:APHMoodLogNoteTimeStampKey];
        
        self.noteChangesModel = [NSMutableDictionary dictionary];
        [self.noteChangesModel setObject:@(timestamp) forKey:APHMoodLogNoteTimeStampKey];
        
        self.noteModifications = [NSMutableArray array];
        
        [self displayWordCount:0];
        [self.scriptorium becomeFirstResponder];
    } else {
        self.scriptorium.editable   = NO;
        self.scriptorium.selectable = NO;
        
        UIBarButtonItem  *backsterTitle   = [[UIBarButtonItem alloc] initWithTitle:@"Back to List" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonWasTapped:)];
        backsterTitle.tintColor = [UIColor appPrimaryColor];
        
        self.navigator.topItem.leftItemsSupplementBackButton = NO;
        self.navigator.topItem.leftBarButtonItem = backsterTitle;

        self.scriptorium.text = self.note[APHMoodLogNoteTextKey];
        NSUInteger  count = [self countWords:self.scriptorium.text];
        [self displayWordCount:count];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
