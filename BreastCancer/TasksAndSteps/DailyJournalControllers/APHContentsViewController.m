//
//  APHContentsViewController.m
//  TestNotesApplication
//
//  Created by Henry McGilton on 10/7/14.
//  Copyright (c) 2014 Henry McGilton. All rights reserved.
//

#import "APHContentsViewController.h"
#import "APHNotesViewController.h"
#import "APHMoodLogDictionaryKeys.h"

#import "APHNotesContentsTableViewCell.h"

static  NSString  *kNotesContentStoragePath = @"DailyMoodLogsContent.json";
static  NSString  *kNotesChangesStoragePath = @"DailyMoodLogsChanges.json";

static  NSString  *kContentsTableViewCellIdentifier = @"APHNotesContentsTableViewCell";

typedef  enum  _DailyLogType
{
    DailyLogTypeNotesContent,
    DailyLogTypeNotesChanges
}  DailyLogType;

@interface APHContentsViewController  ( )  <UITableViewDataSource, UITableViewDelegate, APHNotesViewControllerDelegate>

@property  (nonatomic, weak)  IBOutlet  UITableView     *tabulator;

@property  (nonatomic, strong)          NSMutableArray  *contentObjects;
@property  (nonatomic, strong)          NSMutableArray  *changesObjects;

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

#pragma  mark  -  Note Creation Controller Delegate Methods

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

#pragma  mark  -  Add Log Note Action Method

- (IBAction)makeNewNoteButtonTapped:(UIButton *)sender
{
    APHNotesViewController  *stenographer = [[APHNotesViewController alloc] initWithNibName:nil bundle:nil];
    
    stenographer.delegate = self;
    
    [self presentViewController:stenographer animated:YES completion:^{ }];
}

#pragma  mark  -  Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.contentObjects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary  *model = self.contentObjects[indexPath.row];
    
    APHNotesContentsTableViewCell  *cell = (APHNotesContentsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kContentsTableViewCellIdentifier];
    
    cell.noteName.text = [NSString stringWithFormat:@"Log %d", (indexPath.row + 1)];
    
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterShortStyle];
    [formatter setTimeStyle: NSDateFormatterNoStyle];
    
    NSTimeInterval  timestamp = [model[APHMoodLogNoteTimeStampKey] doubleValue];
    NSDate  *date = [NSDate dateWithTimeIntervalSinceReferenceDate:timestamp];
    cell.noteDate.text = [formatter stringFromDate:date];
    
    return  cell;
}

#pragma  mark  -  Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary  *model = self.contentObjects[indexPath.row];
    APHNotesViewController  *stenographer = [[APHNotesViewController alloc] initWithNibName:nil bundle:nil];
    stenographer.delegate = self;
    stenographer.note = model;
    
    [self presentViewController:stenographer animated:YES completion:^{ }];
}

#pragma  mark  -  View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabulator registerNib:[UINib nibWithNibName:@"APHNotesContentsTableViewCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:(NSString *)kContentsTableViewCellIdentifier];
    
    NSDictionary  *modelsDictionary = [self fetchDataModelsForType:DailyLogTypeNotesContent];
    if (modelsDictionary == nil) {
        self.contentObjects = [NSMutableArray array];
        self.changesObjects = [NSMutableArray array];
    } else {
        NSArray  *contentModels = modelsDictionary[@"items"];
        self.contentObjects = [contentModels mutableCopy];
        NSArray  *changesModels = modelsDictionary[@"items"];
        self.changesObjects = [changesModels mutableCopy];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
