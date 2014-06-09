//
//  MovieDetailsController.m
//  RottenTomatoes
//
//  Created by Sudip Shah on 6/7/14.
//  Copyright (c) 2014 Sudip. All rights reserved.
//

#import "MovieDetailsController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailsController ()

@property (strong, nonatomic) IBOutlet UIImageView *posterBigImage;
@property (strong, nonatomic) IBOutlet UITextView *movieDescriptionText;


@end

@implementation MovieDetailsController

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
    //NSLog(@"Something happened");
    //NSLog(@"Description: %@", self.movieDescription);
    self.movieDescriptionText.delegate = self;
    [self.posterBigImage setImageWithURL:self.imageURL];
    [self.movieDescriptionText setText:self.movieDescription];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Function for making sure that keyboard doesn't appear when clicking on text field
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
