// 
//  APHDisplayLogHistoryViewController.h 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import <UIKit/UIKit.h>

@interface APHDisplayLogHistoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSString *logText;
@property (nonatomic, strong) NSDate *logDate;

- (void)setTextViewText:(NSString *)text;
@end
