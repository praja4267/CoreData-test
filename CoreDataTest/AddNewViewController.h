//
//  AddNewViewController.h
//  CoreDataTest
//
//  Created by Active Mac05 on 01/07/16.
//  Copyright © 2016 techactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UITableView *addItemsTableView;

@end
