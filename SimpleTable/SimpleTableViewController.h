//
//  SimpleTableViewController.h
//  SimpleTable

//  Author: Matt Lee
//  github.com/mllee (though i dont even have this on github yet lol)
//
//
//  Shell from which I started by Simon on 1/12/13, (c) 2013 Appcoda
//  He made a static view that just displayed a hard coded list;
//  I started building from there so I wouldn't have to worry about the initial
//  hooking up of the view controller.

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface SimpleTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *freeButtons;
@property (weak, nonatomic) IBOutlet UIImageView *myStatus;


@end
