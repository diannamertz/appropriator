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

@interface LicenseController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<DismissLicenseControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) NSMutableArray *paintingsArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *titleView;

- (IBAction)backButtonWasPressed:(id)sender;


@end
