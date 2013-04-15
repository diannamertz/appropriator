//
//  CanvasViewController.h
//  Approp
//
//  Created by Dianna Mertz on 10/20/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>	// needed for shadow
#import "ToolboxViewController.h"

@interface CanvasViewController : ToolboxViewController 
<UINavigationControllerDelegate,
UIGestureRecognizerDelegate,
UIPopoverControllerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *canvasView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic) NSString *sharingText;
@property (nonatomic) UIImage *sharingImage;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) IBOutlet UIButton *cameraButton;
@property (nonatomic, strong) IBOutlet UIButton *cameraRollButton;

- (IBAction)camera:(id)sender;
- (IBAction)cameraRoll:(id)sender;
- (IBAction)useShareButton:(id)sender;


@end
