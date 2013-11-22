//
//  ColorChoiceViewController.m
//  Scribble
//
//  Created by Karis Russell on 11/21/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "ColorChoiceViewController.h"
//#import "PathView.h"


@interface ColorChoiceViewController ()
//@property (strong, nonatomic) IBOutlet PathView *pathView;


@end

@implementation ColorChoiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)blackButtonTapped:(UIButton*)sender
{
    self.penColor = [UIColor blackColor];
    [self performSegueWithIdentifier: @"colorExit" sender:self];
}

- (IBAction)redButtonTapped:(UIButton*)sender
{
    self.penColor = [UIColor redColor];
    [self performSegueWithIdentifier: @"colorExit" sender:self];
}

- (IBAction)orangeButtonTapped:(UIButton *)sender
{
    self.penColor = [UIColor orangeColor];
    [self performSegueWithIdentifier: @"colorExit" sender:self];
}

- (IBAction)yellowButtonTapped:(UIButton *)sender
{
    self.penColor = [UIColor yellowColor];
    [self performSegueWithIdentifier: @"colorExit" sender:self];
}

- (IBAction)greenButtonTapped:(UIButton *)sender
{
    self.penColor = [UIColor greenColor];
    [self performSegueWithIdentifier: @"colorExit" sender:self];
}

- (IBAction)blueButtonTapped:(UIButton *)sender
{
    self.penColor = [UIColor blueColor];
    [self performSegueWithIdentifier: @"colorExit" sender:self];
}

- (IBAction)purpleButtonTapped:(UIButton *)sender
{
    self.penColor = [UIColor purpleColor];
   [self performSegueWithIdentifier: @"colorExit" sender:self];
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
