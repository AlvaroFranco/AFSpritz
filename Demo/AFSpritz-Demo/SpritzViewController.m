//
//  SpritzViewController.m
//  AFSpritz-Demo
//
//  Created by Alvaro Franco on 3/18/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "SpritzViewController.h"
#import "AFSpritzManager.h"

@interface SpritzViewController ()

@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIButton *pauseButton;
@property (nonatomic, strong) IBOutlet UIButton *resumeButton;
@property (nonatomic, strong) IBOutlet UIButton *restartButton;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) AFSpritzManager *manager;

@end

@implementation SpritzViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AFSpritzLabel *spritzLabel = [[AFSpritzLabel alloc] initWithFrame:CGRectMake(20, 20, 200, 40)];
    spritzLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, 100);
    [self.view addSubview:spritzLabel];

    self.view.backgroundColor = [UIColor clearColor];
    UIToolbar *blurBar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    blurBar.barStyle = UIBarStyleDefault;
    [self.view addSubview:blurBar];
    [self.view sendSubviewToBack:blurBar];
    
    [_startButton addTarget:self action:@selector(toggleSpritz) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
}

-(void)closePopup {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideSpritzPopup" object:nil];
}

-(void)toggleSpritz {
    
    _manager = [[AFSpritzManager alloc]initWithText:_text andWordsPerMinute:_wpm ? _wpm : 250];
    
    [_manager updateLabelWithNewWordAndCompletion:^(AFSpritzWords *word, BOOL finished) {
        
        if (!finished) {
            
            AFSpritzLabel *spritzLabel = [[AFSpritzLabel alloc]initWithFrame:CGRectMake(20, 20, 200, 40)];
            spritzLabel.center = CGPointMake([[UIScreen mainScreen]bounds].size.width / 2, 100);
            spritzLabel.word = word;
            [self.view addSubview:spritzLabel];
        } else {
            NSLog(@"Finished!");
        }
    }];
    
    [_pauseButton addTarget:_manager action:@selector(pauseReading) forControlEvents:UIControlEventTouchUpInside];
    [_resumeButton addTarget:_manager action:@selector(resumeReading) forControlEvents:UIControlEventTouchUpInside];
    [_restartButton addTarget:_manager action:@selector(restartReading) forControlEvents:UIControlEventTouchUpInside];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
