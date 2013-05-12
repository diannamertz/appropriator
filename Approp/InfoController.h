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

@protocol LicenseDelegate <NSObject>
-(void)fetchLicenseInfo;
@end

@interface InfoController : UIViewController

@property (assign) id<InfoControllerDelegate> delegate;

@property (assign) id<LicenseDelegate> licenseDelegate;

@property (strong, nonatomic) IBOutlet UIView *infoView;

-(IBAction)sendToDoubledi:(id)sender;
-(IBAction)sendEmailButtonPressed:(id)sender;
-(IBAction)pressedLicenseButton:(id)sender;


@end


