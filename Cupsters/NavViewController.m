//
//  NavViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 27/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "NavViewController.h"
#import "SWRevealViewController.h"
#import "ShowAnimator.h"

@interface NavViewController () <UIGestureRecognizerDelegate, SWRevealViewControllerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation NavViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.revealViewController.delegate = self;
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.revealViewController action:@selector(rightRevealToggle:)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer.enabled = NO;
    
    SWRevealViewController *revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
}

#pragma mark - SWRevealViewController Delegate Methods

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeftSide) {               // Menu will get revealed
        self.tapGestureRecognizer.enabled = YES;                 // Enable the tap gesture Recognizer
        self.interactivePopGestureRecognizer.enabled = NO;        // Prevents the iOS7's pan gesture
        self.topViewController.view.userInteractionEnabled = NO;       // Disable the topViewController's interaction
    }
    else if (position == FrontViewPositionLeft){      // Menu will close
        self.tapGestureRecognizer.enabled = NO;
        self.interactivePopGestureRecognizer.enabled = YES;
        self.topViewController.view.userInteractionEnabled = YES;
    }
}

#pragma mark - Animator delegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [[ShowAnimator alloc] init];
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
