//
//  ToolboxViewController.h
//  Approp
//
//  Created by Dianna Mertz on 11/2/12.
//  Copyright (c) 2012 Dianna Mertz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaintingSelectionDelegate <NSObject>
@required
-(void)selectedThePainting:(UIImage *)newPainting;
@end

@interface ToolboxViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UIGestureRecognizerDelegate>
{
    BOOL newMedia;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *paintingsArray;
@property (nonatomic, assign) id<PaintingSelectionDelegate> paintingsDelegate;


@end





