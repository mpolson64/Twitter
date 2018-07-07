//
//  ProfileViewController.m
//  twitter
//
//  Created by Miles Olson on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"

#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "APIManager.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profPicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *tweets;

@end

@implementation ProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.handleLabel.text = self.user.name;
    self.bioLabel.text = self.user.bio;
    self.followingLabel.text = [NSString stringWithFormat:@"%@ Following", self.user.followingCount];
    self.followersLabel.text = [NSString stringWithFormat:@"%@ Followers", self.user.followersCount];
    
    self.profPicImageView.image = nil;
    [self.profPicImageView setImageWithURL:self.user.profPicUrl];
    self.profPicImageView.layer.cornerRadius = self.profPicImageView.frame.size.width / 2;
    [self.profPicImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.profPicImageView.layer setBorderWidth:2.0];

    self.bannerImageView.image = nil;
    [self.bannerImageView setImageWithURL:self.user.bannerUrl];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchTweets {
    [[APIManager shared] getUserTimelineWithCompletion:self.user.screenName completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded user timeline");
            self.tweets = tweets;
        } else {
            NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
        }
        
        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    cell.tweet = self.tweets[indexPath.row];
//    cell.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
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
