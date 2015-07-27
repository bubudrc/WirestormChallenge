//
//  ServerCalls.h
//  WirestormChallenge
//
//  Created by marcelo.perretta@gmail.com on 7/26/15.
//  Copyright (c) 2015 MAWAPE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ServerCalls : NSObject

+(void)downloadDataFromURL:(NSString *) URL
                   ifImage:(BOOL) isImage
                   success:(void (^)(NSArray *data))sucess
                   failure:(void (^)(NSString *errorDescription))failure;

+(void) showAlertWithMessage:(NSString *) message
              withErrorTitle:(BOOL) error;

@end
