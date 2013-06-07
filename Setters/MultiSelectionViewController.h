//
//  MultiSelectionViewController.h
//  Halsodagboken
//
//  Created by Robin Enhorn on 2012-12-20.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputSetters.h"

@protocol MultiSelectable <NSObject>
@required
- (NSString*) title;
@optional
- (NSString*) detailText;
@end

typedef void (^SelectionDoneBlock)(NSArray *chosen);
typedef void (^SelectionCancelBlock)();

@interface MultiSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSString *emptyListMessage;

+ (MultiSelectionViewController*) sharedMultiSelector;

- (void) setupWithOptions:(NSArray*)someOptions preSelectedOptions:(NSArray*)somePreselected presentationViewController:(UIViewController*)viewController presentationType:(PresentatonType)presentationType doneBlock:(SelectionDoneBlock)selectionDoneBlock cancelBlock:(SelectionCancelBlock)selectionCancelBlock;

@end
