//
//  InfoController.h
//  Approp
//
//  Created by Dianna Mertz on 4/24/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolboxViewController.h"

@interface InfoController : UIViewController <ToolboxViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendToDoubledi;
@property (weak, nonatomic) IBOutlet UIButton *emailMeButton;

@property (nonatomic, assign) id<ToolboxViewControllerDelegate> toolboxViewControllerDelegate;

-(IBAction)sendToDoubledi:(id)sender;
-(IBAction)sendEmailButtonPressed:(id)sender;

@end


