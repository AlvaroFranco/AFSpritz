AFSpritz
=======================

[![Build Status](https://travis-ci.org/AlvaroFranco/AFSpritz.svg?branch=master)](https://travis-ci.org/AlvaroFranco/AFSpritz)
[![alt text](https://cocoapod-badges.herokuapp.com/v/AFSpritz/badge.png)]()
[![alt text](https://cocoapod-badges.herokuapp.com/p/AFSpritz/badge.png)]()
[![alt text](https://camo.githubusercontent.com/f513623dcee61532125032bbf1ddffda06ba17c7/68747470733a2f2f676f2d736869656c64732e6865726f6b756170702e636f6d2f6c6963656e73652d4d49542d626c75652e706e67)]()

A complete, lightweight Spritz SDK for iOS

![alt text](https://raw.github.com/AlvaroFranco/AFSpritz/master/example.gif "Example")

##CocoaPods

AFSpritz is on [CocoaPods](http://cocoapods.org), so you can get the pod by adding this line to your Podfile

    pod 'AFSpritz', '~> 1.3.1'

If not, just import these files to your project:

    AFSpritzManager.h
    AFSpritzManager.m
    AFSpritzWords.h
    AFSpritzWords.m
    AFSpritzLabel.h
    AFSpritzLabel.m
    NSTimer+Control.h
    NSTimer+Control.m

##Usage

First of all, import AFSpritzManager.h to your class

```objc
#import "AFSpritzManager.h"
```

Initialise ```AFSpritzManager``` assigning a text and a number of words per minute, that will determine the speed of the reading. Theorically, there's no limit, but the more confortable speed is 200-250 words per minute. However, Spritz is made for let you read more than 500 words per minute.

```objc
AFSpritzManager *manager = [[AFSpritzManager alloc] initWithText:@"Welcome to AFSpritz! Spritz is a brand new revolutionary reading method that will help you to improve your number of words per minute. Take a look at AFSpritz!" andWordsPerMinute:250];
```

Then, call the block that will update the Spritz label

```objc
[manager updateLabelWithNewWordAndCompletion:^(AFSpritzWords *word, BOOL finished) {

    if (!finished) {

		//Update the AFSpritzLabel
    } else {
        NSLog(@"Finished!");
    }
}];
```

###Checking the status

```objc
typedef NS_ENUM(int, AFSpritzStatus) {

	AFSpritzStatusStopped,
	AFSpritzStatusReading,
	AFSpritzStatusNotStarted,
	AFSpritzStatusFinished
};
```

AFSpritz has the feature of checking in each moment the status of the reading using ```-status:```.

Example:

```objc
	if ([manager status:AFSpritzStatusReading]) {

		// The current status is reading
	} else if ([manager status:AFSpritzStatusNotStarted]) {

		// The current status is not started yet
	}  else if ([manager status:AFSpritzStatusStopped]) {

		// The current status is stopped, so it can be resumed
	} else if ([manager status:AFSpritzStatusFinished]) {

		// The current status is finished
	}
```

###Pausing, resuming and restarting

Now you can pause, resume and restart your reading just calling these three methods:

```objc
	[manager pauseReading];

	[manager resumeReading];
    
    [manager restartReading];
```

##AFSpritzLabel API

AFSpritzLabel is an incredible, well crafted and 100% AFSpritzWords-compatible UIView subclass that will let you show your Spritz reading.

You can customize many properties from AFSpritzLabel, such as:

| Property | Class | Required | Default | Description |
|----------|-------|----------|---------|-------------|
| word | AFSpritzWords | Yes | nil | Determines the AFSpritzWords-subclassed word to show. |
| markerColor | UIColor | No | Red | Determines the color of the letter you're supposed to be focused on. |
| markeringLinesColor | UIColor | No | Black | Determines the color of the lines around the word. |
| textColor | UIColor | No | Black | Determines the color of the text. |
| textFont | UIFont | No | System font with size 20 | Determines the font of the text. |
| backgroundColor | UIColor | No | White | Determines the color of the background. |

##Wishlist

- [x] Customize speed throught the number of words per minute.

- [x] Stop and resume the reading.

- [x] Add a little stop when there's a stop on the text (. … : , ! ?).

- [x] Restart the reading. (Thanks [Ayberk](https://github.com/ayberkt)!)

- [ ] Different speed based on the word length.

##Author

Made by Alvaro Franco. If you have any question, feel free to drop me a line at [alvarofrancoayala@gmail.com](mailto:alvarofrancoayala@gmail.com)