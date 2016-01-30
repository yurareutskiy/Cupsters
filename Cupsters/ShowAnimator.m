//
//  ShowAnimator.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/30/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "ShowAnimator.h"

@implementation ShowAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIViewController *firstVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *secondVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [containerView addSubview:secondVC.view];
    secondVC.view.alpha = 0;
    float duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        secondVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        BOOL cancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:cancelled];
    }];
}


@end



