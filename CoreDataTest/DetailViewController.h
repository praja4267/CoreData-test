//
//  DetailViewController.h
//  CoreDataTest
//
//  Created by Active Mac05 on 01/07/16.
//  Copyright © 2016 techactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *companyTextField;
@property (strong, nonatomic) IBOutlet UITextField *versionTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, strong) NSManagedObjectModel *selectedItem;
@end
