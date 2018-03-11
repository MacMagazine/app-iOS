//
//  Customslider.h
//  ExploringSlider
//
//  Created by Neha Singh on 12/26/16.
//  Copyright © 2016 Neha Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ToolTipPopupView;

@interface Customslider : UISlider {
	ToolTipPopupView *toolTip;
	float stepValue;
}

@property(nonatomic) CGRect trackFrame;
@property(nonatomic) int noOfTicks;
@property(nonatomic) BOOL isTickType;
@property(nonatomic) BOOL showTooltip;

- (UIView *)addTickMarksView;

@end
