//
//  StartViewController.m
//  Cupsters
//
//  Created by Reutskiy Jury on 2/2/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "StartViewController.h"
#import "Constants.h"

@interface StartViewController ()

@end

@implementation StartViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:cSBMenu];
        [self presentViewController:vc animated:NO completion:nil];
    } else {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:cSBLogin];
        [self presentViewController:vc animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
