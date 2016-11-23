//
//  ViewController.m
//  CoreDataTest
//
//  Created by Active Mac05 on 01/07/16.
//  Copyright © 2016 techactive. All rights reserved.
//

#import "ViewController.h"
#import "KeychainWrapper.h"
#import "AddNewViewController.h"

@interface ViewController (){
    KeychainWrapper* MyKeychainWrapper;
    BOOL createLoginButtonTag;
    BOOL loginButtonTag;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyKeychainWrapper = [[KeychainWrapper alloc] init];
    createLoginButtonTag = NO;
    loginButtonTag=YES;
    [_nextButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_nextButton addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginButtonPressed : (UIButton*)sender{
    if (sender.tag == createLoginButtonTag) {
        
        // 4.
        BOOL hasLoginKey = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasLoginKey"];
        if (hasLoginKey == NO) {
            [[NSUserDefaults standardUserDefaults] setValue:_emailIdField.text forKey:@"username"];
        }
        
        // 5.
        [MyKeychainWrapper mySetObject:_passwordField.text forKey:kSecValueData];
        [MyKeychainWrapper writeToKeychain];
        [[NSUserDefaults standardUserDefaults] setBool: YES forKey:@"hasLoginKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _nextButton.tag = loginButtonTag;
        
        NSLog(@"storing username = %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]);
        
        NSLog(@" password storing in keychain = %@",[MyKeychainWrapper myObjectForKey:kSecValueData]);
//        performSegueWithIdentifier("dismissLogin", sender: self)
    } else if (sender.tag == loginButtonTag) {
        // 6.
        if ([self checkLogin:_emailIdField.text andPassword:_passwordField.text]) {
            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            AddNewViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddNewViewController"];
//            UINavigationController* navcntl = [[UINavigationController alloc] initWithRootViewController:detailViewController];
//            [self presentViewController:navcntl animated:YES completion:nil];
            
            NSLog(@"successfully logged in");
            [self performSegueWithIdentifier:@"openAddNewViewController" sender:self];
        } else {
            NSLog(@"Userid or password is incorrect");
        }
    }
}

-(BOOL) checkLogin : (NSString*)username andPassword : (NSString*)password {
    NSLog(@"username comparing in usedefaults = %@ and password comared in keychain = %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"username"], [MyKeychainWrapper myObjectForKey:@"v_Data"]);
    if (([password isEqualToString: [MyKeychainWrapper myObjectForKey:kSecValueData]])  && [username isEqualToString: [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]]){
        return YES;
    } else {
        return NO;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"openDetailController"]) { //@"openAddNewViewController"
        
    }else{
        
    }
}
@end
