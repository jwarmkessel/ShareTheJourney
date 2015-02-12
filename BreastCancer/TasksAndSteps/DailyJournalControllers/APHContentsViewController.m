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

static  NSString* const         kNotesContentStoragePath = @"DailyMoodLogsContent.json";
static  NSString* const         kNotesChangesStoragePath = @"DailyMoodLogsChanges.json";

static  NSString* const kContentsTableViewCellIdentifier = @"APHNotesContentsTableViewCell";

#warning Placeholder text.
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

@property  (nonatomic, strong)            NSMutableArray*   contentObjects;
@property  (nonatomic, strong)            NSMutableArray*   changesObjects;
@property  (nonatomic, strong)                   NSArray*   logHistory;
@property  (nonatomic, strong)            RKSTStepResult*   cachedResult;
@property  (nonatomic, strong)                   UILabel*   noTasksView;
@end

@implementation APHContentsViewController

#pragma  mark  -  Temporary Store and Fetch Methods

- (NSString *)directoryForDailyLogStorage
{
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *directoryPath = paths[0];
    
    NSFileManager  *theDreadedManager = [NSFileManager defaultManager];
    BOOL  isDirectory = NO;
    BOOL  fileExists = [theDreadedManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (fileExists == NO) {
        NSError  *error = nil;
        BOOL  success = [theDreadedManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (success == NO) {
            NSLog(@"Failed to create directory path at %@", directoryPath);
        }
    }
    return  directoryPath;
}

- (NSString *)filenameForDailyLogType:(DailyLogType)type
{
    NSString  *storageDirectoryPath = [self directoryForDailyLogStorage];
    
    NSString  *filename = nil;
    
    if (type == DailyLogTypeNotesContent) {
        filename = kNotesContentStoragePath;
    } else {
        filename = kNotesChangesStoragePath;
    }
    NSString  *completeFilePath = [storageDirectoryPath stringByAppendingPathComponent:filename];
    return  completeFilePath;
}

- (NSDictionary *)fetchDataModelsForType:(DailyLogType)type
{
    NSString  *path = [self filenameForDailyLogType:type];
    NSData    *contents = [NSData dataWithContentsOfFile:path];
    
    id  object = nil;
    if (contents != nil) {
        NSError  *error = nil;
        object = [NSJSONSerialization JSONObjectWithData:contents options:0 error:&error];
        if (error != nil) {
            NSLog(@"Unable to Read Jason Data: error = %@", error);
        }
    }
    
    return  object;
}

- (void)storeDataModelsForType:(DailyLogType)type  withDictionary:(NSDictionary *)jsonObjects
{
    NSError  *error = nil;
    NSData   *data = [NSJSONSerialization dataWithJSONObject:jsonObjects options:0 error:&error];
    if (error != nil) {
        NSLog(@"Unable to Write Jason Data: error = %@", error);
    } else {
        NSString  *path = [self filenameForDailyLogType:type];
        [data writeToFile:path atomically:YES];
    }
}

/*********************************************************************************/
#pragma  mark  -  Note Creation Controller Delegate Methods
/*********************************************************************************/

- (void)notesDidCancel:(APHNotesViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)controller:(APHNotesViewController *)controller notesDidCompleteWithNote:(NSDictionary *)note  andChanges:(NSDictionary *)changes
{
    [self.contentObjects addObject:note];
    NSDictionary  *contentCollection = @{ @"items" : self.contentObjects };
    [self storeDataModelsForType:DailyLogTypeNotesContent withDictionary:contentCollection];
    
    [self.changesObjects addObject:changes];
    NSDictionary  *changesCollection = @{ @"items" : self.changesObjects };
    [self storeDataModelsForType:DailyLogTypeNotesChanges withDictionary:changesCollection];
    
    [self.tabulator reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*********************************************************************************/
#pragma  mark  -  Add Log Note Action Method
/*********************************************************************************/

- (IBAction)makeNewNoteButtonTapped:(UIButton *)sender
{

    if ([self.delegate respondsToSelector:@selector(stepViewController:didFinishWithNavigationDirection:)] == YES) {
        [self.delegate stepViewController:self didFinishWithNavigationDirection:RKSTStepViewControllerNavigationDirectionForward];
    }
}

/*********************************************************************************/
#pragma  mark  -  Table View Data Source Methods
/*********************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.logHistory count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    APCResult  *model = self.logHistory[indexPath.row];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    APCResult  *model = self.logHistory[indexPath.row];
    APHDisplayLogHistoryViewController  *stenographer = [[APHDisplayLogHistoryViewController alloc] initWithNibName:@"APHDisplayLogHistoryViewController" bundle:[NSBundle mainBundle]];
    
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterShortStyle];
    [formatter setTimeStyle: NSDateFormatterNoStyle];
    
    NSDate  *date = model.createdAt;
    
    [self presentViewController:stenographer animated:YES completion:nil];
    
    [stenographer setTextViewText:model.resultSummary];
    stenographer.dateLabel.text = [formatter stringFromDate:date];
}

/*********************************************************************************/
#pragma  mark  -  View Controller Methods
/*********************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    self.logHistory = [appDelegate.dataSubstrate.mainContext executeFetchRequest:request error:&error];
    
    if (self.logHistory.count == 0) {
        [self addCustomNoTaskView];
    } else {
        if (self.noTasksView) {
            [self.noTasksView removeFromSuperview];
            
            [self.tabulator setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
        [self.tabulator deselectRowAtIndexPath:[self.tabulator indexPathForSelectedRow] animated:YES];
    }
    
    if (error) {
        APCLogError2(error);
    }
    

    
    [self.tabulator registerNib:[UINib nibWithNibName:@"APHNotesContentsTableViewCell"
                                                   bundle:[NSBundle mainBundle]] forCellReuseIdentifier:(NSString *)kContentsTableViewCellIdentifier];
    

}

- (void) addCustomNoTaskView {
    self.noTasksView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 22.0)];
    
    self.noTasksView.text = kNoTaskText;
    self.noTasksView.textColor = [UIColor lightGrayColor];
    self.noTasksView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, self.tabulator.frame.size.height / 2);
    self.noTasksView.textAlignment = NSTextAlignmentCenter;
    [self.tabulator addSubview:self.noTasksView];
    
    [self.tabulator setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 100.0)];
    [headerView setBackgroundColor:[UIColor appSecondaryColor4]];
    
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, [UIScreen mainScreen].bounds.size.width - 40, 90.0)];

    instructions.text = kDailyJournalInstructions;
    instructions.numberOfLines = 0;
    instructions.lineBreakMode = NSLineBreakByWordWrapping;
    instructions.textColor = [UIColor darkGrayColor];
    [instructions setTextAlignment:NSTextAlignmentJustified];
    [headerView addSubview:instructions];
    
    return headerView;
}

- (RKSTStepResult *)result {
    
    if (!self.cachedResult) {
        self.cachedResult = [[RKSTStepResult alloc] initWithIdentifier:self.step.identifier];
    }
    
    return self.cachedResult;
}

@end
