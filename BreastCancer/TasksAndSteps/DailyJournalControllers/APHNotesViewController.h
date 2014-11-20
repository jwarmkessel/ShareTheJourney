//
//  APHNotesViewController.h
//  Breast Cancer
//
//  Created by Henry McGilton on 10/7/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@import APCAppleCore;
@class  APHNotesViewController;
@class  APHLogNoteModel;

@interface APHNotesViewController : APCStepViewController

@property  (nonatomic, weak)  NSDictionary  *note;

@end
