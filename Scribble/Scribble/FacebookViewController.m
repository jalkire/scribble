//
//  FacebookViewController.m
//  Scribble
//
//  Created by Tyler Dahl on 11/5/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "FacebookViewController.h"
#import "AppDelegate.h"
#import "ChatroomTableViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginlogout;
- (IBAction)buttonClickHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textNoteOrLink;
//@property NSArray *facebookFriends;

@end

@implementation FacebookViewController

//- (void)facebookSignIn:
//{
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
/*}*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self updateView];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
}


- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        [self.loginlogout setTitle:@"Log out" forState:UIControlStateNormal];
        [self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
                                      appDelegate.session.accessTokenData.accessToken]];
        
        //Dismiss the view
        //[self.presentingViewController dismissViewControllerAnimated:YES completion:^
         //{
             //Get the username from the facebook account
             [FBRequestConnection
              startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                id<FBGraphUser> user,
                                                NSError *error) {
                  if (!error)
                  {
                      NSString *userInfo = @"";
                      NSString *username = @"";
                      
                      // Example: typed access (name)
                      // - no special permissions required
                      userInfo = [userInfo
                                  stringByAppendingString:
                                  [NSString stringWithFormat:@"%@",
                                   user.name]];
                      
                      username = [userInfo
                                  stringByAppendingString:
                                  [NSString stringWithFormat:@"%@",
                                   user.username]];
                      NSLog(@"\n\nName: %@\n\nUsername: %@\n\n", user.name, user.username);
                      
                      PFUser *newUser = [PFUser user];
                      newUser.username = userInfo;
                      newUser.password = @"pass";
                      //newUser.email = email;
                      
                      //[newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                          if ([newUser signUp]) {
                              //    [self refresh:nil];
                              NSLog(@"\n\nSuccessfully signed up facebook profile\n\n");
                          } else {
                              [PFUser logInWithUsername:userInfo password:@"pass"];
                              NSLog(@"\n\nFailed to sign up facebook profile, attempting to login\n\n");
                              // [self refresh:nil];
                          }
                      //}];
                      
                      NSLog(@"\n\n\n\n%@\n\n\n\n\n",userInfo);
                  }
              }];
             
             //Get a list of friends from their Facebook account
             FBRequest* friendsRequest = [FBRequest requestForMyFriends];
             [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                           NSDictionary* result,
                                                           NSError *error) {
                 NSArray* friends = [result objectForKey:@"data"];
                 NSMutableArray *facebookFriends = [[NSMutableArray alloc] init];
                 NSLog(@"Found: %lu friends", (unsigned long)friends.count);
                 for (NSDictionary<FBGraphUser>* friend in friends) {
                     [facebookFriends addObject:friend.name];
                     //NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
                 }
                 self.facebookFriends = facebookFriends;
                 NSLog(@"Total Friends: %lu", (unsigned long)self.facebookFriends.count);
                 NSLog(@"Friend 1: %@", self.facebookFriends.firstObject);
                 //ChatroomTableViewController *presentingView = [[ChatroomTableViewController alloc] init];
                 //presentingView.facebookFriends = facebookFriends;
                 
                 //refresh the chatrooms
                 //[presentingView getParseChatrooms];
                 //ChatroomTableViewController *chatrs = self.presentingViewController;
                 //chatrs.facebookFriends = facebookFriends;
                 //[chatrs getParseChatrooms];
                 
                 //ChatroomTableViewController *chats = [[ChatroomTableViewController alloc] initWithNibName:@"ChatroomTableViewController" bundle:nil];
                 //chats.facebookFriends = facebookFriends;
                 //[chats getParseChatrooms];
             }];
             //[self.presentingViewController refreshChatrooms];
         //}];
        
        
        [self performSegueWithIdentifier:@"dismissSignIn" sender:self];
        //[self.presentingViewController dismissViewControllerAnimated:YES completion:^
        // {
             
        // }];
    } else {
        // login-needed account UI is shown whenever the session is closed
        [self.loginlogout setTitle:@"Log in" forState:UIControlStateNormal];
        [self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
    }
}

- (IBAction)buttonClickHandler:(id)sender {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
}

- (void)viewDidUnload
{
    self.loginlogout = nil;
    self.textNoteOrLink = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
