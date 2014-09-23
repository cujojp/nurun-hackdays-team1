//
//  ShopperInStoreViewController.m
//  GimbalDev
//
//  Created by Emmanuel Lalande on 2014-03-22.
//  Copyright (c) 2014 Nurun. All rights reserved.
//

#import "ShopperInStoreViewController.h"

@interface ShopperInStoreViewController ()
{
    UIImageView *_inStoreBackgroundImageView;
    UILabel *_titleLabel;
}

@end

@implementation ShopperInStoreViewController

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
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_titleLabel setText:@"Inside Store View"];
    [self.view addSubview:_titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
