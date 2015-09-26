//
//  DetailViewController.h
//  TalkinToTheNet
//
//  Created by Kaisha Jones on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FourSquareSearchResult.h"
#import "APIManager.h"
#import "LocationFinderViewController.h"

@interface DetailViewController : UIViewController



@property (nonatomic) FourSquareSearchResult *dataTransfered;
@end
