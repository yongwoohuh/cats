//
//  CatPhoto.h
//  Cats
//
//  Created by Yongwoo Huh on 2018-02-01.
//  Copyright © 2018 YongwooHuh. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface CatPhoto : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageURL;

- (void)setupData:(NSDictionary *)data;
@end
