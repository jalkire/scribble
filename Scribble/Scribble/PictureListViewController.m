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

@property NSArray *wallObjectsArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PictureListViewController

//@synthesize wallObjectsArray = _wallObjectsArray;
//@synthesize scrollView = _scrollView;


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
            self.wallObjectsArray = nil;
            self.wallObjectsArray = [[NSArray alloc] initWithArray:objects];
            
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
    for (PFObject *wallObject in self.wallObjectsArray){
        UIView *PicturesListView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width , 900)];
        
        PFFile *pic = (PFFile *)[wallObject objectForKey:@"imageFile"];
        UIImageView *userPic = [[UIImageView alloc] initWithImage:[UIImage imageWithData:pic.getData]];
        userPic.frame = CGRectMake(0, 0, PicturesListView.frame.size.width, userPic.frame.size.height);
        [PicturesListView addSubview:userPic];
        
        
        [self.scrollView addSubview:PicturesListView];
        
        //put gap between photos
        originY = originY + PicturesListView.frame.size.width + 20;
    }
    
    //set scroll view size
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, originY);
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
