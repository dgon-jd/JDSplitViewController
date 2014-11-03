//
//  JDSplitViewController.m
//  JDSplitView
//
//  Created by Dmitry Goncharenko on 11/1/14.
//  Copyright (c) 2014 Dmitry Goncharenko. All rights reserved.
//

#import "JDSplitViewController.h"

typedef NS_ENUM(NSUInteger, SplitPart) {
    MasterPart,
    DetailPart
};

CGFloat const kSeparatorInset = 10.f;

@interface JDSplitViewController ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, assign) SplitPart currentSplitPart;
@property (nonatomic, strong) UIImageView *snapshotView;
@property (nonatomic, strong) UIViewController *masterViewController;
@property (nonatomic, strong) UIViewController *detailViewController;
@property (nonatomic, strong) JDSeparatorView *separatorView;
@end

@implementation JDSplitViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredPrimaryColumnWidthFraction = 1.f;
    [self configureLongTouch];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureSeparatorView];
}

- (void)configureLongTouch {
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction)];
    [self.view addGestureRecognizer:_longPressGestureRecognizer];
}

- (void)configureSeparatorView {
    CGRect frame = CGRectMake(self.detailViewController.view.frame.origin.x - kSeparatorInset
                              , 0.f
                              , kSeparatorInset * 2,
                              self.detailViewController.view.frame.size.height);
    
    _separatorView = [[JDSeparatorView alloc] initWithFrame:frame];
    __weak typeof(self) weakSelf = self;
    [_separatorView setGestureBlock:^(UITouch *touch) {
        CGPoint touchPoint = [touch locationInView:weakSelf.view];
        CGPoint centerPoint = CGPointMake(touchPoint.x, weakSelf.separatorView.center.y);
        weakSelf.separatorView.center = centerPoint;
        weakSelf.maximumPrimaryColumnWidth = touchPoint.x;
    }];
    [self.view addSubview:_separatorView];
    
    
}

#pragma mark - Getters
-(UIViewController *)masterViewController {
    return self.viewControllers[0];
}

-(UIViewController *)detailViewController {
    return self.viewControllers[1];
}

#pragma mark - Actions

- (void)longAction {
    CGPoint touchPoint = [self.longPressGestureRecognizer locationInView:self.view];
    // on the touch began - remember touch position and make screenShot
    if (self.longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.currentSplitPart = [self calculatePartFromTouchPoint:touchPoint];
        [self showScreenShot];
    } else if (self.longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        SplitPart newSplitPart = [self calculatePartFromTouchPoint:touchPoint];
        [self dragVisibleControllerFromPart:self.currentSplitPart toPart:newSplitPart];
        [self.snapshotView removeFromSuperview];
    } else {
        self.snapshotView.center = [self.longPressGestureRecognizer locationInView:self.view];
    }
}

- (void)showScreenShot {
    UIImage *snapshotImage = (self.currentSplitPart == MasterPart) ? [self snapshot:self.masterViewController.view] : [self snapshot:self.detailViewController.view];
    self.snapshotView = [[UIImageView alloc] initWithImage:snapshotImage];
    self.snapshotView.center = [self.longPressGestureRecognizer locationInView:self.view];
    [self.view addSubview:self.snapshotView];
}

- (void)dragVisibleControllerFromPart:(SplitPart)fromPart toPart:(SplitPart)toPart {
    if (toPart != fromPart) {
        if ([self bothPartsAreNavigation]) {
            // if navigation controllers - do stack operations
            UINavigationController *fromController = self.viewControllers[(toPart == MasterPart) ? DetailPart : MasterPart];
            UINavigationController *toController = self.viewControllers[(toPart == MasterPart) ? MasterPart : DetailPart];
            //move visible controller to another stack if not root
            UIViewController *tempController = [fromController visibleViewController];
            if (![tempController isEqual:fromController.viewControllers[0]]) {
                [fromController popViewControllerAnimated:NO];
                [toController pushViewController:tempController animated:NO];
            } else {
                // if root - swap
                [self swapParts];
            }
        } else {
            // if not navigation - just swap
            [self swapParts];
        }
    }
}

- (BOOL)bothPartsAreNavigation {
    return ([self.masterViewController isKindOfClass:[UINavigationController class]] &&
            [self.detailViewController isKindOfClass:[UINavigationController class]]);
}

- (SplitPart)calculatePartFromTouchPoint:(CGPoint)point {
    return (point.x < self.detailViewController.view.frame.origin.x) ? MasterPart : DetailPart;
}

- (void)swapParts {
    self.viewControllers = @[self.detailViewController, self.masterViewController];
}

#pragma mark - Snapshot
- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

#pragma mark - JDSeparatorView

@implementation JDSeparatorView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (_gestureBlock) {
        self.gestureBlock(touch);
    }
}
@end
