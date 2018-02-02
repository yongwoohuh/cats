//
//  PhotoCollectionViewCell.h
//  Cats
//
//  Created by Yongwoo Huh on 2018-02-02.
//  Copyright © 2018 YongwooHuh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatPhoto.h"

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *catImageView;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (strong, nonatomic) CatPhoto *catPhoto;

@end
