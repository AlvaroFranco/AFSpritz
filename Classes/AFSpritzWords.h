//
//  AFSpritzWords.h
//  AFSpritz-Demo
//
//  Created by Alvaro Franco on 3/1/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFSpritzWords : NSObject

@property (nonatomic, retain, readonly) NSString *word;
@property (nonatomic, assign, readonly) NSUInteger markerPosition;
@property (nonatomic, assign, readonly) NSTimeInterval delay;

-(instancetype)initWithNextWord:(NSString *)word;

@end
