//
//  UIAppearance+Swift.m
//  Rhymo
//
//  Created by Oguz Bilgener on 28/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

#import <UIKit/UIKit.h>

@implementation UIView (UIViewAppearance_Swift)
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass {
  return [self appearanceWhenContainedIn:containerClass, nil];
}
@end