//
//  LoginViewController.m
//  Scribble
//
//  Created by Tyler Dahl on 12/2/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "LoginViewController.h"
#import "ChatroomTableViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController
- (IBAction)login:(id)sender
{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    //ChatroomTableViewController *chatroomList = [[ChatroomTableViewController alloc] init];
    // initWithNibName:nil
    // bundle:nil];
    
    //if it succeeds in logging in
    if ([PFUser logInWithUsername:username password:password])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UINavigationController* chatroomList = [storyboard instantiateViewControllerWithIdentifier:@"chatroomsNav"];
        
        [self presentViewController:chatroomList animated:YES completion:nil];
    }
    else
    {
        NSLog(@"Login Failed. Try Again.\n");
    }
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
