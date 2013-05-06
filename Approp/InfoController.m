//
//  InfoController.m
//  Approp
//
//  Created by Dianna Mertz on 4/24/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import "InfoController.h"

@interface InfoController ()
{
    ToolboxViewController *tvc;
}

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

- (IBAction)emailMe:(id)sender {
    tvc = (ToolboxViewController *)self.presentingViewController;
    [tvc dismissViewControllerAnimated:YES completion:^{
        MFMailComposeViewController *mailController =
        [[MFMailComposeViewController alloc] init];
        if([MFMailComposeViewController canSendMail]){
            if(mailController) {
                mailController.mailComposeDelegate = tvc;
                [mailController setToRecipients:@[@"diannamertz@gmail.com"]];
                [mailController setSubject:@"Appropriator"];
                [mailController setMessageBody:@"" isHTML:YES];
                [tvc presentViewController:mailController
                                           animated:YES
                                         completion:nil];
            }
        }
    }];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    NSLog(@"%@", tvc);
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's sent!");
    }
    
    [tvc dismissViewControllerAnimated:YES completion:nil];
}




@end
