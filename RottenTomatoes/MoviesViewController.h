//
//  MoviesViewController.h
//  RottenTomatoes
//
//  Created by Sudip Shah on 6/4/14.
//  Copyright (c) 2014 Sudip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHud.h"

@interface MoviesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property NSString * rottenTomatoesAPI;

@end
