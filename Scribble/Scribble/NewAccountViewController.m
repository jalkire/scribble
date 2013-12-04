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
    
    //ChatroomTableViewController *chatroomList = [[ChatroomTableViewController alloc] init];
                                                // initWithNibName:nil
                                                // bundle:nil];
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //    [self refresh:nil];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            UINavigationController* chatroomList = [storyboard instantiateViewControllerWithIdentifier:@"chatroomsNav"];
            
            [self presentViewController:chatroomList animated:YES completion:nil];
            
            //[self presentViewController:(ChatroomTableViewController *) chatroomList
            //                   animated:NO
            //                 completion:nil];
        } else {
            [PFUser logInWithUsername:@"Zelda" password:@"password"];
            // [self refresh:nil];
        }
    }];
}
- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.usernameField isFirstResponder])
        [self.usernameField resignFirstResponder];
    else if ([self.passwordField isFirstResponder])
        [self.passwordField resignFirstResponder];
    else if ([self.emailField isFirstResponder])
        [self.emailField resignFirstResponder];
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
