//
//  Common.h
//  Approp
//
//  Created by Dianna Mertz on 5/9/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

CGRect rectFor1PxStroke(CGRect rect);

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);