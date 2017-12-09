//
//  SENetworkAPI.m
//  Wag-challenge
//
//  Created by Steve Kochan on 12/7/17.
//  Copyright © 2017 Steve Kochan. All rights reserved.
//

#import "SENetworkAPI.h"
#import "SEErrorHandler.h"


// Get data from the stack exchange API endpoint.
// Each record looks similar to this (using the filter -- see below):

/*
 {
 "items":[
 {
     "badge_counts":{
         "bronze":8036,
         "silver":7320,
         "gold":600
     },
     "reputation":991431,
     "website_url":"http://csharpindepth.com",
     "profile_image":"https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=128&d=identicon&r=PG",
     "display_name":"Jon Skeet"
 },
 ...
 }

 A filter was created to limit the amount of data returned.  ref: https://api.stackexchange.com/docs/create-filter
 
 */

@interface SENetworkAPI ()

@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, retain) NSURL *seURL;
@property (nonatomic, retain) NSURLSession *session;
@property (nonatomic, retain) NSURL *documentsDirectoryURL;
@end


@implementation SENetworkAPI

+(instancetype) APIManager {
    static SENetworkAPI *APIManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        APIManager = [[self alloc] init];
    });
    
    return APIManager;
}

+ (NSArray *) usersFromDictionary: (NSDictionary *) jsonDict {
    NSMutableArray *userData = [NSMutableArray new];
    NSArray *results = jsonDict[@"items"];
    
    for (NSDictionary *userDict in results) {
        SEUser *user = [SEUser userFromDict: userDict];
        
        if (user) {
            [userData addObject: user];
        }
    }
    return [userData copy];
}

- (void) initSessionForPage: (NSUInteger) page {
    NSString *finalPath = [NSString stringWithFormat: @"%@&page=%lu%@", kSEUserEndPoint, (unsigned long)page, kFilter];
    self.seURL = [NSURL URLWithString: finalPath];
    
    if (! self.session) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSArray *paths = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains: NSUserDomainMask];
        self.documentsDirectoryURL = paths[0];
    }
}

- (void) dataFromNetworkForPage: (NSUInteger) page completion:  (void (^)(NSArray *data)) completion {
    [self initSessionForPage: page];
    
    [[self.session dataTaskWithURL:self.seURL
            completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"RESPONSE: %@",response);
                NSLog(@"DATA: %@",data);
            
                if (!error) {
                    // Success
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                        
                        if (jsonError) {
                            // Error Parsing JSON
                            completion(nil);
                        } else {
                            NSLog(@"%@", jsonResponse);
                            NSArray *users = [SENetworkAPI usersFromDictionary:jsonResponse];
                            completion(users);
                        }
                    }  else {
                        //server is returning an error
                        completion(nil);
                    }
                } else {
                    NSLog(@"error : %@", error.description);
                    completion(nil);

                }
            }]
     resume];
    
}

- (void) imageForURLString: (NSString *)imageURLString imageView: (UIImageView *)imageView
         activityIndicator: (UIActivityIndicatorView *) activityIndicator{
    [activityIndicator startAnimating];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    if (!imageURL) {
        return;   // No need to tell the user
    }
    
    // See if we have the file cached on disk
    NSString *lastPart = imageURLString.lastPathComponent;
    NSURL *fileLocation = [self.documentsDirectoryURL URLByAppendingPathComponent:lastPart];
    NSError *error = nil;
    
    NSData *imageData = [NSData dataWithContentsOfURL: fileLocation options:0 error: &error];
    
    if (imageData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = [UIImage imageWithData:imageData];
            NSLog (@"read the file from disk: %@", fileLocation);
            [activityIndicator stopAnimating];
        });
        return;
    }
    
    // We'll try the URL, even if we tried to get it off disk and the read failed
    
    [[self.session downloadTaskWithURL:imageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            [SEErrorHandler reportError: ERROR_LOADING_AVATAR];  // prob better off just using a default avatar here
            NSLog(@"%@",[error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityIndicator stopAnimating];
            });
        } else {
            NSError *openDataError = nil;
            NSData *downloadedData = [NSData dataWithContentsOfURL:location
                                                           options:kNilOptions
                                                             error:&openDataError];
            if (openDataError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // tell the user?   Nah
                    NSLog(@"%@",[openDataError localizedDescription]);
                    [activityIndicator stopAnimating];
                });
            } else {
                [downloadedData writeToURL:fileLocation
                                    options:NSDataWritingAtomic
                                      error:&error];
                
                NSLog (@"saved the file to disk: %@", fileLocation);

                //TODO:  check return value and possibly alert the user on error
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = [UIImage imageWithData:downloadedData];
                    [activityIndicator stopAnimating];
                });
            }
        }
    }]
     resume];
}


@end
