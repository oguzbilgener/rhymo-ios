//
//  UnderlinedTextField.m
//  Rhymo
//
//  Created by Oguz Bilgener on 27/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

#import "UnderlinedTextField.h"

@implementation UnderlinedTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
  return CGRectInset( bounds , 5 , 5 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
  return CGRectInset( bounds , 5 , 5 );
}

- (void) drawRect:(CGRect)rect {
  [super drawRect: rect];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGRect lineRect = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - self.lineThickness, rect.size.width, self.lineThickness);
  
  if(self.lineColor != nil) {
    [self.lineColor setFill];
  }
  else {
    [self.textColor setFill];
  }
  
  CGContextFillRect(context, lineRect);
  
}

@end
