//
//  APHDisplayLogHistoryViewController.m
//  BreastCancer
//
//  Created by Justin Warmkessel on 11/21/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHDisplayLogHistoryViewController.h"

@interface APHDisplayLogHistoryViewController ()

- (IBAction)doneButton:(id)sender;
@end

@implementation APHDisplayLogHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTextViewText:(NSString *)text {
    self.textView.text = text;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneButton:(id)sender {
     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
