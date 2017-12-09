//
//  SEUser.h
//  Wag-challenge
//
//  Created by Steve Kochan on 12/7/17.
//  Copyright © 2017 Steve Kochan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SENetworkAPI.h"

@interface SEUser : NSObject

@property (nonatomic, retain) NSDictionary *badges;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *avatarURLString;
@property (nonatomic, retain) NSString *websiteURLString;
@property (nonatomic, assign) NSNumber *reputation;

+ (SEUser *) userFromDict: (NSDictionary *) userDict;


@end
