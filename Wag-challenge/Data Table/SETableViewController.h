//
//  SETableViewController.h
//  Wag-challenge
//
//  Created by Steve Kochan on 12/7/17.
//  Copyright © 2017 Steve Kochan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SETableViewCell.h"
@import SafariServices;

@interface SETableViewController : UITableViewController <ShowWebPageDelegate, SFSafariViewControllerDelegate>

@end

