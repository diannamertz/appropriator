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

@property (nonatomic, strong) IBOutlet UIView *canvasView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *viewA;
@property (weak, nonatomic) IBOutlet UIImageView *viewB;
@property (weak, nonatomic) IBOutlet UIImageView *viewC;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic) NSString *sharingText;
@property (nonatomic) UIImage *sharingImage;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) UIActionSheet *actionSheet;

- (IBAction)useShareButton:(id)sender;

- (void)addGestureRecognizersToView:(UIView*)aView;
- (void)handlePan:(UIPanGestureRecognizer*)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer;
- (void)handleRotation:(UIRotationGestureRecognizer*)recognizer;
- (void)handleTap:(UITapGestureRecognizer*)recognizer;
- (void)handleSwipe:(UISwipeGestureRecognizer*)recognizer;


@property (nonatomic, strong) IBOutlet UIButton *cameraButton;
@property (nonatomic, strong) IBOutlet UIButton *cameraRollButton;

- (IBAction)camera:(id)sender;
- (IBAction)cameraRoll:(id)sender;




@end
