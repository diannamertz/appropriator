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


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendToDoubledi:(id)sender
{
    NSURL *urlDoubledi = [NSURL URLWithString:@"http://doubledi.com"];
    [[UIApplication sharedApplication] openURL: urlDoubledi];
}

-(IBAction)sendEmailButtonPressed:(id)sender
{
    NSLog(@"sendEmailButtonPressed");
    [self.delegate returnAndSendMail];
}


@end
