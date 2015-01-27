//
//  InvertButton.m
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 23/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

#import "InvertButton.h"

#define kCornerRadius @"cornerRadius"
#define kPrimaryColor @"primaryColor"
#define kSecondaryColor @"secondaryColor"

#define ROUND_UP(N, S) ((((N) + (S) - 1) / (S)) * (S))


@implementation InvertButton

- (id) initWithFrame: (CGRect) rect {
  if ( self = [super init] ) {
    self.primaryColor = [self titleColorForState:UIControlStateNormal];
    self.secondaryColor = self.backgroundColor;
    [self commonInit];
    return self;
  }
  return nil;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
  if(self = [super initWithCoder:aDecoder]) {
    self.cornerRadius = [aDecoder decodeFloatForKey:kCornerRadius];
    if([aDecoder decodeObjectForKey:kPrimaryColor]) {
      self.primaryColor = [aDecoder decodeObjectForKey:kPrimaryColor];
      [self setTitleShadowColor:self.primaryColor forState:UIControlStateNormal];
    }
    else {
      self.primaryColor = [self titleColorForState:UIControlStateNormal];
    }
    if([aDecoder decodeObjectForKey:kSecondaryColor]) {
      self.secondaryColor = [aDecoder decodeObjectForKey:kSecondaryColor];
    }
    else {
      self.secondaryColor = self.backgroundColor;
    }
    [self commonInit];
    return self;
  }
  return nil;
}

- (void) awakeFromNib {
//  self.primaryColor = self.titleLabel.co

}

- (void) commonInit {
  self.layer.cornerRadius = self.cornerRadius;
  self.layer.borderColor = self.primaryColor.CGColor;
  self.layer.borderWidth = 1;
  self.backgroundColor = self.secondaryColor;
  
  [self addObserver:self forKeyPath:kCornerRadius options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
  [self addObserver:self forKeyPath:kPrimaryColor options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
  [self addObserver:self forKeyPath:kSecondaryColor options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                                ofObject:(id)object
                                change:(NSDictionary *)change
                                context:(void *)context {
  if([keyPath isEqualToString:@"cornerRadius"] && [change valueForKey:NSKeyValueChangeNewKey] != nil) {
    self.layer.cornerRadius = self.cornerRadius;
  }
}

- (void) setTitleColor:(UIColor *)color forState:(UIControlState)state {
  [super setTitleColor:color forState:state];
  if(state == UIControlStateNormal) {
    self.primaryColor = color;
  }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  
  self.backgroundColor = self.primaryColor;
  self.titleLabel.layer.opacity = 0.0f;
  self.layer.mask = [self makeLayerMask: self.bounds];
  self.layer.mask.opacity = 1;
  self.layer.masksToBounds = YES;
  [self setNeedsDisplay];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  
  self.backgroundColor = self.secondaryColor;
  self.titleLabel.layer.opacity = 1.0f;
  self.layer.mask = nil;
  [self setNeedsDisplay];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  
  self.backgroundColor = self.secondaryColor;
  self.titleLabel.layer.opacity = 1.0f;
  self.layer.mask = nil;
  [self setNeedsDisplay];
}

- (CALayer*) makeLayerMask: (CGRect) bounds {
  CALayer* alphaMask = [CALayer new];
  alphaMask.contents = (id)[self makeMaskImage: bounds];
  alphaMask.frame = bounds;
  
  return alphaMask;
}

- (CGImageRef) makeMaskImage: (CGRect) bounds {
  UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0f);
  
  UIColor* showColor = [UIColor colorWithWhite:1 alpha:1];
  UIFont* font = self.titleLabel.font;
  NSMutableParagraphStyle* paragraphStyle = [NSMutableParagraphStyle new];
  paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
  paragraphStyle.alignment = NSTextAlignmentCenter;
  
  NSDictionary* attributes = @{NSForegroundColorAttributeName: showColor, NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
  
  NSString* text = [self titleForState:UIControlStateHighlighted];
  CGSize textSize = [text sizeWithAttributes:attributes];
  CGRect textRect = CGRectMake(bounds.origin.x + floorf((bounds.size.width - textSize.width) / 2),
                               bounds.origin.y + floorf((bounds.size.height - textSize.height) / 2),
                               textSize.width,
                               textSize.height);
  
  [showColor set];
  [text drawInRect:textRect withAttributes: attributes];
  
  CGImageRef image = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
  UIGraphicsEndImageContext();
  return [self invertAlphaOfImage: image];
}

-(void) setValue:(id)value forKey:(NSString *)key
{
  if ([key isEqualToString:kCornerRadius])
  {
    self.cornerRadius = [value floatValue];
  }
}



- (CGImageRef) invertAlphaOfImage: (CGImageRef)originalMaskImage {
  float width = CGImageGetWidth(originalMaskImage);
  float height = CGImageGetHeight(originalMaskImage);
  
  // Make a bitmap context that's only 1 alpha channel
  // WARNING: the bytes per row probably needs to be a multiple of 4
  int strideLength = ROUND_UP(width * 1, 4);
  unsigned char * alphaData = calloc(strideLength * height, sizeof(unsigned char));
  CGContextRef alphaOnlyContext = CGBitmapContextCreate(alphaData,
                                                        width,
                                                        height,
                                                        8,
                                                        strideLength,
                                                        NULL,
                                                        (CGBitmapInfo) kCGImageAlphaOnly);
  
  // Draw the RGBA image into the alpha-only context.
  CGContextDrawImage(alphaOnlyContext, CGRectMake(0, 0, width, height), originalMaskImage);
  
  // Walk the pixels and invert the alpha value. This lets you colorize the opaque shapes in the original image.
  // If you want to do a traditional mask (where the opaque values block) just get rid of these loops.
  /*for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      unsigned char val = alphaData[y*strideLength + x];
      val = 255 - val;
      alphaData[y*strideLength + x] = val;
    }
  }*/
  
  CGImageRef alphaMaskImage = CGBitmapContextCreateImage(alphaOnlyContext);
  CGContextRelease(alphaOnlyContext);
  free(alphaData);
  
  // Make a mask
  CGImageRef finalMaskImage = CGImageMaskCreate(CGImageGetWidth(alphaMaskImage),
                                                CGImageGetHeight(alphaMaskImage),
                                                CGImageGetBitsPerComponent(alphaMaskImage),
                                                CGImageGetBitsPerPixel(alphaMaskImage),
                                                CGImageGetBytesPerRow(alphaMaskImage),
                                                CGImageGetDataProvider(alphaMaskImage), NULL, false);
  
  CGImageRelease(alphaMaskImage);
  return finalMaskImage;
}

- (void) dealloc {
  [self removeObserver:self forKeyPath:kCornerRadius];
  [self removeObserver:self forKeyPath:kPrimaryColor];
  [self removeObserver:self forKeyPath:kSecondaryColor];
}

@end
