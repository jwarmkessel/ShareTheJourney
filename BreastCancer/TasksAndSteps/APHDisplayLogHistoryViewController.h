//
//  APHDisplayLogHistoryViewController.h
//  BreastCancer
//
//  Created by Justin Warmkessel on 11/21/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APHDisplayLogHistoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (void)setTextViewText:(NSString *)text;
@end
