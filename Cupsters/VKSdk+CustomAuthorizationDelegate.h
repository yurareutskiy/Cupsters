//
//  VKSdk+CustomAuthorizationDelegate.h
//  Cupsters
//
//  Created by Anton Scherbakov on 16/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import <VKSdk.h>

@interface VKSdk (CustomAuthorizationDelegate)

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult*)result;
- (void)vkSdkUserAuthorizationFailed;

@end
