
//
//  ChatroomTableViewController.m
//  Scribble
//
//  Created by Tyler Dahl on 11/13/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "ChatroomTableViewController.h"
#import "PictureListViewController.h"
#import "FacebookViewController.h"
#import "AppDelegate.h"

@interface ChatroomTableViewController ()
@property NSArray *chatrooms;
- (IBAction)logoutButton:(id)sender;

@end

@implementation ChatroomTableViewController

- (void)refreshChatrooms: (NSArray*) chatrooms error: (NSError*) error
{
    if (!error)
    {
        NSLog(@"%@", [self.facebookFriends firstObject]);
        NSLog(@"\n\nPRINT SOMETHING\n\n");
        
        NSMutableArray *friendRooms = [[NSMutableArray alloc] init];
        if (self.facebookFriends)
        {
            for (PFObject *room in chatrooms)
            {
                PFUser *user = room[@"User"];
                //make sure the room actually has a user
                if ([room[@"User"] fetchIfNeeded])
                {
                    for (NSString *name in self.facebookFriends)
                    {
                        //NSLog(@"\n%@\n%@\n", user.username, name);
                        //NSLog(@"%hhd\n", [user.username isEqual:name]);
                        if ([user.username isEqual:name])
                        {
                            //NSLog(@"This is getting run\n\n");
                            [friendRooms addObject:room];
                            break;
                        }
                    }
                    [friendRooms addObject:room];
                    //[friendRooms removeObject:room];
                }
            }
        }
        
        NSLog(@"load rooms\nRooms: %lu\n\n", (unsigned long)friendRooms.count);
        if (self.facebookFriends)
        {
            self.chatrooms = (NSArray *)friendRooms;
        }
        else
        {
            self.chatrooms = chatrooms;
        }
        [self.tableView reloadData];
    }
}

- (void)getParseChatrooms
{
    PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"];
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(refreshChatrooms:error:)];
}

- (IBAction)unwindAction:(UIStoryboardSegue*)unwindSegue
{
    [self getParseChatrooms];
}

- (IBAction)unwindWithFacebookFriends:(UIStoryboardSegue*)unwindSegue
{
    FacebookViewController *colors = unwindSegue.sourceViewController;
    
    self.facebookFriends = colors.facebookFriends;
    
    [self getParseChatrooms];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showLoginView
{
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //FacebookViewController* loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"facebook"];
    
    [self performSegueWithIdentifier:@"presentSignIn" sender:self];
    //[self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([PFUser currentUser])
    {
        if (![appDelegate.session isOpen]) {
        //if (![FBSession openActiveSessionWithReadPermissions:nil
        //                                        allowLoginUI:NO
        //                                   completionHandler:^(FBSession *session,
        //                                                       FBSessionState state, NSError *error) {
        //                                       NSLog(@"Error: %@", error);
        //                                   }]) {
                                               
    NSLog(@"\nGet Facebook Friends\n");
                                               
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
    }];
                                           }
    }
    
    [self getParseChatrooms];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.chatrooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *chatroom;
    chatroom = self.chatrooms[indexPath.row];
    
    //NSString *chattitle = self.chatrooms[indexPath.row];
    
    cell.textLabel.text = chatroom[@"Name"];
    //cell.detailTextLabel.text = @"0 members";
    
    return cell;
}



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // See if the app has a valid token for the current state.
    
    
    if (![PFUser currentUser])
    {
        if (![FBSession openActiveSessionWithReadPermissions:nil
                                            allowLoginUI:NO
                                       completionHandler:^(FBSession *session,
                                                           FBSessionState state, NSError *error) {
                                           NSLog(@"Error: %@", error);
                                       }]) {
                                           
                                           // No, display the login page.
                                           [self showLoginView];
                                           
                                       }
    }
    
    NSLog(@"Current User: %@", [[PFUser currentUser] username]);
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"chatroom"])
    {
        PictureListViewController *conversation = segue.destinationViewController;
        NSIndexPath *selectedPath = self.tableView.indexPathForSelectedRow;
        
        conversation.chatroom = self.chatrooms[selectedPath.row][@"Name"];
    }



}

- (IBAction)logoutButton:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.session closeAndClearTokenInformation];
    //appDelegate.session = nil;
    if ([PFUser currentUser])
    {
        [PFUser logOut];
    }
    //[appDelegate.session close];
    while (appDelegate.session.isOpen)
    {
        //[appDelegate.session close];
        [appDelegate.session closeAndClearTokenInformation];
    }
    [self showLoginView];
}
@end
