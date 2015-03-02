//
//  APHProfileExtender.m
//  Journey
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHProfileExtender.h"
#import "APHCustomSurveyQuestionViewController.h"

static NSInteger const kNumberOfCompletionsUntilDisplayingCustomSurvey = 6;

@implementation APHProfileExtender

- (instancetype) init {
    self = [super init];

    if (self) {
        
        
    }
    
    return self;
}

- (BOOL)willDisplayCell:(NSIndexPath *) __unused indexPath {
    return YES;
}

//This is all the content (rows, sections) that is prepared at the appCore level
/*
- (NSArray *)preparedContent:(NSArray *)array {
    return array;
}
*/

//Add to the number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *) __unused tableView {
    
    //Check if we have reached the threshold to display customizing a survey question.
    APCAppDelegate * delegate = (APCAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSNumber *completedNumberOfTimes = @(0);
    
    if (delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter >= kNumberOfCompletionsUntilDisplayingCustomSurvey && delegate.dataSubstrate.currentUser.customSurveyQuestion != nil)
    {
        completedNumberOfTimes = @(2);
    }
    else if (delegate.dataSubstrate.currentUser.dailyScalesCompletionCounter > kNumberOfCompletionsUntilDisplayingCustomSurvey)
    {
        completedNumberOfTimes = @(2);
    }
    
    return [completedNumberOfTimes integerValue];
}

//Add to the number of sections
- (NSInteger) tableView:(UITableView *) __unused tableView numberOfRowsInAdjustedSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (section == 0) {
        count = 1;
    }
    
    return count;
}

- (UITableViewCell *)cellForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Customize your survey question";
        
    }
    


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = tableView.rowHeight;
    
    if (indexPath.section == 0) {
        height = 60.0;
    }
    
    return height;
}

- (void)navigationController:(UINavigationController *)navigationController didSelectRowAtIndexPath:(NSIndexPath *) __unused indexPath {
    
    APHCustomSurveyQuestionViewController *controller = [[APHCustomSurveyQuestionViewController alloc] init];
    
    controller.navigationController.navigationBar.topItem.title = @"Customize your survey question";
    
    [navigationController pushViewController:controller animated:YES];
}

@end
