//
//  APHNotesViewController.m
//  TestNotesApplication
//
//  Created by Henry McGilton on 10/7/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHNotesViewController.h"
#import "APHCustomTextView.h"
#import "APHMoodLogDictionaryKeys.h"

typedef  enum  _TypingDirection
{
    TypingDirectionAdding,
    TypingDirectionDeleting
}  TypingDirection;

static  NSCharacterSet  *whitespaceAndNewLineSet = nil;

@interface APHNotesViewController  ( )  <UITextViewDelegate>

@property  (nonatomic, weak)  IBOutlet  APHCustomTextView    *scriptorium;

@property  (nonatomic, weak)  IBOutlet  UIToolbar            *toolshed;
@property  (nonatomic, weak)            UIBarButtonItem      *counterDisplay;

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
    return  NO;
}

- (void)displayWordCount:(NSUInteger)count
{
    NSString  *numberOfWordsDisplay = [NSString stringWithFormat:@"%d", count];
    self.counterDisplay.title = numberOfWordsDisplay;
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
    
    if ([text length] != 0) {
        record = @{
                   APHMoodLogEditTimeStampKey : @(timestamp),
                   APHMoodLogEditingTypeKey : APHMoodLogEditingTypeAddingKey,
                   };
    } else {
        record = @{
                   APHMoodLogEditTimeStampKey : @(timestamp),
                   APHMoodLogEditingTypeKey : APHMoodLogEditingTypeDeletingKey,
                   };
    }
    [self.noteModifications addObject: record];
    
    NSUInteger  count = [self countWords:self.scriptorium.text];
    [self displayWordCount:count];
    
    return  answer;
}

#pragma  mark  -  Bar Button Methods

- (void)cancelButtonTapped:(UIBarButtonItem *)sender
{
    if (self.delegate != nil) {
        [self.delegate notesDidCancel:self];
    }
}

- (void)doneButtonTapped:(UIBarButtonItem *)sender
{
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

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scriptorium.text = @"";
    self.navigationItem.title  = @"0";
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO];
    
    UIBarButtonItem  *spacerleft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem  *titler     = [[UIBarButtonItem alloc] initWithTitle:@"0000" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.counterDisplay = titler;
    UIBarButtonItem  *spacerright = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (self.note == nil) {
        UIBarButtonItem  *cancellor = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
        UIBarButtonItem  *finisher = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
        
        self.toolshed.items = @[ cancellor, spacerleft, titler, spacerright, finisher ];
        
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
        
        UIBarButtonItem  *backster = [[UIBarButtonItem alloc] initWithTitle:@"\u27e8 Notes" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonWasTapped:)];
        
        self.toolshed.items = @[ backster, spacerleft, titler, spacerright, spacerright ];

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
