//
//  DateSelectionViewController.h
//  Halsokollen
//
//  Created by Robin Enhorn on 2012-12-13.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DateChangeBlock)(NSDate *changeDate);
typedef void (^DateDoneBlock)(NSDate *chosenDate);

@interface DateSelectionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;

+ (DateSelectionViewController*) sharedDateSelector;
- (void) setupForParentView:(UIView*)aView defaultDate:(NSDate*)aDate datePickerMode:(UIDatePickerMode)datePickerMode dateChangeBlock:(DateChangeBlock)dateChangeBlock dateDoneBlock:(DateDoneBlock)dateDoneBlock;
@end
