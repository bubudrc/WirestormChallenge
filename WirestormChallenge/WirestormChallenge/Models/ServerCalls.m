//
//  ServerCalls.m
//  WirestormChallenge
//
//  Created by marcelo.perretta@gmail.com on 7/26/15.
//  Copyright (c) 2015 MAWAPE. All rights reserved.
//

#import "ServerCalls.h"


static NSString *const kBaseURL = @"https://s3-us-west-2.amazonaws.com/wirestorm/assets/response.json";

@implementation ServerCalls

+(void)downloadDataFromURL:(NSString *) URL
                   ifImage:(BOOL) isImage
                   success:(void (^)(NSArray *data))sucess
                   failure:(void (^)(NSString *errorDescription))failure{
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Prepare the URL that we'll get info data from.
    NSString *URLString = kBaseURL;
    
    if(![self stringIsEmpty:URL]){
        URLString = URL;
    }
    
    NSURL *urlToCall = [NSURL URLWithString:URLString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlToCall];
    
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            [self showAlertWithMessage:[error localizedDescription] withErrorTitle:YES];
            
            // If any error occurs then just display its description on the console.
            failure([error localizedDescription]);
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                [self showAlertWithMessage:@"HTTP status code different to 200" withErrorTitle:YES];
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
                failure(@"HTTP status code different to 200");
            }
            
            NSData *jsonData = [[NSData alloc] initWithContentsOfURL:location];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if(isImage){
                    sucess(@[jsonData]);
                } else {
                    sucess([self validateDataFromServer:jsonData]);
                }
            }];
            
        }
        
    }];
    
    [task resume];
    
}


+ (BOOL ) stringIsEmpty:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    } else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

+(NSArray *) validateDataFromServer:(NSData *) serverData{
    
    NSArray *postsData = nil;
    // Check if any data returned.
    if (serverData != nil) {
        // Convert the returned data into a dictionary.
        NSError *error;
        //NSMutableDictionary *temporaryData = [NSJSONSerialization JSONObjectWithData:serverData options:kNilOptions error:&error];
        
        NSArray *temporaryData = [NSJSONSerialization JSONObjectWithData:serverData options:NSJSONReadingAllowFragments error:&error];
        
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        } else{
            if(temporaryData)
                postsData = temporaryData;
        }
    }
    
    return postsData;
}

#pragma mark - Alert
+(void) showAlertWithMessage:(NSString *) message
              withErrorTitle:(BOOL) error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: error ? @"ERROR" : @"ATTENTION"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
        
    });
}


@end

