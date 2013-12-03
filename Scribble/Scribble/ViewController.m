//
//  ViewController.m
//  Scribble
//
//  Created by Tyler Dahl on 10/31/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "ViewController.h"
#import "ColorChoiceViewController.h"
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

- (IBAction)undo:(id)sender
{
    
    UIBezierPath *path  = [self.pathView.oldpaths lastObject];
    [path removeAllPoints];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.pathView.oldpaths];
    NSMutableArray *tempColorArray = [NSMutableArray arrayWithArray:self.pathView.pathColors];
    [tempArray removeLastObject];
    [tempColorArray removeLastObject];
    self.pathView.oldpaths = [NSArray arrayWithArray:tempArray];
    self.pathView.pathColors = [NSArray arrayWithArray:tempColorArray];
    [self.pathView setNeedsDisplay];
    
}

- (IBAction)doneButtonTapped:(UIButton*)sender
{
    UIGraphicsBeginImageContext(self.pathView.bounds.size);
    [self.pathView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Crop image to get rid of bottom toolbar
    CGRect rect = CGRectMake(0, 0, self.pathView.bounds.size.width, self.pathView.bounds.size.height-45);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image1 CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    image1 = cropped;
    
    //Save image to cloud
    NSData *imageData = UIImagePNGRepresentation(image1);
    [self uploadImage:imageData :sender];
}
- (IBAction)cancelDrawing:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
- (IBAction)eraseButtonTapped:(UIButton*)sender
{
    self.pathView.penColor = [UIColor whiteColor];
}*/

- (IBAction)eraseButtonTapped:(id)sender
{
    self.pathView.penColor = [UIColor whiteColor];
}

- (void)uploadImage:(NSData *)imageData :(id)sender
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            PFObject *userPhoto = [PFObject objectWithClassName:@"Drawing"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"User"];
            
            userPhoto[@"Chatroom"] = self.chatroom;
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                if (!error)
                {
                 //   [self refresh:nil];
                    //[self performSegueWithIdentifier:@"dismissDrawView" sender:sender];
                }
                else
                {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];

        }
    }];
    [self performSegueWithIdentifier:@"dismissDrawView" sender:sender];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pathView.penColor = [UIColor blueColor];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"colorPicker"])
    {
        ColorChoiceViewController *colors = segue.destinationViewController;
        
        colors.penColor = self.pathView.penColor;
    }
}

- (IBAction)unwindWithPenColor:(UIStoryboardSegue*)unwindSegue
{
    ColorChoiceViewController *colors = unwindSegue.sourceViewController;
    
    self.pathView.penColor = colors.penColor;
}

@end
