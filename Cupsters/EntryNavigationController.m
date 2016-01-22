//
//  EntryNavigationController.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/22/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "EntryNavigationController.h"
#import "Constants.h"

@interface EntryNavigationController ()

@end

@implementation EntryNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"isLogin"]) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
        [self presentViewController:vc animated:true completion:nil];
    }
    
    NSLog(@"%@", [userDefaults objectForKey:@"isLogin"]);
    NSLog(@"%@", [userDefaults objectForKey:@"user"]);
    NSLog(@"%@", [userDefaults objectForKey:@"plan"]);
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
