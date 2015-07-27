//
//  ViewController.m
//  WirestormChallenge
//
//  Created by marcelo.perretta@gmail.com on 7/26/15.
//  Copyright (c) 2015 MAWAPE. All rights reserved.
//

#import "ViewController.h"
#import "ServerCalls.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *imageURLLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"IMAGE: %@", self.imageURL);

    if(![ServerCalls stringIsEmpty:self.imageURL]){
        self.imageURLLabel.text = self.imageURL;
        [ServerCalls downloadDataFromURL:self.imageURL ifImage:YES success:^(NSArray *data) {
            // Check if any data returned.
            if (data != nil) {
                self.postImage.image = [UIImage imageWithData:data.firstObject];
                
            }
        } failure:^(NSString *errorDescription) {
            self.activityIndicator.alpha = 0.0;
            [ServerCalls showAlertWithMessage:errorDescription withErrorTitle:@"ERROR"];
        }];

    } else {
        self.activityIndicator.alpha = 0.0;
        [ServerCalls showAlertWithMessage:@"No Image Data" withErrorTitle:@"ERROR"];
    }
    
}


@end
