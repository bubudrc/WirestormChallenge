//
//  PostsTableViewController.m
//  WirestormChallenge
//
//  Created by marcelo.perretta@gmail.com on 7/26/15.
//  Copyright (c) 2015 MAWAPE. All rights reserved.
//

#import "PostsTableViewController.h"

#import "PostTableViewCell.h"
#import "Post.h"
#import "ServerCalls.h"

#import "ViewController.h"

@interface PostsTableViewController ()

@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation PostsTableViewController

#pragma mark -  LazyInitialization
-(NSMutableArray *) posts {
    if(!_posts) _posts = [[NSMutableArray alloc] init];
    
    return _posts;
}

#pragma mark - UITableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Top Posts"];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self getAndPopulateUserData];
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(getAndPopulateUserData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner stopAnimating];
    self.spinner.hidesWhenStopped = NO;
    self.spinner.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44);
    self.tableView.tableFooterView = self.spinner;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Populate Data
-(void)getAndPopulateUserData{
    
    [ServerCalls downloadDataFromURL:nil ifImage:NO success:^(NSArray *data) {
        // Check if any data returned.
        if (data != nil && [data count] > 0) {
            if([self.posts count] > 0)
                [self.posts removeAllObjects];
            
            
            [self populateData:data];
        }
        
    } failure:^(NSString *errorDescription) {
        NSLog(@"ERROR: %@", errorDescription);
    }];
}

#pragma mark - PopulateData
-(void) populateData:(NSArray *) serverResponse {
    
    if(serverResponse){
        for(NSDictionary *post in serverResponse){
            [self.posts addObject:[[Post alloc] initWithDictionary:post]];
        }
        
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        [self.spinner stopAnimating];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    // Return the number of sections.
    if (self.posts) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"Post";
    PostTableViewCell* cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    Post *newPost = [self.posts objectAtIndex:indexPath.row];
    
    
    NSLog(@"POST: %@", newPost.name);
    
    // Configure the cell...
    cell.titleLabel.text = newPost.name;
    cell.positionLabel.text = newPost.position;
    
    cell.imageView.image = nil;
    
    if([newPost.smallpicurl length] > 0){
        [ServerCalls downloadDataFromURL:newPost.smallpicurl ifImage:YES success:^(NSArray *data) {
            // Check if any data returned.
            if (data != nil) {
                cell.thumbnailImage.image = [UIImage imageWithData:data.firstObject];
                cell.activityIndicator.alpha = 0.0;
            }
            
        } failure:^(NSString *errorDescription) {
            NSLog(@"ERROR: %@", errorDescription);
        }];
    } else {
        cell.activityIndicator.alpha = 0.0;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Post *postSelected = [self.posts objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showDetailPost" sender:postSelected.bigpicurl];
    postSelected = nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDetailPost"])
    {
        if([sender isKindOfClass:[NSString class]]){
            [segue.destinationViewController setImageURL:sender];
        }
    }
}


@end
