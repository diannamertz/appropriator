//
//  ToolboxViewController.m
//  Approp
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import "ToolboxViewController.h"


@interface ToolboxViewController ()
{
    UIView *viewToEdit;
    UIImageView *newPaintingView;
}
@end

@implementation ToolboxViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPaintings {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"paintings" ofType:@"plist"];
    self.paintingsArray = [NSMutableArray arrayWithContentsOfFile:path];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the data from the plist
    [self loadPaintings];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    self.theNewPaintingView.layer.masksToBounds = YES;
    
    self.toolboxTopView.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:70.0/255.0 blue:81.0/255.0 alpha:1];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc {
	self.theNewPaintingView = nil;
    self.tableView = nil;
    self.paintingsArray = nil;
    self.toolboxTopView = nil;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paintingsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.toolboxTopView.bounds];
    self.toolboxTopView.layer.masksToBounds = NO;
    self.toolboxTopView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.toolboxTopView.layer.shadowOffset = CGSizeMake(-2.0f, 2.0f);
    self.toolboxTopView.layer.shadowOpacity = 0.4f;
    self.toolboxTopView.layer.shadowRadius = 4;
    self.toolboxTopView.layer.shadowPath = shadowPath.CGPath;
    
    // Cell
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue: 245.0/255.0 alpha:1.0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    UIView *bgColorView = [[UIView alloc] initWithFrame:cell.frame];
    bgColorView.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    
    [tableView setSeparatorColor:[UIColor colorWithRed:62.0/255.0 green:70.0/255.0 blue: 81.0/255.0 alpha:1.0]];
    
    // Call the info from the paintings.plist and distribute to cells
    NSDictionary *paintingsInfo = [self.paintingsArray objectAtIndex:indexPath.row];
    
    UIImageView *paintingsImage = (UIImageView *)[cell viewWithTag:100];
    paintingsImage.image = [UIImage imageNamed:[paintingsInfo objectForKey:@"image"]];
    paintingsImage.opaque = YES;
    paintingsImage.backgroundColor = [UIColor clearColor];
    
    UILabel *paintingArtist = (UILabel *)[cell viewWithTag:101];
    paintingArtist.text = [paintingsInfo objectForKey:@"name"];
    paintingArtist.textColor = [UIColor colorWithRed:62.0/255.0 green:70.0/255.0 blue: 81.0/255.0 alpha:1.0];
    paintingArtist.backgroundColor = [UIColor clearColor];
    
    UILabel *paintingTitle = (UILabel *)[cell viewWithTag:102];
    paintingTitle.text = [paintingsInfo objectForKey:@"title"];
    paintingTitle.textColor = [UIColor colorWithRed:62.0/255.0 green:70.0/255.0 blue: 81.0/255.0 alpha:1.0];
    paintingTitle.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *paintingsInfo = [self.paintingsArray objectAtIndex:indexPath.row];
    
    NSMutableArray *paintingNumber = [[NSMutableArray alloc] init];
        
    newPaintingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[paintingsInfo objectForKey:@"image_top"]]];
    newPaintingView.tag = 10;
    
    newPaintingView.contentMode = UIViewContentModeScaleAspectFit;

    CGRect frame = newPaintingView.frame;
    frame.size.height = 200;
    frame.size.width = 200;
    newPaintingView.frame = frame;
    newPaintingView.userInteractionEnabled = YES;
    
    [self addGestureRecognizersToView:newPaintingView];

    [paintingNumber addObject:newPaintingView];
    
    [self.theNewPaintingView addSubview:[paintingNumber objectAtIndex:([paintingNumber count]-1)]];
    
    // improves performance
    self.theNewPaintingView.layer.shouldRasterize = YES;
    // adds retina screen support
    self.theNewPaintingView.layer.rasterizationScale = self.view.window.screen.scale;
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
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    rotationGesture.delegate = self;
    [aView addGestureRecognizer:rotationGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.delegate = self;
    [aView addGestureRecognizer:longPressGesture];
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

-(void)handleLongPress:(UILongPressGestureRecognizer*)recognizer
{
    viewToEdit = recognizer.view;
    recognizer.minimumPressDuration = 1.0;
    if(recognizer.state == UIGestureRecognizerStateBegan ||
       recognizer.state == UIGestureRecognizerStateChanged
       ) {
        [self becomeFirstResponder];
    }
  
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *flipItem = [[UIMenuItem alloc] initWithTitle:@"Flip" action:@selector(flipAction:)];
    UIMenuItem *frontItem = [[UIMenuItem alloc] initWithTitle:@"Bring to front" action:@selector(frontAction:)];
    UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteAction:)];
    [UIMenuController sharedMenuController].menuItems = @[flipItem, frontItem, deleteItem];
    [menuController setTargetRect:CGRectMake(viewToEdit.center.x, viewToEdit.center.y, 0, 0) inView:self.view];
    [menuController setMenuVisible:YES animated:YES];
}

#pragma mark - UIMenuController
-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(flipAction:) ||
        action == @selector(frontAction:) ||
        action == @selector(deleteAction:))
        return YES;

    return [super canPerformAction:action withSender:sender];
}

-(void)flipAction:(id)sender {
    UIImageView *viewToFlip = (UIImageView*)[viewToEdit viewWithTag:10];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if ((viewToFlip.image.imageOrientation == UIImageOrientationUp)) {
                         viewToFlip.image = [UIImage imageWithCGImage:[viewToFlip.image CGImage] scale:1.0 orientation:UIImageOrientationUpMirrored];
                         } else if ((viewToFlip.image.imageOrientation == UIImageOrientationUpMirrored)) {
                         viewToFlip.image = [UIImage imageWithCGImage:[viewToFlip.image CGImage] scale:1.0 orientation:UIImageOrientationUp];
                         }
                     }
                     completion:nil];    
}
     
-(void)frontAction:(id)sender {
    [self.theNewPaintingView bringSubviewToFront:viewToEdit];
    
}

-(void)deleteAction:(id)sender {
    [viewToEdit removeFromSuperview];
}


#pragma mark - InfoController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([segue.identifier isEqualToString:@"infoControllerSegue"]) {

		InfoController *infoController = (InfoController*)segue.destinationViewController;
		infoController.delegate = self;		// important!
        infoController.licenseDelegate = self;

        
	}
}

-(void)returnAndSendMail {
	// dismiss the infoViewController
    [self dismissViewControllerAnimated:YES completion:^{
		// and create the mailComposer
		MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
		mailComposer.mailComposeDelegate = self;
        [mailComposer setToRecipients:@[@"diannamertz@gmail.com"]];
		[mailComposer setSubject:@"re: Appropriator"];
		[self presentViewController:mailComposer animated:YES completion:nil];
    }];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)fetchLicenseInfo {
    [self dismissViewControllerAnimated:YES completion:^{
        LicenseController *licenseController = [self.storyboard instantiateViewControllerWithIdentifier:@"LicenseControllerID"];
        licenseController.delegate = self;
        licenseController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:licenseController animated:YES completion:nil];
    }];
}

-(void)dismissLicenseInfo {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
