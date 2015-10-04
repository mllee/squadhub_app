//  SimpleTableViewController.m
//  Table
//
//  Author: Matt Lee
//  github.com/mllee (though i dont even have this on github yet lol)
//
//
//  Shell from which I started by Simon on 1/12/13, (c) 2013 Appcoda
//  He made a static view that just displayed a hard coded list;
//  I started building from there so I wouldn't have to worry about the initial
//  hooking up of the view controller.

#import "SimpleTableViewController.h"

@interface SimpleTableViewController () {
    //NSData* responseData;
}

// part of me trying to GET
//@property (nonatomic, retain) NSData* responseData;
//end

@end

@implementation SimpleTableViewController
{
    NSArray *friends;
    NSMutableDictionary *users;
    NSString *demofriend;
    CLLocationManager *locationManager;
    NSMutableSet *closeUsers;
}

- (void)viewDidLoad
{
    demofriend = @"Max";
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    [locationManager startUpdatingLocation];  //requesting location updates

    // Initialize table data
    //TO DO: I should initialize this from a list from the server
    //NSArray *friends = [NSArray arrayWithObjects:@"Matt", @"Jason", @"Erica", @"Chris", @"Jasmine", @"Michael", nil];

    //Get request
    NSString *myUrl = [NSString stringWithFormat: @"https://squadhub.azurewebsites.net/allusers"];
    NSURL *url = [NSURL URLWithString:myUrl];
    dispatch_queue_t q = dispatch_queue_create("label", NULL);
    dispatch_async(q, ^{
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        users = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
//        for (NSString* user in users) {
//            if (user != demofriend) {
//                id userObject = [users objectForKey:user];
//                NSLog(users[demofriend][@"lat"]);
//                NSLog(userObject[@"lat"]);
//                if (userObject[@"lat"] == 0 ||
//                    (users[demofriend][@"lat"] == userObject[@"lat"] &&
//                     users[demofriend][@"lon"] == userObject[@"lon"])) {
//                        [closeUsers addObject:user];
//                    }
//            }
//        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"Initial Get, Dispatch returned:");
            //NSLog(@"%@", ret);
            
            //Now that we got the users, are we close to them?
//            for (NSString* user in users) {
//                    if (user != demofriend) {
//                        id userObject = [users objectForKey:user];
//                        if (userObject[@"lat"] == 0 ||
//                                (users[demofriend][@"lat"] == userObject[@"lat"] &&
//                                 users[demofriend][@"lon"] == userObject[@"lon"])) {
//                            [closeUsers addObject:user];
//                        }
//                    }
//            }
            
            
            [self.tableView reloadData];
        });
    });
    
    NSLog(@"viewDidLoad");
}

// location methods

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    NSString *latitude = [NSString stringWithFormat:@"%.2f",crnLoc.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%.2f",crnLoc.coordinate.longitude];
    
    //Get Request thats actually a Post
    NSDictionary *userObject = [users valueForKeyPath: demofriend];
    NSString *userStatus;
    if (userObject[@"status"] != NULL) {
        userStatus = userObject[@"status"];
    }
    else {
        userStatus = @"free";
    }
    
    NSString *myUrl = [NSString stringWithFormat: @"https://squadhub.azurewebsites.net/user/%@/%@/%@/%@",
                       demofriend, userStatus,latitude,longitude];
    NSURL *url = [NSURL URLWithString:myUrl];
    dispatch_queue_t q = dispatch_queue_create("label", NULL);
    dispatch_async(q, ^{
        NSLog(@"Dispatch Posting Location");
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

// end location methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *myUrl = [NSString stringWithFormat: @"https://squadhub.azurewebsites.net/allusers"];
    NSURL *url = [NSURL URLWithString:myUrl];
    dispatch_queue_t q = dispatch_queue_create("label", NULL);
    dispatch_async(q, ^{
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        users = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    });
    return [users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSArray *userkeys = [users allKeys];
    NSString *username = [userkeys objectAtIndex:indexPath.row];
    
    cell.textLabel.text = username;
    //NSLog(username);
    NSMutableDictionary *userObject = [users valueForKeyPath: username];
    
    bool isclose = ([users[demofriend][@"lat"] doubleValue] == [userObject[@"lat"] doubleValue] &&
                    [users[demofriend][@"lon"] doubleValue] == [userObject[@"lon"] doubleValue]);
    NSLog(@"DBG");
    NSLog(users[demofriend][@"lat"]);
    NSLog(users[demofriend][@"lon"]);
    NSString *debug = [userObject valueForKey: @"lat"];
    NSString *debug2 = [userObject valueForKey: @"lon"];
    NSLog([debug description]);
    NSLog([debug2 description]);
    
    if (isclose) {
        if ([[userObject valueForKey:@"status"] isEqual: @"free"]) {
            cell.imageView.image = [UIImage imageNamed:@"person_blue.jpg"];
        }
        else if ([[userObject valueForKey:@"status"] isEqual: @"busy"]) {
            cell.imageView.image = [UIImage imageNamed:@"person_red.jpg"];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:@"person_yellow.jpg"];
        }
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"person_gray.jpg"];
        cell.textLabel.enabled = NO;
    }
        
    
    
    return cell;
}

- (IBAction)freeButtons:(id)sender {
    
    NSString *newstatus;
    
    switch (self.freeButtons.selectedSegmentIndex)
    {
        case 0:
            NSLog(@"case 0");
            newstatus = @"free";
            break;
        case 1:
            NSLog(@"case 1");
            newstatus = @"sorta";
            break;
        case 2:
            NSLog(@"case 2");
            newstatus = @"busy";
            break;
        default:
            NSLog(@"default");
            newstatus = @"buttonerror";
            break; 
    }
    
    //Just gonna use get lol. I know, i know, it's probably bad practice or some nonsense
    //But this is a hackathon so it'll do for now
    NSString *myUrl = [NSString stringWithFormat: @"https://squadhub.azurewebsites.net/user/%@/%@",demofriend,newstatus];
    NSURL *url = [NSURL URLWithString:myUrl];
    dispatch_queue_t q = dispatch_queue_create("label", NULL);
    dispatch_async(q, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });

    
}


@end
