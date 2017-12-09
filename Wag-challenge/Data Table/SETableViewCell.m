//
//  SETableViewCell.m
//  Wag-challenge
//
//  Created by Steve Kochan on 12/7/17.
//  Copyright © 2017 Steve Kochan. All rights reserved.
//

#import "SETableViewCell.h"
#import "SEErrorHandler.h"

@implementation SETableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)websiteButtonPressed:(UIButton *)sender {
    NSURL *webPage = [NSURL URLWithString: sender.titleLabel.text];
    
    if (!webPage) {
        [SEErrorHandler reportError: ERROR_BAD_WEBSITE_URL];
    }
    else if (self.delegate && [self.delegate respondsToSelector: @selector(showWebPage:)]) {
        [self.delegate showWebPage: webPage];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.website.enabled = YES;
    [self.website setTitle:@"" forState:UIControlStateNormal];
}

@end
