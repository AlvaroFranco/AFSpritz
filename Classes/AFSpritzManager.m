//
//  AFSpritzManager.m
//  AFSpritz-Demo
//
//  Created by Alvaro Franco on 3/1/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "AFSpritzManager.h"

@interface AFSpritzManager ()

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSArray *words;
@property (nonatomic) NSUInteger current;
@property (nonatomic) float speed;
@property (nonatomic) NSTimer *timer;

@property (nonatomic) int status;

-(NSMutableArray *)packageOfWords;
-(BOOL)containsFullStop:(NSString *)wordToAnalyze;

@end

@implementation AFSpritzManager

-(id)initWithText:(NSString *)text andWordsPerMinute:(int)wpm {
    
    self = [super init];
    
    if (self) {
        
        if (!wpm) {
            
            wpm = 250;
            NSLog(@"AFSpritz message: You need to provide a valid number of words per minute. If not, 250 words per minute will be used by default");
        }
        
        _status = AFSpritzStatusNotStarted;
        
        _text = text;
        _speed = (wpm / 60);
        _speed = (1/_speed);
        
        NSArray *wordsSeparated = [self.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSMutableArray *fixedArray = [NSMutableArray array];
        
        for (NSString *singleWord in wordsSeparated) {
            
            [fixedArray addObject:[singleWord stringByAppendingString:@" "]];
        }
        
        if (fixedArray.count) {
            
            _current = 0;
            _words = fixedArray;
        }
    }
    
    return self;
}

-(void)updateLabelWithNewWordAndCompletion:(statusBlock)completion {
    
    NSMutableArray *wordsArray = [self packageOfWords];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_speed block:^{
        
        if (_current != wordsArray.count) {
            
            if (_current > 0) {
                
                if ([self containsFullStop:[(AFSpritzWords *)wordsArray[_current - 1]word]]) {
                    
                    clock_t end = clock() + (_speed * CLOCKS_PER_SEC);
                    while (clock() < end);
                }
            }
                        
            _status = AFSpritzStatusReading;

            if (completion) {
                
                completion([wordsArray objectAtIndex:_current], NO);
            }
            
            _current++;
        } else if (_current == wordsArray.count) {
            
            if (completion) {
                
                completion(nil, YES);
            }
            
            [_timer invalidate];
            _status = AFSpritzStatusFinished;
        }
        
    } repeats:YES];
}

-(BOOL)containsFullStop:(NSString *)wordToAnalyze {
    
    if ([wordToAnalyze rangeOfString:@". "].location != NSNotFound) {
        return YES;
    } else if ([wordToAnalyze rangeOfString:@"! "].location != NSNotFound) {
        return YES;
    } else if ([wordToAnalyze rangeOfString:@", "].location != NSNotFound) {
        return YES;
    } else if ([wordToAnalyze rangeOfString:@"... "].location != NSNotFound) {
        return YES;
    } else if ([wordToAnalyze rangeOfString:@"… "].location != NSNotFound) {
        return YES;
    } else if ([wordToAnalyze rangeOfString:@"? "].location != NSNotFound) {
        return YES;
    } else if ([wordToAnalyze rangeOfString:@": "].location != NSNotFound) {
        return YES;
    } else if ([wordToAnalyze rangeOfString:@"; "].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

-(NSMutableArray *)packageOfWords {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSString *word in _words) {
        
        [tempArray addObject:[[AFSpritzWords alloc] initWithNextWord:word]];
    }
        
    return tempArray;
}

-(void)resumeReading {
    
    if ([self status:AFSpritzStatusStopped]) {
        
        _status = AFSpritzStatusReading;
        [_timer resumeTimer];
    } else {
        
        NSLog(@"AFSpritz message: Reading can only be resumed when is stopped");
    }
}

-(void)pauseReading {
    
    if ([self status:AFSpritzStatusReading]) {
        
        _status = AFSpritzStatusStopped;
        [_timer pauseTimer];
    } else {
        
        NSLog(@"AFSpritz message: Reading can only be paused when the reading is active");
    }
}

-(void)restartReading {
    
    if ([self status:AFSpritzStatusReading]) {
        
        _current = 0;
    } else {
        
        NSLog(@"AFSpritz message: Reading can only be restarted when the reading is active");
    }
}

-(BOOL)status:(AFSpritzStatus)spritzStatus {

    if (spritzStatus == _status) {
        
        return YES;
    } else {
        
        return NO;
    }
}

@end
