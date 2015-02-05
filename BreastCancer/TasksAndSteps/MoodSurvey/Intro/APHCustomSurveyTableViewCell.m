//
//  APHCustomSurveyTableViewCell.m
//  Journey
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHCustomSurveyTableViewCell.h"
#import "APHQuestionViewController.h"

@implementation APHCustomSurveyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)customizeSurveyHandler:(id)sender {
    APHQuestionViewController *questionController = [[APHQuestionViewController alloc] initWithNibName:@"APHQuestionViewController" bundle:nil];
    
    
}

@end
