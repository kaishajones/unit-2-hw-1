//
//  LocationFinderViewController.m
//  TalkinToTheNet
//
//  Created by Kaisha Jones on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "LocationFinderViewController.h"
#import "FourSquareSearchResult.h"
#import "DetailViewController.h"
#import "APIManager.h"

@interface LocationFinderViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) NSString *searchWords;

@end

@implementation LocationFinderViewController

#pragma mark - setup for the view


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // this is where we connect the delegates
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.searchTextField.delegate = self;
}


#pragma mark - FourSquare API Request
- (void)makeNewFourSquareAPIRequestWithSearchTerm: (NSString *)searchTerm // pass four square search term
                                    callbackBlock:(void(^)())block { // call block
    
    // search terms via url
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=M1KDUWRS5OBWUNQCXHHF23TAUEG2YOB0RXGBSP0LBVRCX2XL&client_secret=FWTAPZOJ4UBPUXX2R5Q1D5F3X0HXMCSMERWL4DJFW3UA33YX&v=20150919&ll=40.7,-74&query=%@", searchTerm];
    
    self.searchWords = searchTerm;
    
    //self.searchWords = searchTerm;
    //NSLog(@"%@", self.searchWords);
    
    
    // &ll=40.7,-74 = latitude/longitude
    
    // encode url strings (so you can search for more than one word with spaces!)
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // NSLog(@"%@", encodedString); // test it!
    
    // convert urlString to url
    NSURL *url = [NSURL URLWithString:encodedString];
    
    // make the request
    [APIManager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:nil];
            
            // NSLog(@"%@", json); and log dictionary to test
            
            NSArray *venues = [[json objectForKey:@"response"] objectForKey:@"venues"];
            
            //  NSLog(@"%@", venues);
            
            self.searchResults = [[NSMutableArray alloc]init]; // initialize storage for array
            
            for (NSDictionary *venue in venues) { // creating a loop
                
                NSString *establishmentName = [venue objectForKey:@"name"]; // grab info from dictionary
                NSString *establishmentLocation = [venue objectForKey:@"location"];
                
                NSString *address = [establishmentLocation valueForKey:@"address"];
                NSString *city = [establishmentLocation valueForKey:@"city"];
                NSString *state = [establishmentLocation valueForKey:@"state"];
                
                NSString *distance = [venueLocation valueForKey:@"distance"];   // get the distance
                
                // convert string into double to calculate miles
                double distanceConvertedToDouble = [distance doubleValue];
                double metersInAMile = 1000.00;
                double distanceInMiles = distanceConvertedToDouble / metersInAMile;
                // NSLog(@"%.2f", distanceInMiles);
                
                // then we convert it back to a string
                NSString *stringInMiles = [NSString stringWithFormat:@"%.2f", distanceInMiles];
                
                // NSLog(@"%@", stringInMiles); we test to see if its working
                
                // this should include all results even the ones missing from address
                if (address == nil){
                    address = @"";
                }
                if (city == nil){
                    city = @"";
                }
                
                FourSquareSearchResult *resultsObject = [[FourSquareSearchResult alloc]init];
                
                resultsObject.barsName = establishmentName;
                resultsObject.barsAddress = [NSString stringWithFormat:@"%@, %@, %@", address, city, state];
                resultsObject.barsDistance = [NSString stringWithFormat:@"distance: %@ miles", stringInMiles];
                resultsObject.barsSearchTerm = self.searchWords;
                
                [self.searchResults addObject:resultsObject];
            }
            block();
        }
    }];
}

#pragma mark - uitextField method


- (BOOL)textFieldShouldReturn:(UITextField *)textField { // when return button on keyboard is pressed...
    
    [self.view endEditing:YES]; // end editing + dismiss keyboard
    
    [self makeNewFourSquareAPIRequestWithSearchTerm:textField.text callbackBlock:^{ //make an API request
        
        [self.listTableView reloadData]; // reload table data
    }];
    return YES;
}

#pragma mark - tableView setup methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    FourSquareSearchResult *currentResult = self.searchResults[indexPath.row];
    
    cell.textLabel.text = currentResult.barsName;
    cell.detailTextLabel.text = currentResult.barsDistance;
    
    return cell;
}

#pragma mark - prepareForSegue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //  if ([segue.identifier isEqualToString:@"showDetailViewControllerIdentifier"]) { // reference segue title
   // where we pass the data 
    NSIndexPath *myIndexPath = [self.listTableView indexPathForSelectedRow];
    FourSquareSearchResult *dataTransfer = self.searchResults[myIndexPath.row];
    DetailViewController *dvc = segue.destinationViewController; // reference to detail view controller
    dvc.dataPassed = dataTransfer;
}

@end
