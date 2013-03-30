//
//  ToolboxViewController.m
//  Approp
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import "ToolboxViewController.h"

@interface ToolboxViewController ()

@end

@implementation ToolboxViewController


// Method to load the paintings array from the plist
- (void)loadPaintings {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"paintings" ofType:@"plist"];
    self.paintingsArray = [NSMutableArray arrayWithContentsOfFile:path];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    // Load the data from the plist
    [self loadPaintings];
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Call the info from the paintings.plist and distribute to cells
    NSDictionary *paintingsInfo = [self.paintingsArray objectAtIndex:indexPath.row];
    
    UIImageView *paintingsImage = (UIImageView *)[cell viewWithTag:100];
    paintingsImage.image = [UIImage imageNamed:[paintingsInfo objectForKey:@"image"]];
    
    UILabel *paintingArtist = (UILabel *)[cell viewWithTag:101];
    paintingArtist.text = [paintingsInfo objectForKey:@"name"];
    
    UILabel *paintingTitle = (UILabel *)[cell viewWithTag:102];
    paintingTitle.text = [paintingsInfo objectForKey:@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Call the info from the paintings.plist and distribute to cells
    NSDictionary *paintingsInfo = [self.paintingsArray objectAtIndex:indexPath.row];
    
    UIImage *selectedPainting = [paintingsInfo objectForKey:@"image_top"];
    
    [self.paintingsDelegate selectedThePainting:selectedPainting];
    
    NSLog(@"%@", selectedPainting);

}

@end
