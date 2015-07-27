//
//  Post.m
//  WirestormChallenge
//
//  Created by marcelo.perretta@gmail.com on 7/26/15.
//  Copyright (c) 2015 MAWAPE. All rights reserved.
//

#import "Post.h"

@implementation Post

+ (instancetype)itemWithDictionary:(NSDictionary*)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]) {
        
        [self setDataFromDictionary:dictionary];
    }
    
    return self;
}

-(void) setDataFromDictionary:(NSDictionary*)dictionary{
    

    
    if([self checkDiccionary:dictionary]){
        
        if([self checkKey:@"name" inDicctionary:dictionary])
            self.name = [self stringIsEmpty:dictionary[@"name"]] ? @"" : dictionary[@"name"];
        
        if([self checkKey:@"position" inDicctionary:dictionary])
            self.position = [self stringIsEmpty:dictionary[@"position"]] ? @"" : dictionary[@"position"];
        
        if([self checkKey:@"smallpic" inDicctionary:dictionary])
            self.smallpicurl = [self stringIsEmpty:dictionary[@"smallpic"]] ? @"" : dictionary[@"smallpic"];

        if([self checkKey:@"lrgpic" inDicctionary:dictionary])
        self.bigpicurl = [self stringIsEmpty:dictionary[@"lrgpic"]] ? @"" : dictionary[@"lrgpic"];
    }
    
}

-(BOOL) checkDiccionary:(id)data{
    return [data isKindOfClass:[NSDictionary class]];
}

-(BOOL) checkKey:(NSString *) key
   inDicctionary:(NSDictionary *) dictionary{
    
    
    if([self checkDiccionary:dictionary]){
        return [[dictionary allKeys] containsObject:key];
    } else {
        return NO;
    }
    
}


- (BOOL ) stringIsEmpty:(NSString *) aString {
    
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



@end
