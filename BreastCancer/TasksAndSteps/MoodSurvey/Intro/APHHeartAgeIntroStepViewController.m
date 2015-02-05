// 
//  APHHeartAgeIntroStepViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHHeartAgeIntroStepViewController.h"
#import "APHCustomSurveyTableViewCell.h"
#import "APHQuestionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface APHHeartAgeIntroStepViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSAttributedString *purpose;
@property (nonatomic, strong) NSAttributedString *length;
@property (nonatomic, strong) UITableViewCell *purposeCell;
@end

@implementation APHHeartAgeIntroStepViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView.allowsSelection = NO;
    
    [self createAttributedStrings];

    UINib *nib = [UINib nibWithNibName:@"Cell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"APHCustomSurveyTableViewCell"
                                               bundle:[NSBundle mainBundle]]
                               forCellReuseIdentifier:@"APHCustomSurveyTableViewCellIdentifier"];
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

- (IBAction)getStartedWasTapped:(id)sender
{
    [self.getStartedButton setEnabled:NO];
    if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
        [self.delegate stepViewController:self didFinishWithNavigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

/*********************************************************************************/
#pragma  mark  - tableView delegates
/*********************************************************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    float height = 0;
    
    if (indexPath.row == 0) {
        
        height = 220.0;
        
    } else if (indexPath.row == 1) {
        
        height = 100.0;
        
    } else if (indexPath.row == 2) {

        height = 300.0;
    }

    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = nil;
    
    if (indexPath.row == 0) {
        
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.attributedText = self.purpose;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

    } else if (indexPath.row == 1) {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.attributedText = self.length;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
    } else if (indexPath.row == 2) {

        cell = [tableView dequeueReusableCellWithIdentifier:@"APHCustomSurveyTableViewCellIdentifier"];

        
        APHCustomSurveyTableViewCell *customCell = (APHCustomSurveyTableViewCell *) cell;
        [customCell.customizeSurveyButton addTarget:self action:@selector(blah) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
- (void) blah{
    
//    APHQuestionViewController *questionController = [[APHQuestionViewController alloc] initWithNibName:@"APHQuestionViewController" bundle:nil];

    UIViewController *questionController = [[UIViewController alloc] init];
    [self presentViewController:questionController animated:YES completion:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //  Workaround
    [self.tableView reloadData];
}

/*********************************************************************************/
#pragma  mark  - Helper methods
/*********************************************************************************/

- (void)createAttributedStrings {
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
        
        NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc]initWithString:@"Purpose"];
        [attribString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [@"Purpose" length])];
        
        [attribString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,[attribString length])];
        
        NSMutableAttributedString * finalString = [[NSMutableAttributedString alloc] initWithString:@"\n\nThis activity will ask you to assess how you feel on 5 different important areas: Cognition (mental clarity), Mood, Energy level, Sleep quality, and Exercise.  We recommend that you answer these towards the end of the day, reflecting on how you felt on this particular day.\n\n"];
        
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
        [finalString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [finalString length])];
        
        [finalString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,[finalString length])];
        
        [attribString appendAttributedString:finalString];
        
        
        self.purpose = attribString;
    }
    
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
        
        NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc]initWithString:@"Length"];
        [attribString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [@"Length" length])];
        [attribString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0,[attribString length])];
        
        NSMutableAttributedString * finalString = [[NSMutableAttributedString alloc] initWithString:@"\n\nThis task will take you less than two minutes to complete.\n\n"];
        
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
        [finalString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [finalString length])];
        
        [finalString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,[finalString length])];

        [attribString appendAttributedString:finalString];
        
        self.length = attribString;
    }

}
@end
