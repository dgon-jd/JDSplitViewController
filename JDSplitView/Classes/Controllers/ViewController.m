//
//  ViewController.m
//  JDSplitView
//
//  Created by Dmitry Goncharenko on 11/1/14.
//  Copyright (c) 2014 Dmitry Goncharenko. All rights reserved.
//

#import "ViewController.h"
#import "JDSplitViewController.h"
@interface ViewController ()
@property (nonatomic, strong) JDSplitViewController *embedSplitViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)overrideTraitCollectionForSplitView {
    UITraitCollection *traitCollection = [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular];
    [self setOverrideTraitCollection:traitCollection forChildViewController:self.embedSplitViewController];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedSegue"]) {
        self.embedSplitViewController = segue.destinationViewController;
        [self overrideTraitCollectionForSplitView];
    }
}

@end
