//
//  ImageViewController.m
//  JDSplitView
//
//  Created by Dmitry Goncharenko on 11/3/14.
//  Copyright (c) 2014 Dmitry Goncharenko. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *girlImageView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.girlImageView setImage:self.image];
}

-(void)configureWithImage:(UIImage *)image {
    self.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
