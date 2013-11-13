//
//  AddChatroomViewController.m
//  Scribble
//
//  Created by Tyler Dahl on 11/13/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "AddChatroomViewController.h"

@interface AddChatroomViewController ()
@property (weak, nonatomic) IBOutlet UITextField *chatroomName;

@end

@implementation AddChatroomViewController
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addChatroom:(id)sender {
    PFObject *chatroom = [PFObject objectWithClassName:@"Chatroom"];
    chatroom[@"Name"] = self.chatroomName.text;
    
    [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             [self performSegueWithIdentifier:@"dismissAddView" sender:sender];
         }
         else
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
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
