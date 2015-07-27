//
//  Post.h
//  WirestormChallenge
//
//  Created by marcelo.perretta@gmail.com on 7/26/15.
//  Copyright (c) 2015 MAWAPE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *smallpicurl;
@property (nonatomic, strong) NSString *bigpicurl;

+ (instancetype)itemWithDictionary:(NSDictionary*)dictionary;

- (id)initWithDictionary:(NSDictionary*)dictionary;

-(void) setDataFromDictionary:(NSDictionary*)dictionary;


@end
