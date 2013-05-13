//
//  LicenseController.m
//  Approp
//
//  Created by Dianna Mertz on 5/12/13.
//  Copyright (c) 2013 Dianna Mertz. All rights reserved.
//

#import "LicenseController.h"

@interface LicenseController ()

@end

@implementation LicenseController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPaintings {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"paintings" ofType:@"plist"];
    self.paintingsArray = [NSMutableArray arrayWithContentsOfFile:path];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [self loadPaintings];
    [super viewDidLoad];
    self.titleView.backgroundColor = [UIColor colorWithRed:61.0/255.0 green:51.0/255.0 blue:46.0/255.0 alpha:1];
}

- (IBAction)backButtonWasPressed:(id)sender {
    [self.delegate dismissLicenseInfo];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.paintingsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"LicenseCell"];

    cell = [tableView dequeueReusableCellWithIdentifier:@"LicenseCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue: 245.0/255.0 alpha:1.0];
    
    [tableView setSeparatorColor:[UIColor colorWithRed:62.0/255.0 green:70.0/255.0 blue: 81.0/255.0 alpha:1.0]];
    
    // Call the info from the paintings.plist and distribute to cells
    NSDictionary *paintingsInfo = [self.paintingsArray objectAtIndex:indexPath.row];
    
    [[cell textLabel] setText:[paintingsInfo objectForKey:@"name"]];
    [[cell textLabel] setTextColor:[UIColor colorWithRed:62.0/255.0 green:70.0/255.0 blue: 81.0/255.0 alpha:1.0]];
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    
    [[cell detailTextLabel] setText:[paintingsInfo objectForKey:@"title"]];
    [[cell detailTextLabel] setTextColor:[UIColor colorWithRed:62.0/255.0 green:70.0/255.0 blue: 81.0/255.0 alpha:1.0]];
    [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *paintingsInfo = [self.paintingsArray objectAtIndex:indexPath.row];
    
    NSURL *urlDoubledi = [NSURL URLWithString:[paintingsInfo objectForKey:@"link"]];
    [[UIApplication sharedApplication] openURL: urlDoubledi];
}

@end
