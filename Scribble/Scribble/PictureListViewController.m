//
//  PictureListViewController.m
//  Scribble
//
//  Created by jalkire on 11/12/13.
//  Copyright (c) 2013 SketchySix. All rights reserved.
//

#import "PictureListViewController.h"
#import "Parse/Parse.h"

@interface PictureListViewController ()

@property NSArray *drawingObjectsArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PictureListViewController


- (IBAction)unwindAction:(UIStoryboardSegue*)unwindSegue
{
    [self getPictures];
}

-(void)getPictures
{
    //make the query for the drawing class
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    
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
    int originY = 0;
    
    //go through array of photos and add each to scroll view
    for (PFObject *drawingObject in self.drawingObjectsArray){
        //Make  uiview object that will be put in scroll view
        UIView *PicturesListView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.frame.size.width , 900)];
        
        //take the picture
        PFFile *pic = (PFFile *)[drawingObject objectForKey:@"imageFile"];
        
        //and put it in a frame, reducing its size and centering
        UIImageView *userPic = [[UIImageView alloc] initWithImage:[UIImage imageWithData:pic.getData]];
        userPic.frame = CGRectMake(PicturesListView.frame.size.width/6, 15, PicturesListView.frame.size.width/1.5, userPic.frame.size.height/2);

        //add picture to uiview
        [PicturesListView addSubview:userPic];

        //take the date and time that the picture was uploaded at
        NSDate *creationDate = drawingObject.createdAt;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"h:mm a EEEE"];
        
        //and render it in top right corner of photo
        
        UILabel *timeStamp = [[UILabel alloc] initWithFrame:CGRectMake(PicturesListView.frame.size.width-80, 0, PicturesListView.frame.size.width,15)];
        //ready to take username from picture object: timeStamp.text = [NSString stringWithFormat:@"%@, %@", [drawingObject objectForKey:@"user"], [df stringFromDate:creationDate]];
        
        timeStamp.text = [NSString stringWithFormat:@"%@", [df stringFromDate:creationDate]];
        timeStamp.font = [UIFont italicSystemFontOfSize:9];

        //add the timestamp to uiview
        [PicturesListView addSubview:timeStamp];
        
        //add the uiview to the scrollview
        [self.scrollView addSubview:PicturesListView];
        
        //put gap between photos
        originY = originY + userPic.frame.size.height + 40;
    }
    
    //set scroll view size
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, originY);
    
    //scroll to bottom
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //remove old stuff from scroll view
    [super viewWillAppear:animated];

    for (id viewToRemove in [self.scrollView subviews]){
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }
    
    //get the pictures
    [self getPictures];
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
