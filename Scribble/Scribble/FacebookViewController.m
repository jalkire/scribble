//
//  FacebookViewController.m
//  Scribble
//
//  Created by Tyler Dahl on 11/5/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "FacebookViewController.h"
#import "ChatroomTableViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookViewController ()

@end

@implementation FacebookViewController
- (IBAction)facebookSignIn:(id)sender
{
    /*
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.readPermissions = @[@"basic_info"];
    [self.view addSubview:loginView];
    
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState status,
                                                      NSError *error) {
                                      // Respond to session state changes,
                                      // ex: updating the view
                                  }];
     */
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
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        //[self refresh:nil];
        //NSLog(@"there is a current user");
        ChatroomTableViewController *chatView = [[ChatroomTableViewController alloc] init];
        [self presentViewController:(ChatroomTableViewController *)chatView
                           animated:YES
                         completion:nil];
    }
    else {
        [PFUser logInWithUsername:@"Guest" password:@"Pass"];
        /*
         // Dummy username and password
         PFUser *user = [PFUser user];
         user.username = @"Guest";
         user.password = @"Pass";
         user.email = @"guest@example.com";
         
         [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (!error) {
         //    [self refresh:nil];
         } else {
         [PFUser logInWithUsername:@"Matt" password:@"password"];
         // [self refresh:nil];
         NSLog(@"Sign Up Failed");
         }
         }];
         */
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
