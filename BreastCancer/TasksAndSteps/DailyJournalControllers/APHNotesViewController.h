//
//  APHNotesViewController.h
//  Breast Cancer
//
//  Created by Henry McGilton on 10/7/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  APHNotesViewController;
@class  APHLogNoteModel;

@protocol  APHNotesViewControllerDelegate

@required

- (void)notesDidCancel:(APHNotesViewController *)controller;
- (void)controller:(APHNotesViewController *)controller notesDidCompleteWithNote:(NSDictionary *)note  andChanges:(NSDictionary *)changes;

@end

@interface APHNotesViewController : UIViewController

@property  (nonatomic, weak)  NSDictionary  *note;

@property  (nonatomic, weak)  id <APHNotesViewControllerDelegate>  delegate;

@end
