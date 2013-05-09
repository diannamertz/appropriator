//
//  ToolboxTopView.m
//  Approp
//
//  Created by Dianna Mertz on 5/9/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import "ToolboxTopView.h"

@implementation ToolboxTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    CGContextSetFillColorWithColor(context, redColor.CGColor);
    CGContextFillRect(context, self.bounds);
}

@end
