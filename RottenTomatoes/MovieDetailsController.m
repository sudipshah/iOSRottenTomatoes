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

@property (weak, nonatomic) IBOutlet UILabel *movieDescriptionLabel;

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
    
    //[self.posterBigImage setImageWithURL:self.imageURL placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [self.posterBigImage setImageWithURLRequest:[NSURLRequest requestWithURL:self.imageURL] placeholderImage:[UIImage imageNamed:@"placeholderImage"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView transitionWithView:self.posterBigImage duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.posterBigImage.image = image;
        } completion:nil];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    NSString * text = [[NSString alloc] initWithFormat:@" \n %@ \n \n %@ \n ", self.movieTitle, self.movieDescription];
    
    [self.movieDescriptionLabel setText:text];
    
    [self.movieDescriptionLabel sizeToFit];

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
