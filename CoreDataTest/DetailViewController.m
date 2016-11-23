//
//  DetailViewController.m
//  CoreDataTest
//
//  Created by Active Mac05 on 01/07/16.
//  Copyright © 2016 techactive. All rights reserved.
//

#import "DetailViewController.h"
#import <CoreData/CoreData.h>

@interface DetailViewController ()<UITextFieldDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTextField.delegate=self;
    self.companyTextField.delegate=self;
    self.versionTextField.delegate=self;
    
    if (_selectedItem) {
        self.nameTextField.text = [_selectedItem valueForKey:@"name"];
        self.companyTextField.text=[_selectedItem valueForKey:@"company"];
        self.versionTextField.text=[_selectedItem valueForKey:@"version"];
    }
    _cancelButton.target = self;
    _cancelButton.action = @selector(cancelPressed);
    
    _saveButton.target = self;
    _saveButton.action = @selector(saveButtonPressed);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)cancelPressed{
    [self.view endEditing:YES];
    if (self.selectedItem) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)saveButtonPressed{
    
    [self.view endEditing:YES];
    if ([_nameTextField.text  isEqual:@""] || [_versionTextField.text  isEqual:@""] || [_companyTextField.text  isEqual: @""]) {
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Please fill all the fields"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else {
         NSManagedObjectContext *context = [self managedObjectContext];
        if (self.selectedItem) {
            // Update the existing object with new data
            [self.selectedItem setValue:self.nameTextField.text forKey:@"name"];
            [self.selectedItem setValue:self.versionTextField.text forKey:@"version"];
            [self.selectedItem setValue:self.companyTextField.text forKey:@"company"];

        }else {
            // Create a new managed object
            NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
            NSLog(@"the names are %@", [newDevice valueForKey:@"name"]);
            [newDevice setValue:self.nameTextField.text forKey:@"name"];
            [newDevice setValue:self.versionTextField.text forKey:@"version"];
            [newDevice setValue:self.companyTextField.text forKey:@"company"];
            NSLog(@"the names are %@", [newDevice valueForKey:@"name"]);
           
            // Save the object to persistent store
            
        }
        
         NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }else {
            [self.view endEditing:YES];
            if (self.selectedItem) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


/* 
 First, we need to implement the DeviceDetailViewController to let user add the devices to the database. Open up the DeviceDetailViewController.m file and add the following code after @implementation DeviceDetailViewController:
 
 
 - (NSManagedObjectContext *)managedObjectContext {
 NSManagedObjectContext *context = nil;
 id delegate = [[UIApplication sharedApplication] delegate];
 if ([delegate performSelector:@selector(managedObjectContext)]) {
 context = [delegate managedObjectContext];
 }
 return context;
 }

 - (NSManagedObjectContext *)managedObjectContext {
 NSManagedObjectContext *context = nil;
 id delegate = [[UIApplication sharedApplication] delegate];
 if ([delegate performSelector:@selector(managedObjectContext)]) {
 context = [delegate managedObjectContext];
 }
 return context;
 }
 Recalled that we’ve selected the Core Data option when creating the project, Xcode automatically defines a managed object context in AppDelegate. This method allows us to retrieve the managed object context from the AppDelegate. Later we’ll use the context to save the device data.
 */