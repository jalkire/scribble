//
//  NewAccountViewController.m
//  Scribble
//
//  Created by Tyler Dahl on 11/21/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "NewAccountViewController.h"
#import "ChatroomTableViewController.h"
#import "Parse/Parse.h"

@interface NewAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

@implementation NewAccountViewController
- (IBAction)createAccount:(id)sender
{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    NSString *email = self.emailField.text;
    
    ChatroomTableViewController *chatroomList = [[ChatroomTableViewController alloc]
                                                 initWithNibName:nil
                                                 bundle:nil];
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //    [self refresh:nil];
            
            [self presentViewController:(ChatroomTableViewController *) chatroomList
                               animated:NO
                             completion:nil];
        } else {
            [PFUser logInWithUsername:@"Zelda" password:@"password"];
            // [self refresh:nil];
        }
    }];
}

- (IBAction)hideKeyboard:(id)sender
{
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
