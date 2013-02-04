//
//  MultiColumnSelectionViewController.h
//  LoggaHalsan
//
//  Created by Robin Enhorn on 2013-01-10.
//  Copyright (c) 2013 Cloud Nine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputSetters.h"

typedef void (^MultiChoiceChangeBlock)(NSArray *selected);
typedef void (^MultiChoiceDoneBlock)(NSArray *selected);

@interface MultiColumnChoiceViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

+ (MultiColumnChoiceViewController*) sharedMultiSelector;

- (void) setupForParentView:(UIView*)aView options:(NSArray*)someOptions selectedOption:(NSString*)selected changeCallback:(MultiChoiceChangeBlock)selectionChangeBlock doneCallback:(MultiChoiceDoneBlock)selectionDoneCallback;

@end
