//
//  ViewController.m
//  Cats
//
//  Created by Yongwoo Huh on 2018-02-01.
//  Copyright © 2018 YongwooHuh. All rights reserved.
//

#import "CatPhoto.h"

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<CatPhoto *> *catPhotos;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.catPhotos = [@[] mutableCopy];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=f71ef240962b89ee62eb2a63d8524fe9&tags=cat"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.waitsForConnectivity = YES;
    configuration.allowsCellularAccess = NO;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        NSError *jsonError = nil;
        
        NSArray *catImages = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError][@"photos"][@"photo"];
        
        if (jsonError) {
            // Handle JSON error
            NSLog(@"JSON error %@", jsonError.localizedDescription);
            return;
        }
        
        for (NSDictionary *catImage in catImages) {
            CatPhoto *catPhoto = [[CatPhoto alloc] init];
            [catPhoto setupData:catImage];
            [self.catPhotos addObject:catPhoto];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            [self.collectionView reloadData];
            
        }];
    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.catPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    
    CatPhoto *catPhoto = self.catPhotos[indexPath.item];
    cell.photoLabel.text = catPhoto.title;
    if (catPhoto.image) {
        cell.catImageView.image = catPhoto.image;
    } else {
         [self getPhotoDataFromNetwork:indexPath];
    }
    return cell;
}

- (void)getPhotoDataFromNetwork:(NSIndexPath *)indexPath
{
    CatPhoto *catPhoto = self.catPhotos[indexPath.item];
    NSURL *url = [NSURL URLWithString:catPhoto.imageURL];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.waitsForConnectivity = YES;
    configuration.allowsCellularAccess = NO;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error) {
                                              // Handle the error
                                              NSLog(@"error: %@", error.localizedDescription);
                                              return;
                                          }
                                          
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              // This will run on the main queue
                                              catPhoto.image = [UIImage imageWithData:data];
                                              [self.collectionView reloadData];
                                          }];
                                      }];
    [dataTask resume];
}
@end
