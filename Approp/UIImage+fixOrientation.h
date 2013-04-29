//
//  UIImage+fixOrientation.h
//  Approp
//
//  Created by Dianna Mertz on 4/28/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
