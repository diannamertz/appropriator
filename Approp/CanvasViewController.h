//
//  CanvasViewController.h
//  Approp
//
//  Created by Dianna Mertz on 10/20/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ToolboxViewController.h"
#import "UIImage+fixOrientation.h"
#import <QuartzCore/QuartzCore.h>


@interface CanvasViewController : ToolboxViewController 
<UINavigationControllerDelegate,
UIGestureRecognizerDelegate,
UIPopoverControllerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate>
{
    UIImage *portraitImage;
    UIImage *landscapeImage;
    UIImage *sharingImage;
    // CABasicAnimation *animationViewPosition;
}

@property (nonatomic, weak) IBOutlet UIButton *infoButton;
@property (nonatomic, weak) IBOutlet UIView *canvasView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic) NSString *sharingText;
@property (nonatomic) UIImage *rotateImage;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) IBOutlet UIButton *cameraButton;
@property (nonatomic, strong) IBOutlet UIButton *cameraRollButton;
@property (nonatomic, copy) NSArray *excludedActivityTypes;
@property (weak, nonatomic) IBOutlet UIImageView *pulsingFrontView;
@property (weak, nonatomic) IBOutlet UIView *patternView;

- (IBAction)camera:(id)sender;
- (IBAction)cameraRoll:(id)sender;
- (IBAction)useShareButton:(id)sender;

@end
