// 
//  APHDisplayLogHistoryViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHDisplayLogHistoryViewController.h"

@interface APHDisplayLogHistoryViewController ()

@property (weak) UIViewController *previousViewController;
@property (weak) NSString *previousViewControllerTitle;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUInteger previousIndex = ([self.navigationController.viewControllers indexOfObject:self] - 1);
    self.previousViewController = ((UIViewController *)self.navigationController.viewControllers[previousIndex]);
    self.previousViewControllerTitle = self.previousViewController.navigationItem.title;
    self.previousViewController.title = NSLocalizedString(@"Back", @"Text for back bar button item on daily journel entry");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.previousViewController.title = self.previousViewControllerTitle;
}

- (void)setTextViewText:(NSString *)text {
    self.textView.text = text;
}

- (IBAction)doneButton:(id) __unused sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
