//
//  PostTableViewCell.h
//  WirestormChallenge
//
//  Created by marcelo.perretta@gmail.com on 7/26/15.
//  Copyright (c) 2015 MAWAPE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
