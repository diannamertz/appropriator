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
#import <dispatch/dispatch.h>


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
    dispatch_queue_t backgroundQueue;
    BOOL newMedia;
}

@property (nonatomic, weak) IBOutlet UIButton *infoButton;
@property (nonatomic, weak) IBOutlet UIView *canvasView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) NSString *sharingText;
@property (nonatomic, strong) IBOutlet UIButton *cameraButton;
@property (nonatomic, strong) IBOutlet UIButton *cameraRollButton;
@property (nonatomic, copy) NSArray *excludedActivityTypes;
@property (nonatomic, weak) IBOutlet UIImageView *patternView;

- (IBAction)camera:(id)sender;
- (IBAction)cameraRoll:(id)sender;
- (IBAction)useShareButton:(id)sender;

@end
