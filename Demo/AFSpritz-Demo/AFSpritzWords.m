//
//  AFSpritzWords.m
//  AFSpritz-Demo
//
//  Created by Alvaro Franco on 3/1/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "AFSpritzWords.h"

@implementation AFSpritzWords

-(instancetype)initWithNextWord:(NSString *)word {
    
    if (self = [super init]) {
        
        _word = word;
        _delay = [self calculateDelay];
        _markerPosition = [self getReaderMarkerPosition];
    }
    
    return self;
}

-(NSTimeInterval)calculateDelay {
    
    NSUInteger length = self.word.length;
    static NSTimeInterval minimum = 0.18;
    static NSTimeInterval maximum = 0.3;
    static NSUInteger minTreshold = 4;
    static NSUInteger maxTreshold = 10;
    
    if (length < minTreshold) {
        
        return minimum;
    }

    if (length > maxTreshold) {
        
        return maximum;
    }
    
    return minimum + ((maximum - minimum) / (maxTreshold - minTreshold));
}

-(NSUInteger)getReaderMarkerPosition {
    
    NSUInteger length = self.word.length;
    NSUInteger letter = 0;
    
    switch (length) {
            
        case 1:
        case 2:
            letter = 0;
            break;
            
        case 3:
        case 4:
        case 5:
            letter = 1;
            break;
            
        case 6:
        case 7:
        case 8:
        case 9:
            letter = 2;
            break;
            
        case 10:
        case 11:
        case 12:
        case 13:
            letter = 3;
            break;
            
        default:
            letter = 4;
    }
    
    return letter;
}

@end

