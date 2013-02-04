//
//  DateCollectionViewController.h
//  Halsodagboken
//
//  Created by Robin Enhorn on 2012-12-20.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputSetters.h"

typedef void (^CollectionDoneBlock)(NSArray *dates);

@interface DateCollectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

+ (DateCollectionViewController*) sharedDateCollector;

- (void) setupWithDates:(NSArray*)someDates collectionType:(DateCollectionType)aCollectionType presentationViewController:(UIViewController*)viewController presentationType:(CollectionPresentatonType)aPresentationType doneBlock:(CollectionDoneBlock)aDoneBlock;

@end
