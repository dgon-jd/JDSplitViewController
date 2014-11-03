//
//  TableViewController.m
//  JDSplitView
//
//  Created by Dmitry Goncharenko on 11/3/14.
//  Copyright (c) 2014 Dmitry Goncharenko. All rights reserved.
//

#import "TableViewController.h"
#import "ImageViewController.h"

@interface TableViewController ()
@property (nonatomic, assign) NSUInteger selectedRowNumber;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    [cell.textLabel setText:[NSString stringWithFormat:@"Test %ld", (long)indexPath.row]];
    
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRowNumber = indexPath.row;
    return indexPath;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"previewImageSegue"]) {
        ImageViewController *imageVC = (ImageViewController *)segue.destinationViewController;
        [imageVC configureWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%lu", (unsigned long)self.selectedRowNumber]]];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
