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

@protocol ToolboxViewControllerDelegate <NSObject>
- (void)returnAndSendMail;
@end

@interface ToolboxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>
{
    BOOL newMedia;
}
@property (nonatomic, weak) IBOutlet UIView *theNewPaintingView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *paintingsArray;
@property (nonatomic, strong) MFMailComposeViewController *mailComposer;
//@property (nonatomic, strong) InfoController *infoController;
@property(nonatomic,assign) id<MFMailComposeViewControllerDelegate> mailComposeDelegate;


- (void)addGestureRecognizersToView:(UIView*)aView;
- (void)handlePan:(UIPanGestureRecognizer*)recognizer;
- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer;
- (void)handleRotation:(UIRotationGestureRecognizer*)recognizer;
- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer;

@end



