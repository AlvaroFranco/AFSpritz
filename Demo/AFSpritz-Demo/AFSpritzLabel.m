//
//  AFSpritzLabel.m
//  AFSpritz-Demo
//
//  Created by Alvaro Franco on 3/1/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "AFSpritzLabel.h"
#import "AFSpritzWords.h"
#import <CoreText/CoreText.h>

typedef enum {
    
    AFSpritzLabelTextPartHeader,
    AFSpritzLabelTextPartMarker,
    AFSpritzLabelTextPartTail
} AFSpritzLabelTextPart;

@implementation AFSpritzLabel {
    
    CGFloat markerOffset;
    CGFloat markerLength;
    
    CGFloat headerWidth;
    CGFloat tailWidth;
    CGFloat markerWidth;
    
    CGFloat textVerticalPosition;
    CGFloat textHorizontalPosition;
}

-(id)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        [self defaultParameters];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self == [super initWithCoder:aDecoder]) {
        
        [self defaultParameters];
    }
    
    return self;
}

-(void)defaultParameters {
    
    markerOffset = self.frame.size.width / 3;
    markerLength = 5;
    textVerticalPosition = 15;
    _markerColor = [UIColor redColor];
    _markingLinesColor = [UIColor blackColor];
    _background = [UIColor whiteColor];
    _textColor = [UIColor blackColor];
    _textFont = [UIFont systemFontOfSize:20];
    _word = [[AFSpritzWords alloc] initWithNextWord:@" "];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.backgroundColor = _background;
}

-(void)setWord:(AFSpritzWords *)word {
    
    if (_word != word) {

        _word = word;
        
        [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawMarkingLinesWithOffset:markerOffset andLength:markerLength];
    
    [self flipCoordinateSystemForCoreText];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds );
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.word.word];
    
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(self.word.markerPosition, 1)];
    [attString addAttribute:NSFontAttributeName value:self.textFont range:NSMakeRange(0, self.word.word.length)];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, [attString length]), path, NULL);
    
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    
    for (id lineObj in lines) {
        
        CTLineRef line = (__bridge CTLineRef)lineObj;
        NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
        
        for (CFIndex runIndex = 0; runIndex < runs.count; ++runIndex) {
            
            CTRunRef run = (__bridge CTRunRef)[runs objectAtIndex:runIndex];
            CGFloat width = 0;
            width = (CGFloat)CTRunGetTypographicBounds(run, CFRangeMake(0, 0), NULL, NULL, NULL);
            
            switch (runIndex) {
                    
                case AFSpritzLabelTextPartHeader:
                    headerWidth = width;
                    
                    if (runs.count == 1) {
                        
                        headerWidth = 0;
                        markerWidth = width;
                        [self recomputeTextHorizontalPosition];
                    }
                    
                    break;
                    
                case AFSpritzLabelTextPartMarker:
                    markerWidth = width;
                    
                    if (runs.count == 2) {
                        
                        if (self.word.markerPosition) {
                            
                        } else {
                            
                            markerWidth = headerWidth;
                            headerWidth = 0;
                            markerWidth = width;
                        }
                        
                        [self recomputeTextHorizontalPosition];
                    }
                    
                    break;
                    
                case AFSpritzLabelTextPartTail:
                    tailWidth = width;
                    [self recomputeTextHorizontalPosition];
                    break;
                    
                default:
                    break;
            }
        }
        
        for (CFIndex runIndex = 0; runIndex < runs.count; ++runIndex) {
            
            CTRunRef run = (__bridge CTRunRef)[runs objectAtIndex:runIndex];
            CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
            
            for (CFIndex runGlyphIndex = 0 ; runGlyphIndex < CTRunGetGlyphCount(run) ; runGlyphIndex++) {
                
                CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
                CGGlyph glyph;
                CGPoint position;
                CTRunGetGlyphs(run, thisGlyphRange, &glyph);
                CTRunGetPositions(run, thisGlyphRange, &position);
                
                if ((runs.count >= 3 && runIndex == AFSpritzLabelTextPartMarker) ||
                    (runs.count == 1 && !self.word.markerPosition) ||
                    (runs.count == 2 && self.word.markerPosition && runIndex) ||
                    (runs.count == 2 && !self.word.markerPosition && !runIndex)) {
                    
                    CGContextSetFillColorWithColor(context, self.markerColor.CGColor);
                } else {
                    
                    CGContextSetFillColorWithColor(context, self.textColor.CGColor);
                }
                
                position = CGPointMake(position.x + textHorizontalPosition, position.y + textVerticalPosition);

                {
                    CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
                    
                    CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
                    CGContextSetTextMatrix(context, textMatrix);
                    CGContextSetFont(context, cgFont);
                    CGContextSetFontSize(context, CTFontGetSize(runFont));
                    
                    CGContextShowGlyphsAtPositions(context, &glyph, &position, 1);
                    
                    CFRelease(cgFont);
                }
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

-(void)recomputeTextHorizontalPosition {
    
    textHorizontalPosition = markerOffset - (headerWidth + markerWidth/2.0f);
}

-(void)drawLineInContextWithWidth:(CGFloat)width fromPointX:(CGFloat)fx fromY:(CGFloat)fy toX:(CGFloat)tx toY:(CGFloat)ty {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, width);
    
    CGContextMoveToPoint(context, fx, fy);
    CGContextAddLineToPoint(context, tx, ty);
    
    CGContextStrokePath(context);
}

-(void)drawMarkingLinesWithOffset:(CGFloat)offset andLength:(CGFloat)length {
    
    CGFloat verticalOffset = 4.0f;
    CGFloat horizontalOffset = 10.0f;
    
    [self.markingLinesColor set];
    [self drawLineInContextWithWidth:1.0f fromPointX:offset fromY:self.frame.size.height-length - verticalOffset toX:offset toY:self.frame.size.height - verticalOffset];
    [self drawLineInContextWithWidth:1.0f fromPointX:offset fromY:verticalOffset toX:offset toY:length + verticalOffset];
    
    [self drawLineInContextWithWidth:2.0f fromPointX:horizontalOffset fromY:verticalOffset toX:self.frame.size.width - horizontalOffset toY:verticalOffset];
    [self drawLineInContextWithWidth:2.0f fromPointX:horizontalOffset fromY:self.frame.size.height-verticalOffset toX:self.frame.size.width - horizontalOffset toY:self.frame.size.height-verticalOffset];
}

-(void)flipCoordinateSystemForCoreText {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
}

@end