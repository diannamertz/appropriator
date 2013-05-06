//
//  InfoController.h
//  Approp
//
//  Created by Dianna Mertz on 4/24/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ToolboxViewController.h"

@interface InfoController : UIViewController //<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendToDoubledi;
@property (weak, nonatomic) IBOutlet UIButton *emailMeButton;

//@property(nonatomic,assign) id<MFMailComposeViewControllerDelegate> mailComposeDelegate;

-(IBAction)sendToDoubledi:(id)sender;
-(IBAction)emailMe:(id)sender;

@end


