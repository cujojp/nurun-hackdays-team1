//
//  SettingsViewController.m
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-22.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import "SettingsViewController.h"
#import "ProximityServiceManager.h"
#import "LocalNotificationHelper.h"
#import <FYX/FYX.h>

@interface SettingsViewController () <FYXSessionDelegate, ProximityServiceManagerLogDelegate>
{
    UITextView *_logTextView;
    UISlider *_sensitivitySlider;
    UIButton *_resetExperienceButton;
    UIButton *_oauthGimbalButton;
    UIButton *_notificationTestButton;

    UILabel *_sliderLabel;
    
    
}

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _resetExperienceButton = [[UIButton alloc] init];
    [_resetExperienceButton addTarget:self action:@selector(resetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_resetExperienceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_resetExperienceButton setTitle:@"Reset Experience" forState:UIControlStateNormal];
    [_resetExperienceButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_resetExperienceButton];
    
    _oauthGimbalButton = [[UIButton alloc] init];
    [_oauthGimbalButton addTarget:self action:@selector(oauthGimbalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_oauthGimbalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_oauthGimbalButton setTitle:@"Gimbal Oauth (Admin portal)" forState:UIControlStateNormal];
    [_oauthGimbalButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_oauthGimbalButton];
    
    _notificationTestButton = [[UIButton alloc] init];
    [_notificationTestButton addTarget:self action:@selector(testNotificationAction) forControlEvents:UIControlEventTouchUpInside];
    [_notificationTestButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_notificationTestButton setTitle:@"Test Notification" forState:UIControlStateNormal];
    [_notificationTestButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_notificationTestButton];
    
    _logTextView = [[UITextView alloc] init];
    [_logTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_logTextView];
    
    _sensitivitySlider = [[UISlider alloc] init];
    [_sensitivitySlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_sensitivitySlider];
    
    _sliderLabel = [[UILabel alloc] init];
    [_sliderLabel setText:@"Sensitivity"];
    [_sliderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_sliderLabel];
    
    [[ProximityServiceManager sharedManager] setLogDelegate:self];
    
    [self setupAppearance];
    
    
}

- (void)setupAppearance
{
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_oauthGimbalButton,_resetExperienceButton, _logTextView, _sensitivitySlider, _sliderLabel, _notificationTestButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_oauthGimbalButton(44)]-[_resetExperienceButton(44)][_notificationTestButton(44)][_sensitivitySlider(44)][_logTextView]-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_sliderLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_sensitivitySlider attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_resetExperienceButton]-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_oauthGimbalButton]-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_notificationTestButton]-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_logTextView]-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_sliderLabel]-[_sensitivitySlider]-|" options:0 metrics:nil views:viewsDictionary]];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetButtonAction:(id)sender
{
    [_logTextView setText:@""];
    [[ProximityServiceManager sharedManager] restartManager];
}

-(void)oauthGimbalButtonAction:(id)sender
{
    UIViewController *viewController = self;
    [FYX startServiceAndAuthorizeWithViewController:viewController delegate:[ProximityServiceManager sharedManager]];
}

-(void)testNotificationAction
{
    [LocalNotificationHelper displayNotificationWithString:@"Test Messages"];
}


-(void)proximityServiceManagerDidLog:(NSString *)logMessage
{
    [_logTextView setText:[_logTextView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@", logMessage]]];
}

@end
