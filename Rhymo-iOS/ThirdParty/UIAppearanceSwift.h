//
//  UIAppearance+Swift.h
//  Rhymo
//
//  Created by Oguz Bilgener on 28/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//  From: http://stackoverflow.com/a/27807417/1552938

#import <Foundation/Foundation.h>

@interface UIView (UIViewAppearance_Swift)
// appearanceWhenContainedIn: is not available in Swift. This fixes that.
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end