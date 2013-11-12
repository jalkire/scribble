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
