//
//  ToolboxViewController.h
//  Approp
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <QuartzCore/QuartzCore.h>
#import "InfoController.h"
#import "LicenseController.h"

@interface ToolboxViewController : UIViewController <	LicenseDelegate,
                                                        UITableViewDataSource,
														UITableViewDelegate,
														UIImagePickerControllerDelegate,
														UIGestureRecognizerDelegate,
														InfoControllerDelegate,
														MFMailComposeViewControllerDelegate,
                                                        DismissLicenseControllerDelegate
                                                        >
{
    BOOL newMedia;
}

@property (nonatomic, weak) IBOutlet UIView *theNewPaintingView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *paintingsArray;
@property (weak, nonatomic) IBOutlet UIView *toolboxTopView;

- (void)addGestureRecognizersToView:(UIView*)aView;
- (void)handlePan:(UIPanGestureRecognizer*)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer;
- (void)handleRotation:(UIRotationGestureRecognizer*)recognizer;
- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer;
- (void)returnAndSendMail;
-(void)fetchLicenseInfo;
-(void)dismissLicenseInfo;

@end



