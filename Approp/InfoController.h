//
//  InfoController.h
//  Approp
//
//  Created by Dianna Mertz on 4/24/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InfoControllerDelegate <NSObject>

- (void)returnAndSendMail;

@end


@interface InfoController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *sendToDoubledi;
@property (weak, nonatomic) IBOutlet UIButton *emailMeButton;

@property (assign) id<InfoControllerDelegate> delegate;

-(IBAction)sendToDoubledi:(id)sender;
-(IBAction)sendEmailButtonPressed:(id)sender;

@end


