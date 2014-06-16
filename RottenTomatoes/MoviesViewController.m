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


@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSArray *searchResults;

//header animation properties
@property (strong,nonatomic) UIWindow *dropdown;
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIWindow *win;
@property UIRefreshControl *refreshControl;

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
    
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;   

            
    //Creating a error message, instead of using UIAlert
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
    
    
    // Pull to refresh
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshMoviesList) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    
    // Do async call using AFNetworking
    [self refreshMoviesList];
    
    // Registering the Cell View
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    //self.tableView.rowHeight = 110;

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


-(void) refreshMoviesList {
    
    //Creating a HUD
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.labelText = @"Loading...";
    [hud show:YES];
    
    // Async request from Rotten Tomatoes API
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.rottenTomatoesAPI]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", responseObject);
        self.movies = responseObject[@"movies"];
        [self.tableView reloadData];
        [hud hide:YES];
        [self.refreshControl endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self animateHeaderViewWithText:[error localizedDescription]];
        
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Movies"
        //                                                            message:[error localizedDescription]
        //                                                           delegate:nil
        //                                                  cancelButtonTitle:@"Ok"
        //                                                  otherButtonTitles:nil];
        //        [alertView show];
        
        [hud hide:YES];
        [self.refreshControl endRefreshing];
    }];
    
    [operation start];
    
}


#pragma mark - table view methods

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        
        //NSLog(@"In Search");
        return [self.searchResults count];
    }
    else {
        
        return [self.movies count];
    }

    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"CellForRowAtIndexPath: %ld", (long)indexPath.row);
    //NSLog(@"The movies object: \n %@", self.movies);
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"In Search");
        movie = self.searchResults[indexPath.row];
        NSLog(@"The movie:%@", movie );
    }
    else {
        NSLog(@"The movie:%@", self.movies[indexPath.row] );
        movie = self.movies[indexPath.row];
    }

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
    mdc.movieTitle = movie[@"title"];
    //[mdc.movieDescriptionText setText:movie[@"synopsis"]];
    
    NSString *imageURLString = movie[@"posters"][@"original"];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    mdc.imageURL = imageURL;
    //[mdc.posterBigImage setImageWithURL:imageURL];
    
    [self.navigationController pushViewController:mdc animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
    
}

#pragma mark - Search functions

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    
    //NSLog(@"Trying");
    //NSLog(@"The movies object: \n %@", self.movies);
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title beginswith[c] %@", searchText];
    self.searchResults = [self.movies filteredArrayUsingPredicate:resultPredicate];
    NSLog(@" Search Results %@", self.searchResults);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}


@end
