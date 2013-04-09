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
    
    CGPoint canvasCenter = super.view.center;
    
    CGRect canvasRight = self.canvasView.frame;
    canvasRight.origin.x = self.canvasView.bounds.size.width - 40;

    if (self.canvasView.center.x == super.view.center.x) {
        
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.canvasView.frame = canvasRight;
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
    CGRect rect = [self.canvasView bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.canvasView.layer renderInContext:context];

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
