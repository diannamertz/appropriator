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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAnimation:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseAnimation:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    self.animationViewPosition = [CABasicAnimation animationWithKeyPath:@"position"];
    [self pulse:self.pulsingFrontView];
}

- (void)dealloc {
    self.infoButton = nil;
    self.canvasView = nil;
    self.imageView = nil;
    self.shareButton = nil;
    self.sharingText = nil;
    self.rotateImage = nil;
    self.popover = nil;
    self.cameraButton = nil;
    self.cameraRollButton = nil;
    self.excludedActivityTypes = nil;
    self.pulsingFrontView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object: nil];
}

#pragma mark - Canvas Animations

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)pauseAnimation: (NSNotification*)note
{
    NSLog(@"%@", self.animationViewPosition);  // This returns CAAnimation
    NSLog(@"%@", self.pulsingFrontView.layer); // This returns CALayer
    self.animationViewPosition = [[self.pulsingFrontView.layer animationForKey:@"position"] copy];
    NSLog(@"%@", self.animationViewPosition); // This returns null
    NSLog(@"%@", self.pulsingFrontView.layer); // This returns CALayer
    [self pauseLayer:self.pulsingFrontView.layer];
    NSLog(@"pause");
}

-(void)resumeAnimation: (NSNotification*)note
{
    NSLog(@"%@", self.animationViewPosition); // This returns null
    if (self.animationViewPosition != nil)
    {
        [self.pulsingFrontView.layer addAnimation:self.animationViewPosition forKey:@"position"];
        self.animationViewPosition = nil;
    }
    [self resumeLayer:self.pulsingFrontView.layer];

    NSLog(@"resume");
}

- (void)pulse:(UIImageView*)imageView;
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState)
                     animations:(void (^)(void)) ^{
                         self.pulsingFrontView.transform=CGAffineTransformMakeScale(0.7, 0.7);
                     }
                     completion:nil];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
   
    // Keep aspect ration in tact between iPhone and iPad
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Assume the image is in portrait mode
    portraitImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Save original image to Photo Library, in the original orientation
    if (newMedia)
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

- (IBAction) useShareButton: (id) sender
{
    sharingImage = self.screenshot;

    if (self.imageView.image == NULL) {
        
    } else if (self.imageView.image == landscapeImage) {
        sharingImage = [sharingImage imageRotatedByDegrees:-90.0];
    }  
    
    self.sharingText = @"Check out what I made with Appropriator!";
    
    NSArray *activityItems = [[NSArray alloc] init];
    
    if (sharingImage != nil) {
        activityItems = @[self.sharingText, sharingImage];
    } else {
        activityItems = @[self.sharingText];
    }
    
    __block UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeMessage];
    
    [self presentViewController:activityController animated:YES completion:^{ activityController.excludedActivityTypes=nil; activityController=nil;}];
}

@end
