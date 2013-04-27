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
{
    UIImage *portraitImage;
    UIImage *landscapeImage;
}
@end
@implementation CanvasViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// add slide gesture recognizer to show underlying toolbox view
	UITapGestureRecognizer *slideCanvasGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideCanvas:)];
	slideCanvasGesture.numberOfTapsRequired = 1;
	[self.canvasView addGestureRecognizer:slideCanvasGesture];
    
	// add a nice shadow to the canvas view
	self.canvasView.layer.shadowRadius = 4;
	self.canvasView.layer.shadowOffset = CGSizeMake(-2.0, 2.0);
	self.canvasView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.canvasView.layer.shadowOpacity = 0.6;
    
    self.imageView.layer.masksToBounds = YES;
    
    [[self.cameraButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"icon-camera.png"] forState:UIControlStateNormal];
    
    [[self.cameraRollButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.cameraRollButton setBackgroundImage:[UIImage imageNamed:@"icon-library.png"] forState:UIControlStateNormal];
    
    [[self.shareButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"icon-share.png"] forState:UIControlStateNormal];
    
    [[self.infoButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [self.infoButton setBackgroundImage:[UIImage imageNamed:@"icon-info.png"] forState:UIControlStateNormal];
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // For iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (self.view.window != nil) {
            [self.popover dismissPopoverAnimated:true];
        }
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
   
    // Keep aspect ration in tact between iPhone and iPad
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;    
    // Assume the image is in portrait mode
    portraitImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // But if not portrait mode, turn to landscape
    if (portraitImage.size.width > portraitImage.size.height) {
        landscapeImage = [[UIImage alloc] initWithCGImage: portraitImage.CGImage scale: 1.0 orientation: UIImageOrientationRight];
        self.imageView.image = landscapeImage;
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(landscapeImage,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    } else {
        self.imageView.image = portraitImage;
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(portraitImage,
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

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.screenshot.size.width, self.screenshot.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DEGREES_RADIANS(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, DEGREES_RADIANS(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.screenshot.size.width / 2, -self.screenshot.size.height / 2, self.screenshot.size.width, self.screenshot.size.height), [self.screenshot CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Capture Screenshot

- (UIImage*)screenshot
{
    /*
    if (self.imageView.image == portraitImage) {
        NSLog(@"portrait");
        CGRect rect = [self.canvasView bounds];
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.canvasView.layer renderInContext:context];
        UIImage *imageToShare = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return imageToShare;
        
    } else if (self.imageView.image == landscapeImage) {
        NSLog(@"landscape");
        CGRect rect = [self.canvasView bounds];
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.canvasView.layer renderInContext:context];
        
        UIImage *imageToShare = UIGraphicsGetImageFromCurrentImageContext();
        UIImage *rotate = [[UIImage alloc] initWithCGImage:imageToShare.CGImage scale:1.0 orientation:UIImageOrientationLeft];
        UIGraphicsEndImageContext();
        return rotate;

        
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, imageToShare.size.width, imageToShare.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
       

        
        
    } else {
        NSLog(@"not working");
    }
    */


    // This is a quarter right



    //if (self.imageView.image == landscapeImage) return self.imageView.image;
    
    // try this next: http://www.catamount.com/forums/viewtopic.php?f=21&t=967
    
    CGRect rect = [self.canvasView bounds];

    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.canvasView.layer renderInContext:context];
    UIImage *imageToShare = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageToShare;
    
    
    /*
    
    UIGraphicsBeginImageContext(imageToShare.size);
    CGContextRef newContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( newContext, 0.5f * imageToShare.size.width, 0.5f * imageToShare.size.height ) ;
    
    CGContextRotateCTM( newContext, M_PI_2 ) ;
    
    float theta;
    theta = M_PI;
    CGAffineTransform xfrm = CGAffineTransformMakeRotation(theta);
    CGRect result = CGRectApplyAffineTransform((CGRect){ { -imageToShare.size.height * 0.5f, -imageToShare.size.width * 0.5f }, imageToShare.size.height, imageToShare.size.width }, xfrm);
    
    
    //[imageToShare drawInRect:(CGRect){ { -imageToShare.size.height * 0.5f, -imageToShare.size.width * 0.5f }, imageToShare.size } ] ;
    [imageToShare drawInRect:result];
    
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage;
*/
}


#pragma mark - Share Button

-(IBAction) useShareButton: (id) sender
{
    
    
    self.sharingImage = self.screenshot;
    
    if (self.imageView.image == landscapeImage) {
    self.sharingImage = [self imageRotatedByDegrees:-90.0];
    } else if (self.imageView.image == portraitImage) {
        // do nothing
    }
    
    self.sharingText = @"Check out what I made with Appropriator!";
    


    NSArray *activityItems = [[NSArray alloc] init];
    
    if (self.sharingImage != nil) {
        activityItems = @[self.sharingText, self.sharingImage];
    } else {
        activityItems = @[self.sharingText];
    }
    
    __block UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeMessage];
    
    [self presentViewController:activityController animated:YES completion:^{ activityController.excludedActivityTypes=nil; activityController=nil;}];
}

@end
