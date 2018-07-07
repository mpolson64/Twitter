//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by Miles Olson on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.profPicImageView.image = nil;
    [self.profPicImageView setImageWithURL:self.tweet.user.profPicUrl];
    self.profPicImageView.layer.cornerRadius = self.profPicImageView.frame.size.width / 2;
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.tweetLabel.text = self.tweet.text;
    self.retweetsLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoritesLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.dateLabel.text = self.tweet.createdAtString;
    
    self.favoriteButton.highlighted = self.tweet.favorited;
    self.retweetButton.highlighted = self.tweet.retweeted;
    
    if(self.tweet.mediaUrl) [self.mediaImageView setImageWithURL:self.tweet.mediaUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                
                self.retweetsLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
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
                
                self.retweetsLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
            }
        }];
    }
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
                self.favoritesLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
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
                self.favoritesLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
