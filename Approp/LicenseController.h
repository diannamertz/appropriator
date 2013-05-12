//
//  LicenseController.h
//  Approp
//
//  Created by Dianna Mertz on 5/12/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissLicenseControllerDelegate <NSObject>
-(void)dismissLicenseInfo;
@end

@interface LicenseController : UIViewController 

@property (nonatomic, assign) id<DismissLicenseControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonWasPressed:(id)sender;

@end
