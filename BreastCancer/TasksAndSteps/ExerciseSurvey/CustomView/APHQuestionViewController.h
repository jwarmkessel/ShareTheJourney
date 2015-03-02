// 
//  APHQuestionViewController.h 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
@import APCAppCore;
#import <UIKit/UIKit.h>
#import "APHCustomTextView.h"
@class  APHNotesViewController;
@class  APHLogNoteModel;

@interface APHQuestionViewController : APCStepViewController

@property  (nonatomic, weak)  NSDictionary  *note;
@property  (nonatomic, weak)  IBOutlet  APHCustomTextView    *scriptorium;

@property (weak, nonatomic) IBOutlet UILabel *previousAnswer;
@property (weak, nonatomic) IBOutlet UILabel *currentQuestion;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
