//
//  DetailViewController.m
//  TalkinToTheNet
//
//  Created by Kaisha Jones on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *barNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;

//@property (nonatomic) NSString *searchResults;
@property (nonatomic) IBOutlet UILabel *dataLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.barNameLabel.text = self.dataTransfered.barsName;
    self.addressLabel.text = self.dataTransfered.barsAddress;
    self.detailsLabel.text = self.dataTransfered.barsDistance;
    
    [self makeNewInstagramAPIRequestWithSearchTerm: self.dataTransfered.barsSearchTerm callbackBlock:^{
        [self.dataLabel reloadInputViews];
    }];
    
}

#pragma mark - Instagram API Request
- (void)makeNewInstagramAPIRequestWithSearchTerm: (NSString *)searchTerm // pass four square search term
                                   callbackBlock:(void(^)())block { // call block
    
    // search terms via url
    NSString *instagramURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=ac0ee52ebb154199bfabfb15b498c067", searchTerm];
    
    NSString *encodedString = [instagramURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; // encode string so that it can pass more than one word
    
    // test
    NSLog(@"my second api url: %@", encodedString);
    
    // convert to a url
    NSURL *url = [NSURL URLWithString:encodedString];
    
    // for some reason part fails :(
    [APIManager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *establishments = [[json objectForKey:@"data"] objectForKey:@"link"];
            
            NSLog(@"%@", establishments);
            
        }
        block();
    }];
}



@end
