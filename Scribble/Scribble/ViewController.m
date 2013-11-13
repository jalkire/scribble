//
//  ViewController.m
//  Scribble
//
//  Created by Tyler Dahl on 10/31/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "ViewController.h"
#import "PathView.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet PathView *pathView;

@end

@implementation ViewController
- (IBAction)didPan:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.pathView];
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self.pathView beginPath:point];
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        [self.pathView addPath:point];
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.pathView endPoint:point];
    }
    if (sender.state == UIGestureRecognizerStateCancelled)
    {
        [self.pathView endPoint:point];
    }
}
- (IBAction)doneButtonTapped:(UIButton*)sender
{
    
    UIGraphicsBeginImageContext(self.pathView.bounds.size);
    [self.pathView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(image1);
    
}

- (void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                if (!error)
                {
                 //   [self refresh:nil];
                }
                else
                {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];

        }
    }];
}








- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*TESTING PARSE STUFF*/
    //PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //[testObject setObject:@"bar" forKey:@"foo"];
    //[testObject save];
    
/*  PFObject *person = [PFObject objectWithClassName:@"Person"];
    person[@"Name"] = @"John";
    person[@"Age"] = @21;
    
    [person saveInBackground];   */
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
