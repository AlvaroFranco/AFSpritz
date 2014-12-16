//
//  ViewController.m
//  AFSpritz-Demo
//
//  Created by Alvaro Franco on 3/1/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "ViewController.h"
#import "SpritzViewController.h"
#import "AFPopupView.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *showSpritzButton;
@property (nonatomic, strong) IBOutlet UISwitch *customSpeed;
@property (nonatomic, strong) IBOutlet UISlider *wpmSlider;
@property (nonatomic, strong) IBOutlet UILabel *wpmLabel;

@property (nonatomic, strong) AFPopupView *popup;
@property (nonatomic, strong) SpritzViewController *spritzVC;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:Nil];
    _spritzVC = [storyboard instantiateViewControllerWithIdentifier:@"SpritzVC"];
    
    _wpmSlider.value = 0.25;
    [_wpmSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    _wpmLabel.text = [NSString stringWithFormat:@"%0.f words per minute", (_wpmSlider.value * 600) + 100];

    [_customSpeed addTarget:self action:@selector(switcherChanged) forControlEvents:UIControlEventValueChanged];
    
    [_showSpritzButton addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hide) name:@"HideSpritzPopup" object:nil];
}

-(void)show {
    
    if ([_customSpeed isOn]) {
        _spritzVC.wpm = ceilf((_wpmSlider.value * 600) + 100);
    }
    _spritzVC.text = _textView.text;
    _popup = [AFPopupView popupWithView:_spritzVC.view];
    [_popup show];
}

-(void)hide {
    
    [_popup hide];
}

-(void)switcherChanged {
    
    if ([_customSpeed isOn]) {
        _wpmSlider.enabled = YES;
    } else {
        _wpmSlider.enabled = NO;
    }
}

-(void)sliderChanged:(UISlider *)sender {
    
    _wpmLabel.text = [NSString stringWithFormat:@"%0.f words per minute", (sender.value * 600) + 100];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_textView resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
