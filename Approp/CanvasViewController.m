//
//  CanvasViewController.m
//  Approp
//
//  Created by Dianna Mertz on 10/20/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import "CanvasViewController.h"


@interface CanvasViewController()
@end
@implementation CanvasViewController
@synthesize canvasView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addGestureRecognizersToView:self.viewA];
    [self addGestureRecognizersToView:self.viewB];
    [self addGestureRecognizersToView:self.viewC];
	
	// add slide gesture recognizer to show underlying toolbox view
	UITapGestureRecognizer *slideCanvasGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideCanvas:)];
	slideCanvasGesture.numberOfTapsRequired = 1;
	[self.canvasView addGestureRecognizer:slideCanvasGesture];
	
	// add a nice shadow to the canvas view
	self.canvasView.layer.shadowRadius = 4;
	self.canvasView.layer.shadowOffset = CGSizeMake(-2.0, 2.0);
	self.canvasView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.canvasView.layer.shadowOpacity = 0.6;
}


#pragma mark - Gesture Recognizers

// Thanks, Michael Markert!!!

- (void)addGestureRecognizersToView:(UIView*)aView {
    // add pan gesture (to move)
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [aView addGestureRecognizer:panGesture];
    
    // add pinch gesture (to zoom)
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture.delegate = self;
    [aView addGestureRecognizer:pinchGesture];
    
    
    // add rotation gesture (to rotate)
    UIRotationGestureRecognizer *rotationGesture =
    [[UIRotationGestureRecognizer alloc] initWithTarget:self action:
     @selector(handleRotation:)];
    rotationGesture.delegate = self;
    [aView addGestureRecognizer:rotationGesture];
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    
    UIView *theView = recognizer.view;
    if(recognizer.state == UIGestureRecognizerStateBegan ||
       recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint center = theView.center;
        CGPoint translation = [recognizer translationInView:theView.superview];
        
        theView.center = CGPointMake(center.x + translation.x, center.y + translation.y);
        //accumulated offset => reset translation of GestureRecognizer
        [recognizer setTranslation:CGPointZero inView:theView.superview];
        
        /*
         CGPoint translation = [recognizer translationInView:self.view];
         recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
         [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
         */
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    UIView *theView = recognizer.view;
    if(recognizer.state == UIGestureRecognizerStateBegan ||
       recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = recognizer.scale;
        theView.transform = CGAffineTransformScale(theView.transform, scale,
                                                   scale);
        recognizer.scale = 1;   // reset to prevent accumulated offset
    }
}

- (void)handleRotation:(UIRotationGestureRecognizer*)recognizer
{
    UIView *theView = recognizer.view;
    if(recognizer.state == UIGestureRecognizerStateBegan ||
       recognizer.state == UIGestureRecognizerStateChanged) {
        theView.transform = CGAffineTransformRotate(theView.transform,
                                                    recognizer.rotation);
        recognizer.rotation = 0;
    }
}

- (void)slideCanvas:(UITapGestureRecognizer*)tapGesture {

    CGRect canvasFrame = canvasView.frame;
    canvasFrame.origin.x = canvasView.bounds.size.width - 40;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         canvasView.frame = canvasFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    
}



#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	// we don't want the canvas be moved along with other recognizers
	if(gestureRecognizer.view == self.canvasView || otherGestureRecognizer.view == self.canvasView) {
		return NO;
	} else {
		return YES;
	}
}

#pragma mark - Canvas Button

//- (void)useCamera
- (IBAction)camera:(id)sender;
{
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypeCamera])
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

//-(void)useCameraRoll:(id)sender
- (IBAction)cameraRoll:(id)sender;
{
    // For iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        if ([self.popover isPopoverVisible]) {
            [self.popover dismissPopoverAnimated:YES];
        } else {
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                imagePicker.allowsEditing = NO;
                self.popover = [[UIPopoverController alloc]
                                initWithContentViewController:imagePicker];
                self.popover.delegate = self;
                
                //[self.popover presentPopoverFromRect:[sender bounds] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                [self.popover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
                
                newMedia = NO;
            }
        }
    } else {
        
        // For iPhone
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
            newMedia = NO;
        }
    }
}


// Choose and Load the image from the library
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // For iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.view.window != nil) {
            [self.popover dismissPopoverAnimated:true];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // Keep aspect ration in tact between iPhone and iPad
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
    // Assume the image is in portrait mode
    UIImage * PortraitImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    // But if not portrait mode, turn to landscape
    if (PortraitImage.size.width > PortraitImage.size.height) {
        UIImage * LandscapeImage =
        [[UIImage alloc] initWithCGImage: PortraitImage.CGImage
                                   scale: 1.0
                             orientation: UIImageOrientationRight];
        self.imageView.image = LandscapeImage;
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(LandscapeImage,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    } else {
        self.imageView.image = PortraitImage;
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(PortraitImage,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
}

// Method for a problem saving
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
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


#pragma mark - Capture Screenshot

- (UIImage*)screenshot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *imageToShare = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageToShare;
}



#pragma mark - Share Button

-(IBAction) useShareButton: (id) sender {
    
    //self.sharingImage = self.imageView.image;
    self.sharingImage = self.screenshot;
    self.sharingText = @"Check out what I made with Appropriator!";
    
    NSArray *activityItems;
    
    if (self.sharingImage != nil) {
        activityItems = @[self.sharingText, self.sharingImage];
    } else {
        activityItems = @[self.sharingText];
    }
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}

@end
