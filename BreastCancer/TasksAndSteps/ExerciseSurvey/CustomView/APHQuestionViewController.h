//
//  APHQuestionViewController.h
//  Breast Cancer
//
//  Created by Justin Warmkessel on 11/23/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

@import APCAppleCore;
#import <UIKit/UIKit.h>
#import "APHCustomTextView.h"
@class  APHNotesViewController;
@class  APHLogNoteModel;

@interface APHQuestionViewController : APCStepViewController

@property  (nonatomic, weak)  NSDictionary  *note;
@property  (nonatomic, weak)  IBOutlet  APHCustomTextView    *scriptorium;
@end
