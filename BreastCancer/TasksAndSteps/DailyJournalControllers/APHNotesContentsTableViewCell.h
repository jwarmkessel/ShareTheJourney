//
//  APHNotesContentsTableViewCell.h
//  TestNotesApplication
//
//  Created by Henry McGilton on 10/8/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APHNotesContentsTableViewCell : UITableViewCell

@property  (nonatomic, weak)  IBOutlet  UILabel  *noteName;
@property  (nonatomic, weak)  IBOutlet  UILabel  *noteDate;

@end
