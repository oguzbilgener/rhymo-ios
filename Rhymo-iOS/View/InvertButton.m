//
//  InvertButton.m
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 23/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

#import "InvertButton.h"

@implementation InvertButton

- (id) init: (CGRect) rect {
  if ( self = [super init] ) {
    
    return self;
  }
  return nil;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
  if(self = [super initWithCoder:aDecoder]) {
    [self commonInit];
    return self;
  }
  return nil;
}

- (void) commonInit {
  self.layer.cornerRadius = 5;
  self.layer.borderColor = self.primaryColor.CGColor;
  self.layer.borderWidth = 1;
  self.backgroundColor = self.secondaryColor;
  
  UIImage* textImage = [InvertButton drawTextImage:self.titleLabel.text font:self.titleLabel.font rect:self.frame];
  UIImage* targetImage;
  UIImage* invertMask = [InvertButton createInvertMask:textImage withTargetImage:targetImage];
  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (UIImage*) drawTextImage:(NSString*)text font:(UIFont*)font rect:(CGRect)rect {
  UIGraphicsBeginImageContext(rect.size);
  [[UIColor whiteColor] set];
  [text drawInRect:rect withAttributes: @{NSFontAttributeName: font}];
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

+ (UIImage*) createInvertMask:(UIImage *)maskImage withTargetImage:(UIImage *) image {
  
  CGImageRef maskRef = maskImage.CGImage;
  
  CGBitmapInfo bitmapInfo = kCGImageAlphaNone;
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  
  CGImageRef mask = CGImageCreate(CGImageGetWidth(maskRef),
                                  CGImageGetHeight(maskRef),
                                  CGImageGetBitsPerComponent(maskRef),
                                  CGImageGetBitsPerPixel(maskRef),
                                  CGImageGetBytesPerRow(maskRef),
                                  CGColorSpaceCreateDeviceGray(),
                                  bitmapInfo,
                                  CGImageGetDataProvider(maskRef),
                                  nil, NO,
                                  renderingIntent);
  
  
  CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
  
  CGImageRelease(mask);
  CGImageRelease(maskRef);
  
  return [UIImage imageWithCGImage:masked];
}

+ (void) maskWithImage:(UIImage*) maskImage TargetView:(UIView*) targetView{
  CALayer *_maskingLayer = [CALayer layer];
  _maskingLayer.frame = targetView.bounds;
  [_maskingLayer setContents:(id)[maskImage CGImage]];
  [targetView.layer setMask:_maskingLayer];
}

@end
