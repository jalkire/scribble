//
//  ViewController.h
//  Scribble
//
//  Created by Tyler Dahl on 10/31/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PathView.h"

@interface ViewController : UIViewController

@property NSString *chatroom;
@property (strong, nonatomic) IBOutlet PathView *pathView;

- (void)uploadImage:(NSData *)imageData :(id)sender;
@property UIImage *backgroundImage;

@end
