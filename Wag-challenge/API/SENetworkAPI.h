//
//  SENetworkAPI.h
//  Wag-challenge
//
//  Created by Steve Kochan on 12/7/17.
//  Copyright © 2017 Steve Kochan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEUser.h"
#import <UIKit/UIKit.h>

// JSON keys

#define kBadgesKey                @"badge_counts"
#define kBronzeKey                @"bronze"
#define kSilverKey                @"silver"
#define kGoldKey                  @"gold"
#define kWebsiteURLStringKey      @"website_url"
#define kAccountIDKey             @"account_id"
#define kIsEmployeeKey            @"is_employee"
#define kAccountIDKey             @"account_id"
#define kLastAccessDateKey        @"last_access_date"
#define kAgeKey                   @"age"
#define kRepChangeYearKey         @"reputation_change_year"
#define kRepChangeQuarterKey      @"reputation_change_quarter"
#define kRepChangeMonthKey        @"reputation_change_month"
#define kRepChangeWeekKey         @"reputation_change_week"
#define kRepChangeDayKey          @"reputation_change_day"
#define kReputationKey            @"reputation"
#define kCreationDateKey          @"creation_date"
#define kUserTypeKey              @"user_type"
#define kUserIdKey                @"user_id"
#define kAcceptRateKey            @"accept_rate"
#define kLocationKey              @"location"
#define kWebsiteURLKey            @"website_url"
#define kLinkKey                  @"link"
#define kProfileImageKey          @"profile_image"
#define kUserNameKey              @"display_name"
#define kHasMoreKey               @".has_more"

#define kSEUserEndPoint           @"https://api.stackexchange.com/2.2/users?site=stackoverflow"
#define kFilter                   @"&filter=!7dvHcrv7Ekov.gMu-*XCuDZ_zyGXCmM"


@interface SENetworkAPI: NSObject

+ (instancetype) APIManager;

- (void) dataFromNetworkForPage: (NSUInteger) page completion:  (void (^)(NSArray *data)) completion;
+ (NSArray *) usersFromDictionary: (NSDictionary *) results;
- (void) imageForURLString: (NSString *)imageURLString imageView: (UIImageView *)imageView
         activityIndicator: (UIActivityIndicatorView *) activityIndicator;

@end
