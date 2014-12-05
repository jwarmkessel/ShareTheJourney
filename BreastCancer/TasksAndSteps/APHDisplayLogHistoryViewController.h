// 
//  APHDisplayLogHistoryViewController.h 
//  Share the Journey 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
// 
 
#import <UIKit/UIKit.h>

@interface APHDisplayLogHistoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (void)setTextViewText:(NSString *)text;
@end
