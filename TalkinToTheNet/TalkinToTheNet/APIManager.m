//
//  APIManager.m
//  LearnAPI
//
//  Created by Kaisha Jones on 9/20/15.
//  Copyright © 2015 Kaisha Jones. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager


// create a data task method. completely stateless, not going to maniupulate anything outside of it
// completion handler is the actual blokc that we are passing. 

+ (void)GETRequestWithURL:(NSURL *)URL
// makes it a class method, we don't have to alloc init it
        completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error)) completionHandler {
    
// this accesses the shared session
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
// I think this creates a data task to execute a api request. By default this happens on a background thread
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", data);
// this moves us back to the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(data, response, error);
        });
    }];
// this begins the task :)
    [task resume];
    
}


@end
