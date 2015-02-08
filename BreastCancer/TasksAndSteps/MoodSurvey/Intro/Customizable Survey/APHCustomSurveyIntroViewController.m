//
//  APHCustomSurveyIntroViewController.m
//  Journey
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHCustomSurveyIntroViewController.h"

@interface APHCustomSurveyIntroViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@end

@implementation APHCustomSurveyIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView setScrollEnabled:NO];
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (IBAction)continueButtonHandler:(id)sender {
    if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
        [self.delegate stepViewController:self didFinishWithNavigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

/*********************************************************************************/
#pragma  mark  - tableView delegates
/*********************************************************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = nil;
    
    if (indexPath.row == 0) {
        
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = NSLocalizedString(@"You now have the ability to create your own survey question. Tap continue to enter your question", @"");
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
    } else if (indexPath.row == 1) {
        cell = [[UITableViewCell alloc] init];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
        NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc]initWithString:@"Learn More"];
        [attribString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [@"Learn More" length])];
        
        [attribString addAttribute:NSForegroundColorAttributeName value:[UIColor appPrimaryColor] range:NSMakeRange(0,[attribString length])];

        cell.textLabel.attributedText = attribString;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.contentView setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
/*********************************************************************************/
#pragma  mark  - Helper methods
/*********************************************************************************/



@end
