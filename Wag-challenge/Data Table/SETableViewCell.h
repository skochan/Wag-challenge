//
//  SETableViewCell.h
//  Wag-challenge
//
//  Created by Steve Kochan on 12/7/17.
//  Copyright © 2017 Steve Kochan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellHeight 87

@protocol ShowWebPageDelegate <NSObject>
-(void) showWebPage: (NSURL *) webPageURL;
@end


@interface SETableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *goldLabel;
@property (strong, nonatomic) IBOutlet UILabel *silverLabel;
@property (strong, nonatomic) IBOutlet UILabel *bronzeLabel;
@property (strong, nonatomic) IBOutlet UILabel *reputation;
@property (strong, nonatomic) IBOutlet UIButton *website;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) id <ShowWebPageDelegate> delegate;

@end



