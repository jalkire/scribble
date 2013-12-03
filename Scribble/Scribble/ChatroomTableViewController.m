
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
        self.chatrooms = chatrooms;
        [self.tableView reloadData];
    }
}

- (IBAction)unwindAction:(UIStoryboardSegue*)unwindSegue
{
    PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"];
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(refreshChatrooms:error:)];
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    FacebookViewController* loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"facebook"];
    
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"];
    [query findObjectsInBackgroundWithTarget:self
                                    selector:@selector(refreshChatrooms:error:)];
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
    cell.detailTextLabel.text = @"0 members";
    
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
    AppDelegate *appDelegate;
    [appDelegate.session closeAndClearTokenInformation];
    if ([PFUser currentUser])
    {
        [PFUser logOut];
    }
    
    [self viewDidAppear:NO];
}
@end
