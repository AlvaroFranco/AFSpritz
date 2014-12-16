//
//  AFSpritzLabel.h
//  AFSpritz-Demo
//
//  Created by Alvaro Franco on 3/1/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFSpritzWords.h"

@interface AFSpritzLabel : UIView

@property (nonatomic, retain) AFSpritzWords *word;
@property (nonatomic, retain) UIColor *markerColor;
@property (nonatomic, retain) UIColor *markingLinesColor;
@property (nonatomic, retain) UIColor *background;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIFont *textFont;

@end
