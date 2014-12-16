//
//  AFSpritzManager.h
//  AFSpritz-Demo
//
//  Created by Alvaro Franco on 3/1/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFSpritzWords.h"
#import "AFSpritzLabel.h"
#import "NSTimer+Control.h"

typedef NS_ENUM(int, AFSpritzStatus) {
    
    AFSpritzStatusStopped,
    AFSpritzStatusReading,
    AFSpritzStatusNotStarted,
    AFSpritzStatusFinished
};

@interface AFSpritzManager : NSObject

// statusBlock declaration that returns the current word and the status with the bool finished.
// The update speed depends on the words per minute provided.
typedef void (^statusBlock)(AFSpritzWords *word, BOOL finished);

// Initialization method
// You need to provide a valid text that will be analized and a number of words per minute, that will regulate the reading speed
-(id)initWithText:(NSString *)text andWordsPerMinute:(int)wpm;

// Main function
// Is block-driven and the block is called every single time a word changes
// Due is using the statusBlock, returns a AFSpritzWords word and a status bool every time is fired
-(void)updateLabelWithNewWordAndCompletion:(statusBlock)completion;

// Checks for the Spritz status
-(BOOL)status:(AFSpritzStatus)spritzStatus;

// Pauses the reading
// It will save the state if the class doesn't get deallocated
-(void)pauseReading;

// Resumes the reading if it has been previously paused
-(void)resumeReading;

// Restarts the reading if it has been started
-(void)restartReading;

@end
