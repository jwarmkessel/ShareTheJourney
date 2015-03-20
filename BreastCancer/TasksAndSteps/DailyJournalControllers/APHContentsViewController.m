// 
//  APHContentsViewController.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import "APHContentsViewController.h"
#import "APHNotesViewController.h"
#import "APHMoodLogDictionaryKeys.h"
#import "APHAppDelegate.h"
#import "APHNotesContentsTableViewCell.h"
#import "APHDisplayLogHistoryViewController.h"
#import "APHNotesHeaderTableViewCell.h"

static  NSString* const         kNotesContentStoragePath = @"DailyMoodLogsContent.json";
static  NSString* const         kNotesChangesStoragePath = @"DailyMoodLogsChanges.json";

static  NSString* const kContentsTableViewCellIdentifier = @"APHNotesContentsTableViewCell";
static  NSString* const kHeaderTableViewCellIdentifier = @"APHNotesHeaderTableViewCell";

static NSString* kDailyJournalInstructions = @"Keeping a daily journal will help you stay focused and motivated.";
static NSString* kNoTaskText = @"You have no entries";

typedef  enum  _DailyLogType
{
    DailyLogTypeNotesContent,
    DailyLogTypeNotesChanges
}  DailyLogType;

@interface APHContentsViewController  ( )  <UITableViewDataSource, UITableViewDelegate>

@property  (nonatomic, weak)    IBOutlet     UITableView*   tabulator;
@property  (nonatomic, weak)    IBOutlet        UIButton*   enterDailyLog;

@property                                   NSDictionary*   sectionedLogHistory;
@property                                        NSArray*   weeks;
@property  (nonatomic, strong)             ORKStepResult*   cachedResult;
@property  (nonatomic, strong)                   UILabel*   noTasksView;
@end

@implementation APHContentsViewController

#pragma  mark  -  Temporary Store and Fetch Methods

/*********************************************************************************/
#pragma  mark  -  Note Creation Controller Delegate Methods
/*********************************************************************************/

- (void)notesDidCancel:(APHNotesViewController *) __unused controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*********************************************************************************/
#pragma  mark  -  Add Log Note Action Method
/*********************************************************************************/

- (IBAction)makeNewNoteButtonTapped:(UIButton *) __unused sender
{

    if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
        [self.delegate stepViewController:self didFinishWithNavigationDirection:ORKStepViewControllerNavigationDirectionForward];
    }
}

/*********************************************************************************/
#pragma  mark  -  Table View Data Source Methods
/*********************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *) __unused tableView
{
    return  1 + self.sectionedLogHistory.count ;
}

- (NSInteger)tableView:(UITableView *) __unused tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return  MAX( (NSUInteger) 1, ((NSArray *)[self.sectionedLogHistory objectForKey:self.weeks[section -1]]).count );
    }
}

- (CGFloat)tableView:(UITableView *) __unused tableView heightForRowAtIndexPath:(NSIndexPath *) __unused indexPath
{
    return  44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.sectionedLogHistory) {
        return [UITableViewCell new];
    }

    NSString *key = [self keyForSection:indexPath.section];
    APCResult  *model = [self.sectionedLogHistory objectForKey:key][indexPath.row];
    
    APHNotesContentsTableViewCell  *cell = (APHNotesContentsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kContentsTableViewCellIdentifier];
    
    cell.noteName.text = model.resultSummary;
    
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterShortStyle];
    [formatter setTimeStyle: NSDateFormatterNoStyle];

    NSDate  *date = model.createdAt;
    cell.noteDate.text = [formatter stringFromDate:date];
    
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
    
    return  cell;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([self.tabulator respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tabulator setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tabulator respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tabulator setLayoutMargins:UIEdgeInsetsZero];
    }
}

/*********************************************************************************/
#pragma  mark  -  Table View Delegate Methods
/*********************************************************************************/

-(NSString *)keyForSection:(NSInteger)section{
    
    return self.weeks[section -1];
    
}

- (void)tableView:(UITableView *) __unused tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *key = [self keyForSection:indexPath.section];
    APCResult  *model = [self.sectionedLogHistory objectForKey:key][indexPath.row];
    APHDisplayLogHistoryViewController  *stenographer = [[APHDisplayLogHistoryViewController alloc] initWithNibName:@"APHDisplayLogHistoryViewController" bundle:[NSBundle mainBundle]];
    
    stenographer.logText = model.resultSummary;
    stenographer.logDate = model.createdAt;
    
    stenographer.navigationItem.rightBarButtonItem = self.cancelButtonItem;
    
    [self.navigationController pushViewController:stenographer animated:YES];
}

/*********************************************************************************/
#pragma  mark  -  View Controller Methods
/*********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabulator.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    APHAppDelegate *appDelegate = (APHAppDelegate*) [UIApplication sharedApplication].delegate;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"endDate" ascending:NO];
    
    
    NSFetchRequest * request = [APCResult request];
    
    request.predicate = [NSPredicate predicateWithFormat:@"taskID == %@", [[self.taskViewController task] identifier]];
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    
    NSArray *logHistory = [appDelegate.dataSubstrate.mainContext executeFetchRequest:request error:&error];
    
    if (logHistory.count == 0) {
        [self addCustomNoTaskView];
    } else {
        if (self.noTasksView) {
            [self.noTasksView removeFromSuperview];
            
            [self.tabulator setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
        [self sectionLogHistory:logHistory];
        [self.tabulator deselectRowAtIndexPath:[self.tabulator indexPathForSelectedRow] animated:YES];
    }
    
    if (error) {
        APCLogError2(error);
    }

    [self.tabulator registerNib:[UINib nibWithNibName:@"APHNotesContentsTableViewCell"
                                                   bundle:[NSBundle mainBundle]] forCellReuseIdentifier:(NSString *)kContentsTableViewCellIdentifier];
    
    [self.tabulator registerNib:[UINib nibWithNibName:@"APHNotesHeaderTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:(NSString *)kHeaderTableViewCellIdentifier];
    

}

- (void) addCustomNoTaskView {
   
    //only add this message once
    if (!self.noTasksView)
    {
        self.noTasksView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 22.0)];
        
        
        self.noTasksView.text = kNoTaskText;
        self.noTasksView.textColor = [UIColor lightGrayColor];
        self.noTasksView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, self.tabulator.frame.size.height / 2);
        self.noTasksView.textAlignment = NSTextAlignmentCenter;
        [self.tabulator addSubview:self.noTasksView];
        
        [self.tabulator setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    if (section == 0) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 100.0)];
        [headerView setBackgroundColor:[UIColor appSecondaryColor4]];
        
        UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, [UIScreen mainScreen].bounds.size.width - 40, 90.0)];
        
        instructions.text = kDailyJournalInstructions;
        instructions.numberOfLines = 0;
        instructions.lineBreakMode = NSLineBreakByWordWrapping;
        instructions.textColor = [UIColor blackColor];
        [instructions setTextAlignment:NSTextAlignmentJustified];
        [headerView addSubview:instructions];
    } else {
        APHNotesHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:kHeaderTableViewCellIdentifier];
    
        headerCell.labelWeek.text = [NSLocalizedString(@"Week", @"Week") stringByAppendingFormat:@" %@", [self keyForSection:section]];
        NSString *key = [self keyForSection:section];
        NSInteger entryCount = ((NSArray *)[self.sectionedLogHistory objectForKey:key]).count;
        
        headerCell.labelEntries.text =  entryCount == 1 ? [NSString stringWithFormat:@"%zd %@", entryCount, NSLocalizedString(@"Entry", nil)] : [NSString stringWithFormat:@"%zd %@", entryCount, NSLocalizedString(@"Entries", @"Entries")];
        
        headerView = headerCell;
    }
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)__unused tableView heightForHeaderInSection:(NSInteger)__unused section{
    if (section == 0) {
        return 90.0;
    }else{
        return 44.0;
    }
}

- (void)sectionLogHistory:(NSArray *)logHistory {
    
    //give me a dictionary of arrays using the week number as a key
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    logHistory = [logHistory sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSMutableDictionary *entriesByWeek = [NSMutableDictionary dictionary];
    NSMutableArray *weeks = [NSMutableArray new];
    for (APCResult *result in logHistory) {
        
        NSDateComponents *identifyingDateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitWeekOfYear) fromDate:result.createdAt];
        NSString *key = [NSString stringWithFormat:@"%li/%li", identifyingDateComponents.year, identifyingDateComponents.weekOfYear];
        
        if ([entriesByWeek objectForKey:key]) {
            NSMutableArray *entries = [entriesByWeek objectForKey:key];
            [entries addObject:result];
            [entriesByWeek setObject:entries forKey:key];
        }else{
            //Add the array entry for the week
            NSMutableArray *entries = [NSMutableArray new];
            [entries addObject:result];
            [entriesByWeek setObject:entries forKey:key];
            [weeks addObject:key];
        }
        
    }
    
    self.sectionedLogHistory = [NSDictionary dictionaryWithDictionary:entriesByWeek];
    self.weeks = weeks;
}

- (ORKStepResult *)result {
    
    if (!self.cachedResult) {
        self.cachedResult = [[ORKStepResult alloc] initWithIdentifier:self.step.identifier];
    }
    
    return self.cachedResult;
}

@end
