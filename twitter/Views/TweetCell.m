//
//  TweetCell.m
//  twitter
//
//  Created by Miles Olson on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "UIImageView+AFNetworking.h"

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"
#import "User.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profPicImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profPicImageView setUserInteractionEnabled:YES];
    self.profPicImageView.layer.cornerRadius = self.profPicImageView.frame.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.tweetLabel.text = tweet.text;
    [self.tweetLabel sizeToFit];
    self.handleLabel.text = tweet.user.name;
    self.nameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.createdAtLabel.text = tweet.createdAtString;
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];

    self.profPicImageView.image = nil;
    [self.profPicImageView setImageWithURL:tweet.user.profPicUrl];
    
    self.favoriteButton.highlighted = self.tweet.favorited;
    self.retweetButton.highlighted = self.tweet.retweeted;
}
- (IBAction)didFavorite:(id)sender {
    if(!self.tweet.favorited) {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", self.tweet.text);
                self.tweet.favorited = YES;
                self.favoriteButton.highlighted = YES;
                self.tweet.favoriteCount++;
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
            }
        }];
    }
    else {
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", self.tweet.text);
                self.tweet.favorited = NO;
                self.favoriteButton.highlighted = NO;
                self.tweet.favoriteCount--;
                self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
            }
        }];
    }
}
- (IBAction)didRetweet:(id)sender {
    if(!self.tweet.retweeted) {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error rting tweet: %@", error);
            }
            else{
                NSLog(@"Successfully rted the following Tweet: %@", tweet.text);
                self.tweet.retweeted = YES;
                self.retweetButton.highlighted = YES;
                self.tweet.retweetCount++;
                
                self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
            }
        }];
    }
    else {
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unrting tweet: %@", error);
            }
            else{
                NSLog(@"Successfully unrted the following Tweet: %@", tweet.text);
                self.tweet.retweeted = NO;
                self.retweetButton.highlighted = NO;
                self.tweet.retweetCount--;

                self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
            }
        }];
    }
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate tweetCell:self didTap:self.tweet.user];
}

@end
