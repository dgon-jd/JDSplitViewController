//
//  JDSplitViewController.h
//  JDSplitView
//
//  Created by Dmitry Goncharenko on 11/1/14.
//  Copyright (c) 2014 Dmitry Goncharenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDSplitViewController : UISplitViewController
@end

typedef void(^SeparatorGestureBlock)(UITouch *gestureTouch);

@interface JDSeparatorView : UIView
- (instancetype)initWithSeparatorBlock:(SeparatorGestureBlock)gestureBlock;
@end