//
//  ToolboxViewController.h
//  Approp
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolboxViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UIGestureRecognizerDelegate>
{
    BOOL newMedia;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *paintingsArray;


@end





