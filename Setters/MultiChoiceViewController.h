//
//  MultiSelectionViewController.h
//  Halsokollen
//
//  Created by Robin Enhorn on 2012-12-12.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChoiceChangeBlock)(NSString *selected);
typedef void (^ChoiceDoneBlock)(NSString *selected);

@interface MultiChoiceViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, readwrite) BOOL showFullPreview;

+ (MultiChoiceViewController*) sharedMultiChooser;

- (void) setupForParentView:(UIView*)aView options:(NSArray*)someOptions selectedOption:(NSString*)selected changeCallback:(ChoiceChangeBlock)selectionChangeBlock doneCallback:(ChoiceDoneBlock)selectionDoneCallback;

- (void) disableCancelButton:(BOOL)disabled;

@end
