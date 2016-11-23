//
//  AddNewViewController.m
//  CoreDataTest
//
//  Created by Active Mac05 on 01/07/16.
//  Copyright © 2016 techactive. All rights reserved.
//

#import "AddNewViewController.h"
#import "DetailViewController.h"
#import <CoreData/CoreData.h>

@interface AddNewViewController ()
@property (strong) NSMutableArray *devices;
@property(strong) NSArray *sortedArray;
@end

@implementation AddNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.addItemsTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"Cell"];
    self.addItemsTableView.estimatedRowHeight = 44.0;
    self.addItemsTableView.rowHeight = UITableViewAutomaticDimension;
    _addItemsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _backButton.target = self;
    _backButton.action = @selector(backButtonPressed);
    [self arrangeInDescendingOrder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.addItemsTableView reloadData];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    NSManagedObject *device = [self.devices objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        //etc.
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", [device valueForKey:@"name"], [device valueForKey:@"version"]]];
    [cell.detailTextLabel setText:[device valueForKey:@"company"]];
    
    return cell;
}

-(void) goToDetailViewController{
    DetailViewController *cntl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [self presentViewController:cntl animated:YES completion:nil];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your editAction here
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailViewController.selectedItem=[self.devices objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }];
    editAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            // Delete object from database
            [context deleteObject:[self.devices objectAtIndex:indexPath.row]];
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
            // Remove device from table view
            [self.devices removeObjectAtIndex:indexPath.row];
            [self.addItemsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction,editAction];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

//-(void) cancelButtonPressed{
//    [self.navigationController popViewController];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)backButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)arrangeInAscendingOrder{
    // Fetching
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    // Add Sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    _sortedArray = result;
    [self.addItemsTableView reloadData];
    if (!fetchError) {
        for (NSManagedObject *managedObject in result) {
            NSLog(@"%@, %@", [managedObject valueForKey:@"name"], [managedObject valueForKey:@"company"]);
        }
        
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }
}

-(void)arrangeInDescendingOrder{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    // Add Sort Descriptor
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    // Execute Fetch Request
    NSError *fetchError = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    _sortedArray = result;
    [self.addItemsTableView reloadData];
    if (!fetchError) {
        for (NSManagedObject *managedObject in result) {
            NSLog(@"%@, %@", [managedObject valueForKey:@"name"], [managedObject valueForKey:@"company"]);
        }
        
    } else {
        NSLog(@"Error fetching data.");
        NSLog(@"%@, %@", fetchError, fetchError.localizedDescription);
    }

}
-(void)removeTopSpaceOfTableView{
        self.edgesForExtendedLayout = UIRectEdgeNone;
    //
    //    //  OR
    //
    //    self.addItemsTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    //
    //    //OR
    //
    //    self.automaticallyAdjustsScrollViewInsets = false;
}

@end
