//
//  SEErrorHandler.m
//  Wag-challenge
//
//  Created by Steve Kochan on 12/8/17.
//  Copyright © 2017 Steve Kochan. All rights reserved.
//

#import "SEErrorHandler.h"
#import <UIKit/UIKit.h>

@implementation SEErrorHandler

+(void) reportError: (SE_ERROR_TYPE) errorType {
    switch (errorType) {
        case ERROR_READING_DATA:
        case ERROR_PARSING_DATA:
            [self alertUser: NSLocalizedString(@"networkErrorMsg",
                                               @"There was an error reading data from the network")];
             break;
            
        case ERROR_LOADING_AVATAR:
            //we won't tell the user anything here. Just use a default avatar
            
        case ERROR_BAD_WEBSITE_URL:
            [self alertUser:NSLocalizedString(@"websiteErrorMsg",
                                              @"There's a problem with the supplied website address")];
            
        default:
            break;
    }
}

+(void) alertUser: (NSString *)message {
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController *alert = [UIAlertController
                                  alertControllerWithTitle: NSLocalizedString(@"alert_title", @"Error")
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              topWindow.hidden = YES;
                                                          }];
    
    [alert addAction:defaultAction];

    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
