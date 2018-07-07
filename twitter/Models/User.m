//
//  User.m
//  twitter
//
//  Created by Miles Olson on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.bio = dictionary[@"description"];
        self.profPicUrl = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
        self.bannerUrl = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        self.followingCount = dictionary[@"friends_count"];;
        self.followersCount = dictionary[@"followers_count"];
    }
    return self;
}

@end
