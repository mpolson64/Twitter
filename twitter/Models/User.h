//
//  User.h
//  twitter
//
//  Created by Miles Olson on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSURL *profPicUrl;
@property (strong, nonatomic) NSURL *bannerUrl;
@property (strong, nonatomic) NSString *followingCount;
@property (strong, nonatomic) NSString *followersCount;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
