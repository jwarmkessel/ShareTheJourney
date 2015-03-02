// 
//  APHDisplayLogHistoryViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHDisplayLogHistoryViewController.h"

@interface APHDisplayLogHistoryViewController ()

- (IBAction)doneButton:(id)sender;
@end

@implementation APHDisplayLogHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = self.logText;
    
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterShortStyle];
    [formatter setTimeStyle: NSDateFormatterNoStyle];
    
    self.dateLabel.text = [formatter stringFromDate:self.logDate];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"bozo" style:UIBarButtonItemStylePlain target:self action:@selector(doneButton:)];
    

}

- (void)setTextViewText:(NSString *)text {
    self.textView.text = text;
}

- (IBAction)doneButton:(id) __unused sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
