//
//  MovieDetailsController.h
//  RottenTomatoes
//
//  Created by Sudip Shah on 6/7/14.
//  Copyright (c) 2014 Sudip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailsController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property NSURL * imageURL;
@property NSString *movieDescription;
@property NSString *movieTitle;

@end
