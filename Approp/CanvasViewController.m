//
//  CanvasViewController.m
//  Approp
//
//  Created by Dianna Mertz on 10/20/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import "CanvasViewController.h"
#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface CanvasViewController()
@property (copy) CABasicAnimation *animationViewPosition;
@end

@implementation CanvasViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    if (IS_IPHONE5) {
        self.patternView.image = [UIImage imageNamed:@"pattern-568@2x.png"];
        self.patternView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.patternView.image = [UIImage imageNamed:@"pattern@2x.png"];
        self.patternView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
	// add slide gesture recognizer to show underlying toolbox view
	UITapGestureRecognizer *slideCanvasGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideCanvas:)];
	slideCanvasGesture.numberOfTapsRequired = 1;
	[self.canvasView addGestureRecognizer:slideCanvasGesture];
    
    self.imageView.layer.masksToBounds = YES;
    
    [[self.cameraButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"icon-camera.png"] forState:UIControlStateNormal];
    
    [[self.cameraRollButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.cameraRollButton setBackgroundImage:[UIImage imageNamed:@"icon-library.png"] forState:UIControlStateNormal];
    
    [[self.shareButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"icon-share.png"] forState:UIControlStateNormal];
    
    [[self.infoButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.infoButton setBackgroundImage:[UIImage imageNamed:@"icon-info.png"] forState:UIControlStateNormal];
    [[self.infoButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    
    backgroundQueue = dispatch_queue_create("com.doubledi.approp.bgqueue", NULL);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc {
    self.infoButton = nil;
    self.canvasView = nil;
    self.imageView = nil;
    self.shareButton = nil;
    self.sharingText = nil;
    self.cameraButton = nil;
    self.cameraRollButton = nil;
    self.excludedActivityTypes = nil;
    self.patternView = nil;
}

- (void)slideCanvas:(UITapGestureRecognizer*)tapGesture {
    
    CGPoint canvasCenter = super.view.center;
    
    CGRect canvasRight = self.canvasView.frame;
    canvasRight.origin.x = self.canvasView.bounds.size.width - 40;
    
    if (self.canvasView.center.x == super.view.center.x) {
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.canvasView.frame = canvasRight;
                             
                             UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.canvasView.bounds];
                             self.canvasView.layer.masksToBounds = NO;
                             self.canvasView.layer.shadowColor = [UIColor blackColor].CGColor;
                             self.canvasView.layer.shadowOffset = CGSizeMake(-2.0f, 2.0f);
                             self.canvasView.layer.shadowOpacity = 0.6f;
                             self.canvasView.layer.shadowPath = shadowPath.CGPath;
                             
                         }
                         completion:^(BOOL finished){
                         }];
    } else {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.canvasView.center = canvasCenter;
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

#pragma mark - Camera and Photo Buttons

- (IBAction)camera:(id)sender;
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = YES;
    }
}

- (IBAction)cameraRoll:(id)sender;
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    } else if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // for iOS7
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Keep aspect ration in tact between iPhone and iPad
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Assume the image is in portrait mode
    portraitImage = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Save original image to Photo Library, in the original orientation (but only if image is a new image taken from the camera -- not camera roll)
    if (portraitImage && newMedia)
        UIImageWriteToSavedPhotosAlbum(portraitImage,
                                       self,
                                       @selector(image:finishedSavingWithError:contextInfo:),
                                       nil);
    
    portraitImage = [portraitImage fixOrientation];
    
    // But if not portrait mode, turn to landscape
    if (portraitImage.size.width > portraitImage.size.height) {
        landscapeImage = [[UIImage alloc] initWithCGImage: portraitImage.CGImage scale: 1.0 orientation: UIImageOrientationRight];
        self.imageView.image = landscapeImage;
        
    } else {
        self.imageView.image = portraitImage;
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // for iOS7
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Save failed"
                                                        message: @"Failed to save image"\
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Share Button
// from http://stackoverflow.com/questions/11104042/how-to-get-a-rotated-zoomed-and-panned-image-from-an-uiimageview-at-its-full-re

- (UIImage*)screenshot
{    
    float effectiveScale = .55;
    if (self.imageView.image == portraitImage) {
        effectiveScale = 0.6;
    } else if (self.imageView.image == landscapeImage) {
        effectiveScale = 0.5;
    }
    
    CGSize captureSize = CGSizeMake((self.canvasView.bounds.size.width / effectiveScale), (self.canvasView.bounds.size.height / effectiveScale));
    
    UIGraphicsBeginImageContextWithOptions(captureSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1/effectiveScale, 1/effectiveScale);
    [self.canvasView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (IBAction) useShareButton: (id) sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (self.imageView.image == landscapeImage) {
            sharingImage = [self.screenshot imageRotatedByDegrees:-90.0];
        } else if (self.imageView.image == portraitImage) {
            sharingImage = self.screenshot;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.sharingText = @"Made with #Appropriator\nhttp://doubledi.com/appropriator.html";
            
            NSArray *activityItems;
            if (sharingImage != nil) {
                activityItems = @[self.sharingText, sharingImage];
            } else {
                activityItems = @[self.sharingText];
            }
            
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeMessage];
            [self presentViewController:activityController animated:YES completion:NULL];   // you really don't want to release the activity items while the activity controller is active. the completion block is executed when the activity controller _PRENSENTATION_ is completed, that means, as soon as it's fully on screen! All these vars are local, so just leave it to arc to release them.
            
        });
    });
}

@end
