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

#import "InfoController.h"

@interface ToolboxViewController : UIViewController <	UITableViewDataSource,
														UITableViewDelegate,
														UIImagePickerControllerDelegate,
														UIGestureRecognizerDelegate,
														InfoControllerDelegate,
														MFMailComposeViewControllerDelegate>
{
    BOOL newMedia;
}

@property (nonatomic, weak) IBOutlet UIView *theNewPaintingView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *paintingsArray;
@property (nonatomic, strong) MFMailComposeViewController *mailComposer;


- (void)addGestureRecognizersToView:(UIView*)aView;
- (void)handlePan:(UIPanGestureRecognizer*)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer;
- (void)handleRotation:(UIRotationGestureRecognizer*)recognizer;
- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer;

- (void)returnAndSendMail;

@end



