//
//  DateCollectionViewController.h
//  Halsodagboken
//
//  Created by Robin Enhorn on 2012-12-20.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	DateCollectionTypeDate = 0,
	DateCollectionTypeTime = 1,
	DateCollectionTypeDateTime = 2
} DateCollectionType;

typedef enum {
	CollectionPresentatonTypeModal = 0,
	CollectionPresentatonTypePush = 1
} CollectionPresentatonType;

typedef void (^CollectionDoneBlock)(NSArray *dates);

@interface DateCollectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

+ (DateCollectionViewController*) sharedDateCollector;

- (void) setupWithDates:(NSArray*)someDates collectionType:(DateCollectionType)aCollectionType presentationViewController:(UIViewController*)viewController presentationType:(CollectionPresentatonType)aPresentationType doneBlock:(CollectionDoneBlock)aDoneBlock;

@end
