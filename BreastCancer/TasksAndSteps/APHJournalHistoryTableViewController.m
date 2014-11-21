//
//  APHJournalHistoryTableViewController.m
//  BreastCancer
//
//  Created by Justin Warmkessel on 11/21/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "APHJournalHistoryTableViewController.h"
#import "APHAppDelegate.h"
#import <CoreData/CoreData.h>

@interface APHJournalHistoryTableViewController ()

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation APHJournalHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    APHAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSDate *now = [NSDate date];
    NSDate *sevenDaysAgo = [now dateByAddingTimeInterval:-7*24*60*60];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"createdAt" ascending:NO];
    
    NSFetchRequest *fetchRequest = [appDelegate.dataSubstrate requestForScheduledTasksDueFrom:sevenDaysAgo toDate:[NSDate date] sortDescriptors:@[sortDescriptor]];

    NSFetchedResultsController *resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.dataSubstrate.mainContext sectionNameKeyPath:nil cacheName:nil];
    
    NSArray *logs = resultsController.fetchedObjects;
    
    NSLog(@"Log: %@", logs);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
    // init the cell
    // and whatever other setup needed
//    
//    WorkoutSet *workoutSet =
//    [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
    // configure the cell from the managedObject properties
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Core Data Implementation

//- (NSFetchRequest*) requestForScheduledTasksDueFrom:(NSDate *)fromDate toDate:(NSDate *)toDate sortDescriptors: (NSArray*) sortDescriptors
//{
//    
//    NSFetchRequest * request = [APCScheduledTask request];
//    request.predicate = [NSPredicate predicateWithFormat:@"dueOn >= %@ and dueOn < %@", fromDate, toDate];
//    request.sortDescriptors = sortDescriptors;
//    return request;
//}
//
//- (NSFetchedResultsController *)fetchedResultsController {
//    
//    if (self.fetchedResultsController != nil) {
//        return self.fetchedResultsController;
//    }
//    
//    NSFetchRequest * request = [APCScheduledTask request];
//    
//    NSEntityDescription *entity = [NSEntityDescription
//                                   entityForName:@"Workouts"
//                                   inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
//                              initWithKey:@"workoutName" ascending:NO];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
//    
//    [fetchRequest setFetchBatchSize:20];
//    
//    NSFetchedResultsController *theFetchedResultsController =
//    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                        managedObjectContext:self.managedObjectContext
//                                          sectionNameKeyPath:@"trainingLevel"
//                                                   cacheName:@"Root"];
//    self.fetchedResultsController = theFetchedResultsController;
//    self.fetchedResultsController.delegate = self;
//    
//    return self.fetchedResultsController;
//    
//}

@end
