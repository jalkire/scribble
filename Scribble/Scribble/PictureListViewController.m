//
//  PictureListViewController.m
//  Scribble
//
//  Created by jalkire on 11/12/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "PictureListViewController.h"
#import "ViewController.h"
#import "Parse/Parse.h"
#import "PathView.h"

@interface PictureListViewController ()

@property NSArray *drawingObjectsArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property UIImage *image;

@end

@implementation PictureListViewController

- (IBAction)editImage:(UITapGestureRecognizer *)sender
{
    [self performSegueWithIdentifier:@"ImageEditor" sender:sender.view];

    
}

- (IBAction)unwindAction:(UIStoryboardSegue*)unwindSegue
{
    [self getPictures];
}

- (void)oneFingerTwoTaps
{
    NSLog(@"Action: One finger, two taps");
}

-(void)getPictures
{
    //make the query for the drawing class
    PFQuery *query = [PFQuery queryWithClassName:@"Drawing"];
    
    //order the query
    [query orderByAscending:@"createdAt"];
    
    //run the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //if successful, clear array and then add the drawings too it
        if (!error) {
            self.drawingObjectsArray = nil;
            self.drawingObjectsArray = [[NSArray alloc] initWithArray:objects];
            
            //go to picture loading method
            [self loadPictures];
        
        //or have an error
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
    
}

-(void)loadPictures
{
    
    //remove old stuff on scroll view
    for (id viewToRemove in [self.scrollView subviews]){
        
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }
    
    //put gap on top
    int startY = 10;
    
    //go through array of photos and add each to scroll view
    for (PFObject *drawingObject in self.drawingObjectsArray){
        //only if the drawings' chatroom attributes match the current chatroom
        if ([drawingObject[@"Chatroom"] isEqualToString:self.chatroom])
        {
        //Make  uiview object that will be put in scroll view
        UIView *PicturesListView = [[UIView alloc] initWithFrame:CGRectMake(0, startY, self.view.frame.size.width , 900)];
        
        //take the picture
        PFFile *pic = (PFFile *)[drawingObject objectForKey:@"imageFile"];
        
        //and put it in a frame, reducing its size and centering
        UIImageView *userPic = [[UIImageView alloc] initWithImage:[UIImage imageWithData:pic.getData]];
        userPic.frame = CGRectMake(PicturesListView.frame.size.width/6, 30, PicturesListView.frame.size.width/1.5, userPic.frame.size.height/1.5);

        //put shadows under the photo
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:userPic.bounds];
        userPic.layer.shadowOffset = CGSizeMake(0, 1);
        userPic.layer.shadowOpacity = .5;
        userPic.layer.shadowColor = [UIColor groupTableViewBackgroundColor].CGColor;
        userPic.layer.shadowRadius = 1.0;
        userPic.clipsToBounds = NO;
        userPic.layer.masksToBounds = NO;
        userPic.layer.shadowPath = shadowPath.CGPath;

            
        //add picture to uiview
        [PicturesListView addSubview:userPic];
            
            // Create gesture recognizer
            UITapGestureRecognizer *oneFingerTwoTaps =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (editImage:)];
            
            // Set required taps and number of touches
            [oneFingerTwoTaps setNumberOfTapsRequired:2];
            [oneFingerTwoTaps setNumberOfTouchesRequired:1];
            
            // Add the gesture to the view
            [userPic addGestureRecognizer:oneFingerTwoTaps];
            userPic.userInteractionEnabled = YES;
            
           

        //take the date and time that the picture was uploaded at
        NSDate *creationDate = drawingObject.createdAt;
        
        //set stamp position to top left corner of photo
        UILabel *nameStamp = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, PicturesListView.frame.size.width,15)];
        UILabel *timeStamp = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, PicturesListView.frame.size.width,15)];

        //query for current drawing
        PFQuery *userQuery = [PFQuery queryWithClassName:@"Drawing"];
        [userQuery includeKey:@"User"];
        [userQuery whereKey:@"objectId" equalTo:drawingObject.objectId];
        PFObject *drawObject = [userQuery getFirstObject];
    
        //get current user and user object associated with drawing
        PFUser *currentUser = [PFUser currentUser];
        PFUser *photoUser = [drawObject objectForKey:@"User"];
        
        //if it is the current user's photo, move the stampts to the right corner
        if (currentUser.objectId == photoUser.objectId){
            nameStamp = [[UILabel alloc] initWithFrame:CGRectMake(PicturesListView.frame.size.width-90, 0, PicturesListView.frame.size.width,15)];
            timeStamp = [[UILabel alloc] initWithFrame:CGRectMake(PicturesListView.frame.size.width-90, 13, PicturesListView.frame.size.width,15)];
        }
        //set stamps' text to have username and datetime
        nameStamp.text = [NSString stringWithFormat:@"%@", photoUser.username];
        timeStamp.text = [NSString stringWithFormat:@"%@", [self relativeDate:creationDate]];

        //set stamp formatting
        nameStamp.font = [UIFont boldSystemFontOfSize:14];
        timeStamp.font = [UIFont italicSystemFontOfSize:12];

        //add the time and name stamps to uiview
        [PicturesListView addSubview:nameStamp];
        [PicturesListView addSubview:timeStamp];
        
        //add the uiview to the scrollview
        [self.scrollView addSubview:PicturesListView];
        
        //put gap between photos
        startY = startY + userPic.frame.size.height + 60;
        }
            }
    
    if (startY != 10){
    //set scroll view size
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, startY);
    
    //scroll to bottom
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:NO];
    
    //if no drawings have been loaded
    }else{
        //make a uiview
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, startY, self.view.frame.size.width , 900)];
        
        //make a label
        UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.view.frame.size.width,15)];
        
        //set it to say no drawings
        emptyLabel.text = [NSString stringWithFormat:@"No drawings yet! Press Draw below to add your own!"];
        emptyLabel.font = [UIFont italicSystemFontOfSize:12];
        
        //put the label on the uiview
        [labelView addSubview:emptyLabel];
        
        //and put the uiview on the scrollview
        [self.scrollView addSubview:labelView];
    }
}


-(NSString *)relativeDate:(NSDate *)baseDate {
    
    //Get today's date
    NSDate *todayDate = [NSDate date];
    
    //Compute a double set the the time since now and the date pased into the method
    double timeSince = [baseDate timeIntervalSinceDate:todayDate];
    timeSince = timeSince * -1;
    
    //use a series of if statements to return time since with proper phrasing
    if(timeSince < 1) {
    	return @"just now";
    } else 	if (timeSince < 60) {
    	return @"less than a minute ago";
    } else if (timeSince < 3600) {
    	int diff = round(timeSince / 60);
    	return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (timeSince < 86400) {
    	int diff = round(timeSince / 60 / 60);
    	return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (timeSince < 518400) {
    	int diff = round(timeSince / 60 / 60 / 24);
    	return[NSString stringWithFormat:@"%d days ago", diff];
        
    //if the date passed to the method is more than 6 days old
    } else {
        //initialize a dateformatter set to 12 November type formatting
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"d MMMM"];
        //and return the date in this format
    	return [df stringFromDate:baseDate];
    }
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
    
    for (id viewToRemove in [self.scrollView subviews]){
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }
    
    //get the pictures
    [self getPictures];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"displayDrawView"])
    {
        ViewController *drawView = segue.destinationViewController;
        
        drawView.chatroom = self.chatroom;
    }
    
    else if ([segue.identifier isEqualToString:@"ImageEditor"])
    {
        ViewController *drawView = segue.destinationViewController;
        UIImageView *imageview = sender;
        drawView.chatroom = self.chatroom;
        
        drawView.backgroundImage = imageview.image;
        //[drawView.pathView setBackgroundColor:[UIColor colorWithPatternImage:self.image]];
    }
}
- (IBAction)refreshed:(UIBarButtonItem *)sender {
    //get the pictures
    [self getPictures];
}

@end
