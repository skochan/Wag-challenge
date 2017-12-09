//
//  SEUser.m
//  Wag-challenge
//
//  Created by Steve Kochan on 12/7/17.
//  Copyright © 2017 Steve Kochan. All rights reserved.
//

#import "SEUser.h"

@implementation SEUser

// Note: if the filter changes, more data can be extracted and the user model extended
// Can also make this recursive
// TODO:  Check for valid URL strings here

+ (SEUser *) userFromDict: (NSDictionary *) userDict {
    SEUser *user = [SEUser new];
    
    Class  stringClass = NSString.class;
    Class  numberClass = NSNumber.class;
    Class  dictClass = NSDictionary.class;
    
    NSDictionary *requiredValues = @{
                                kUserNameKey: stringClass,
                                kProfileImageKey: stringClass,
                                kReputationKey: numberClass,
                                kBadgesKey: dictClass
                                };
    
    NSDictionary *optionalValues = @{kWebsiteURLKey: stringClass};
    
    NSDictionary *requiredBadgesDictValues = @{
                                kBronzeKey: numberClass,
                                kSilverKey: numberClass,
                                kGoldKey: numberClass
                                };
    
    id key;
    
    for (key in requiredValues) {
        id obj = userDict[key];
        if (!obj  ||
             ![obj isKindOfClass: [requiredValues objectForKey:key]]) {
             return nil;
        }
    }
    
    // Here optional just means it's not required, but if it is specified it needs to
    // be of the correct type
    
    for (key in optionalValues) {
        id obj = userDict[key];
        if (obj && ![obj isKindOfClass: [optionalValues objectForKey:key]]) {
            return nil;
        }
    }
    
    NSDictionary *badgesDict = userDict[kBadgesKey];
    for (key in requiredBadgesDictValues) {
        id obj = badgesDict[key];
        if (!obj  ||
            ![obj isKindOfClass: [requiredBadgesDictValues objectForKey:key]]) {
            return nil;
        }
    }
    
    // data types are ok, let's move forward
    
    user.userName = userDict[kUserNameKey];
    user.avatarURLString = userDict[kProfileImageKey];
    user.badges = userDict[kBadgesKey];
    user.reputation = userDict[kReputationKey];
    user.websiteURLString = userDict[kWebsiteURLKey];

    return user;
}

@end
