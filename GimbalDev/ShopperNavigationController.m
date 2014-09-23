//
//  ShopperNavigationController.m
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-22.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import "ShopperNavigationController.h"
#import "SettingsViewController.h"

#import "SightingManager.h"
#import "VisistManager.h"

@interface ShopperNavigationController ()
{
    SightingManager *_sightingManager;
    VisistManager *_visitManager;
}

@end

@implementation ShopperNavigationController

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

    
    //listen for sighting
//    _sightingManager = [[SightingManager alloc] init];
    
    //track visits
    _visitManager = [[VisistManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(openSettingsPageAction:)];
    
    
    [viewController.navigationItem setRightBarButtonItem:settingsButton];
    
    [super pushViewController:viewController animated:animated];
}


-(void)openSettingsPageAction:(id)sender
{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    [self pushViewController:settingsViewController animated:YES];
}

@end
