//
//  CatPhoto.m
//  Cats
//
//  Created by Yongwoo Huh on 2018-02-01.
//  Copyright © 2018 YongwooHuh. All rights reserved.
//

#import "CatPhoto.h"

@implementation CatPhoto

- (NSString *)description
{
    return [NSString stringWithFormat:@"title : %@; url: %@", self.title, self.imageURL];
}

- (void)setupData:(NSDictionary *)data
{
    self.title = data[@"title"];
    // set image url
    self.imageURL = [self makeURLWithFarm:data[@"farm"] Server:data[@"server"] ID:data[@"id"] Secret:data[@"secret"]];

}

- (NSString *)makeURLWithFarm:(NSString *)farm Server:(NSString *)server ID:(NSString *)idNum Secret:(NSString *)secret
{
    return [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farm, server, idNum, secret];
}

@end
