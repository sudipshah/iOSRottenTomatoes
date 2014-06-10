//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Sudip Shah on 6/4/14.
//  Copyright (c) 2014 Sudip. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
#import "MovieDetailsController.h"
#import "MBProgressHud.h"

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;

//header animation properties
@property (strong,nonatomic) UIWindow *dropdown;
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIWindow *win;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Creating a HUD
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.dimBackground = YES;
    hud.delegate = self; // Need help removing this warning!
    hud.labelText = @"Loading...";
    [hud show:YES];
    
    //Creating a error message
    self.dropdown = [[UIWindow alloc] initWithFrame:CGRectMake(0, -20, 320, 20)];
    self.dropdown.backgroundColor = [UIColor redColor];
    self.label = [[UILabel alloc] initWithFrame:self.dropdown.bounds];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.backgroundColor = [UIColor clearColor];
    [self.dropdown addSubview:self.label];
    self.dropdown.windowLevel = UIWindowLevelStatusBar;
    [self.dropdown makeKeyAndVisible];
    [self.dropdown resignKeyWindow];
    
    
    // Async request from Rotten Tomatoes API
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.rottenTomatoesAPI]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        self.movies = responseObject[@"movies"];
        [self.tableView reloadData];
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self animateHeaderViewWithText:[error localizedDescription]];

//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Movies"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
        
        [hud hide:YES];
    }];
    
    [operation start];
    
    
    // Registering the Cell View
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    self.tableView.rowHeight = 110;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//header animation
-(void)animateHeaderViewWithText:(NSString *) text {
    self.label.text = text;
    
    [UIView animateWithDuration:.5 delay:0 options:0 animations:^{
        self.dropdown.frame = CGRectMake(0, 0, 320, 20);
    }completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:2 options:0 animations:^{
            self.dropdown.frame = CGRectMake(0, -20, 320, 20);
        } completion:^(BOOL finished) {
            
            //animation finished!!!
        }];
        ;
    }];
}



#pragma mark - table view methods

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"CellForRowAtIndexPath: %ld", (long)indexPath.row);
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    //NSLog(@"%@", movie);
    cell.movieTitleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *imageURLString = movie[@"posters"][@"thumbnail"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    [cell.posterView setImageWithURL:imageURL];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MovieDetailsController *mdc = [[MovieDetailsController alloc] initWithNibName:@"MovieDetailsController" bundle:nil];
    
    NSDictionary *movie = self.movies[indexPath.row];
    mdc.title = movie[@"title"];
    
    mdc.movieDescription = movie[@"synopsis"];
    //[mdc.movieDescriptionText setText:movie[@"synopsis"]];
    
    NSString *imageURLString = movie[@"posters"][@"original"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    mdc.imageURL = imageURL;
    //[mdc.posterBigImage setImageWithURL:imageURL];
    
    [self.navigationController pushViewController:mdc animated:YES];
    
}



@end
