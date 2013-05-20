//
//  InfoController.m
//  Approp
//
//  Created by Dianna Mertz on 4/24/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import "InfoController.h"

@interface InfoController ()

@end

@implementation InfoController 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.infoView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
}

-(void)dealloc
{
    self.delegate = nil;
    self.licenseDelegate = nil;
    self.infoView = nil;
}

-(IBAction)sendToDoubledi:(id)sender
{
    NSURL *urlDoubledi = [NSURL URLWithString:@"http://doubledi.com"];
    [[UIApplication sharedApplication] openURL: urlDoubledi];
}

-(IBAction)sendEmailButtonPressed:(id)sender
{
    [self.delegate returnAndSendMail];
}

-(IBAction)pressedLicenseButton:(id)sender {
    [self.licenseDelegate fetchLicenseInfo];
}


@end
