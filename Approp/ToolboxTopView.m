//
//  ToolboxTopView.m
//  Approp
//
//  Created by Dianna Mertz on 5/9/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import "ToolboxTopView.h"
#import "Common.h"

@interface ToolboxTopView()

@property (nonatomic, assign) CGRect paperRect;
@property (nonatomic, assign) CGRect coloredBoxRect;
@end

@implementation ToolboxTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.lightGrayColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue: 255.0/255.0 alpha:1.0];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * blueColor = [UIColor colorWithRed:62.0/255.0 green:70.0/255.0 blue: 81.0/255.0 alpha:1.0];
    
    CGContextSetFillColorWithColor(context, blueColor.CGColor);
    CGContextFillRect(context, self.bounds);
    
    self.layer.shadowRadius = 4;
	self.layer.shadowOffset = CGSizeMake(-2.0, 2.0);
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOpacity = 0.3;
}
@end
