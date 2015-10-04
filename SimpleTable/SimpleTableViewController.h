//
//  SimpleTableViewController.h
//  SimpleTable

//  Author: Matt Lee
//  VandyHacks fall 15
//  github.com/mllee
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface SimpleTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *freeButtons;
@property (weak, nonatomic) IBOutlet UIImageView *myStatus;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;


@end
