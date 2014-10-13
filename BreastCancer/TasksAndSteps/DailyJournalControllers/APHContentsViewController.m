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

static  NSString  *kNotesStoragePath = @"DailyMoodLogs.json";

static  NSString  *kContentsTableViewCellIdentifier = @"APHNotesContentsTableViewCell";

@interface APHContentsViewController  ( )  <UITableViewDataSource, UITableViewDelegate, APHNotesViewControllerDelegate>

@property  (nonatomic, weak)  IBOutlet  UITableView  *tabulator;

@property  (nonatomic, strong)          NSMutableArray  *dataModels;

@end

@implementation APHContentsViewController

#pragma  mark  -  Temporary Store and Fetch Methods

- (NSString *)filenameForDailyLogStorage
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *directoryPath = paths[0];
    
    NSString  *notesPath = [directoryPath stringByAppendingPathComponent:kNotesStoragePath];
    return  notesPath;
}

- (NSDictionary *)fetchDataModels
{
    NSString  *path = [self filenameForDailyLogStorage];
    NSData    *contents = [NSData dataWithContentsOfFile:path];
    
    id  object = nil;
    if (contents != nil) {
        NSError  *error = nil;
        object = [NSJSONSerialization JSONObjectWithData:contents options:0 error:&error];
        
        if ([object isMemberOfClass:[NSDictionary class]] == YES && error == nil) {
        }
    }
    return  object;
}

- (void)storeDataModels:(NSDictionary *)jsonObjects
{
    NSError  *error = nil;
    NSData   *data = [NSJSONSerialization dataWithJSONObject:jsonObjects options:0 error:&error];
    if (error != nil) {
        NSLog(@"Unable to Write Jason Data");
    } else {
        NSString  *path = [self filenameForDailyLogStorage];
        [data writeToFile:path atomically:YES];
    }
}

#pragma  mark  -  Note Creation Controller Delegate Methods

- (void)notesDidCancel:(APHNotesViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)controller:(APHNotesViewController *)controller notesDidCompleteWithNote:(NSDictionary *)note
{
    [self.dataModels addObject:note];
    NSDictionary  *collection = @{ @"items" : self.dataModels };
    [self storeDataModels:collection];
    
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
    return  [self.dataModels count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary  *model = self.dataModels[indexPath.row];
    
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
    NSDictionary  *model = self.dataModels[indexPath.row];
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
    
    NSDictionary  *modelsDictionary = [self fetchDataModels];
    if (modelsDictionary == nil) {
        self.dataModels = [NSMutableArray array];
    } else {
        NSArray  *models = modelsDictionary[@"items"];
        self.dataModels = [models mutableCopy];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
