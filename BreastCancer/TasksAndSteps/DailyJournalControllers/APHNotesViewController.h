//
//  APHNotesViewController.h
//  TestNotesApplication
//
//  Created by Henry McGilton on 10/7/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  APHNotesViewController;
@class  APHLogNoteModel;

@protocol  APHNotesViewControllerDelegate

@required

- (void)notesDidCancel:(APHNotesViewController *)controller;
- (void)controller:(APHNotesViewController *)controller notesDidCompleteWithNote:(NSDictionary *)note;

@end

@interface APHNotesViewController : UIViewController

@property  (nonatomic, weak)  NSDictionary  *note;

@property  (nonatomic, weak)  id <APHNotesViewControllerDelegate>  delegate;

@end
