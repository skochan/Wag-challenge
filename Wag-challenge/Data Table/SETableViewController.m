//
//  SETableViewController.m
//  Wag-challenge
//
//  Created by Steve Kochan on 12/7/17.
//  Copyright © 2017 Steve Kochan. All rights reserved.
//

#import "SETableViewController.h"
#import "SENetworkAPI.h"

@interface SETableViewController ()

@property (nonatomic, retain) NSArray *userData;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation SETableViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"StackOverflow Users";
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
    if (self.userData.count == 0) { // api still active
        self.overlayView.frame = self.tableView.frame;
        [self.tableView addSubview:self.overlayView];
        [self.loadingIndicator startAnimating];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - load data into tables

- (void) getData {

    [SENetworkAPI.APIManager dataFromNetworkForPage: 1 completion: ^(NSArray *users) {
        if (users) {
            self.userData = users;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.loadingIndicator stopAnimating];
                [self.overlayView removeFromSuperview];
            });
        }
    }];
}

#pragma mark - Table View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userData.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SETableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SETableViewCellID" forIndexPath:indexPath];
    
    // Note for additional data:  A check can be made here to see if indexPath is "near" the end of the data
    // and if it is,the API call can be made to fetch the next page(s) of data
    // This logic can also be handled by a scroll view delegate that can check the direction of the scrolling as well
    
    [self tableView: tableView configureCell: cell atIndexPath: indexPath];
    
    return cell;
}

#pragma  mark - cell configuration

- (UITableViewCell *) tableView: (UITableView *)tableView configureCell: (SETableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    SEUser *userData = self.userData[indexPath.row];
    
    [SENetworkAPI.APIManager imageForURLString: userData.avatarURLString imageView: cell.avatarImageView
                             activityIndicator:cell.activityIndicator];
    
    cell.userName.text = userData.userName;
    cell.goldLabel.text = [userData.badges[@"gold"] stringValue];
    cell.silverLabel.text = [userData.badges[@"silver"] stringValue];
    cell.bronzeLabel.text = [userData.badges[@"bronze"] stringValue];
    
    if (userData.websiteURLString.length > 5) {
        [cell.website setTitle: userData.websiteURLString forState: UIControlStateNormal];
    }
    else {
        cell.website.enabled = false;
    }
    
    cell.delegate = self;
    
    NSUInteger rep = [userData.reputation unsignedLongValue];
    if (rep > 1000) {
        cell.reputation.text = [NSString stringWithFormat: @"%.1fk", rep / 1000.];
    }
    else {
        cell.reputation.text = [userData.reputation stringValue];
    }
    return cell;
}

#pragma mark - Delegate callbacks

-(void) showWebPage: (NSURL *) webPageURL {
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:webPageURL entersReaderIfAvailable:NO];
    safariVC.delegate = self;
    [self presentViewController:safariVC animated:NO completion:nil];
}

-(void) safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:nil];
}

@end
