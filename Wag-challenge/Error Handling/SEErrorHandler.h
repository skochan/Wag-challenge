//
//  SEErrorHandler.h
//  Wag-challenge
//
//  Created by Steve Kochan on 12/8/17.
//  Copyright © 2017 Steve Kochan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SE_ERROR_TYPE) {
    ERROR_READING_DATA,
    ERROR_PARSING_DATA,
    ERROR_LOADING_AVATAR,
    ERROR_BAD_WEBSITE_URL
};

@interface SEErrorHandler : NSObject
+(void) reportError: (SE_ERROR_TYPE) errorType;
+(void) alertUser: (NSString *)message;

@end
