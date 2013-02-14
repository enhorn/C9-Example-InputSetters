//
//  MultiSelectionViewController.h
//  Halsodagboken
//
//  Created by Robin Enhorn on 2012-12-20.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef PresentatonType
typedef enum {
	PresentatonTypeModal = 0,
	PresentatonTypePush = 1
} PresentatonType;
#endif

@protocol MultiSelectable <NSObject>
@required
- (NSString*) title;
@optional
- (NSString*) detailText;
@end

typedef void (^SelectionDoneBlock)(NSArray *chosen);
typedef void (^SelectionCancelBlock)();

@interface MultiSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

+ (MultiSelectionViewController*) sharedMultiSelector;

- (void) setupWithOptions:(NSArray*)someOptions preSelectedOptions:(NSArray*)somePreselected presentationViewController:(UIViewController*)viewController presentationType:(PresentatonType)presentationType doneBlock:(SelectionDoneBlock)selectionDoneBlock cancelBlock:(SelectionCancelBlock)selectionCancelBlock;

@end
