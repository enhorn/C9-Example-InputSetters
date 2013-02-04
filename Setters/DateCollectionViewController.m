//
//  DateCollectionViewController.m
//  Halsodagboken
//
//  Created by Robin Enhorn on 2012-12-20.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import "DateCollectionViewController.h"
#import "DateSelectionViewController.h"

@interface DateCollectionViewController ()
@property (nonatomic, readwrite) DateCollectionType collectionType;
@property (nonatomic, retain) NSArray *dates;
@property (nonatomic, retain) NSDateFormatter *formatter;
@property (nonatomic, copy) CollectionDoneBlock doneBlock;
@property (nonatomic, readwrite) CollectionPresentatonType presentationType;
@property (nonatomic, retain) UIViewController *ownerViewController;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@end

@implementation DateCollectionViewController

static DateCollectionViewController *shared;
+ (DateCollectionViewController*) sharedDateCollector {
	if (!shared) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InputSetters" bundle: nil];
		shared = [storyboard instantiateViewControllerWithIdentifier:@"DateCollectionViewController"];
	}
	shared.collectionType = DateCollectionTypeDate;
	shared.presentationType = CollectionPresentatonTypeModal;
	shared.dates = @[];
	shared.doneBlock = nil;
	shared.ownerViewController = nil;
	[shared assertFormatter];
	return shared;
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - ViewController functions

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	NSArray *buttons = @[self.addButton, self.doneButton];
	for (NSInteger i = 0; i < buttons.count; i++) {
		UIBarButtonItem *button = [buttons objectAtIndex:i];
		[button setTitleTextAttributes:@{
				   UITextAttributeFont: [UIFont boldSystemFontOfSize:12.0f],
			 UITextAttributeTextColor : [UIColor whiteColor],
	   UITextAttributeTextShadowColor : [UIColor clearColor]
		 } forState:UIControlStateNormal];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated {
	if (CollectionPresentatonTypePush == self.presentationType) {
		if (self.doneBlock) {
			self.doneBlock(self.dates);
		}
	}
}

- (void) viewWillAppear:(BOOL)animated {
	[self.table reloadData];
}

- (void)viewDidUnload {
	[self setNavItem:nil];
	[self setNavBar:nil];
	[self setTable:nil];
	[self setDoneButton:nil];
	[self setAddButton:nil];
	[super viewDidUnload];
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Data functions

- (void) setupWithDates:(NSArray*)someDates collectionType:(DateCollectionType)aCollectionType presentationViewController:(UIViewController*)viewController presentationType:(CollectionPresentatonType)aPresentationType doneBlock:(CollectionDoneBlock)aDoneBlock {
	self.dates = [someDates isKindOfClass:[NSArray class]] ? someDates : @[];
	self.collectionType = aCollectionType;
	self.doneBlock = aDoneBlock;
	[self setDateFormat];
	if (viewController) {
		self.presentationType = aPresentationType;
		self.ownerViewController = viewController;
		if (CollectionPresentatonTypeModal == self.presentationType) {
			[viewController presentModalViewController:self animated:YES];
		} else {
			[viewController.navigationController pushViewController:self animated:YES];
		}
	}
}

- (void) assertFormatter {
	if (!self.formatter) {
		self.formatter = [[NSDateFormatter alloc] init];
		self.formatter.locale = [NSLocale currentLocale];
	}
}

- (void) setDateFormat {
	[self assertFormatter];
	if (DateCollectionTypeDate == self.collectionType) {
		self.formatter.dateFormat = @"yyyy-MM-dd";
	} else if (DateCollectionTypeTime == self.collectionType) {
		self.formatter.dateFormat = @"HH:mm";
	} else if (DateCollectionTypeDateTime == self.collectionType) {
		self.formatter.dateFormat = @"yyyy-MM-dd HH:mm";
	}
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Interface functions

- (void) dismiss {
	if (self.ownerViewController) {
		if (CollectionPresentatonTypeModal == self.presentationType) {
			[self.ownerViewController dismissModalViewControllerAnimated:YES];
		} else {
			[self.ownerViewController.navigationController popViewControllerAnimated:YES];
		}
	}
}

- (IBAction)pressedAdd:(id)sender {
	UIDatePickerMode mode = UIDatePickerModeDate;
	if (DateCollectionTypeTime == self.collectionType) {
		mode = UIDatePickerModeTime;
	} else if (DateCollectionTypeDateTime == self.collectionType) {
		mode = UIDatePickerModeDateAndTime;
	}
	[[DateSelectionViewController sharedDateSelector] setupForParentView:self.view defaultDate:[NSDate date] datePickerMode:mode dateChangeBlock:^(NSDate *changeDate) {
	} dateDoneBlock:^(NSDate *chosenDate) {
		if (chosenDate) {
			NSSet *set = [[NSSet alloc] initWithArray:self.dates];
			set = [set setByAddingObject:chosenDate];
			self.dates = [set allObjects];
			[self.table reloadData];
		}
	}];
}

- (IBAction)pressedDone:(id)sender {
	[self dismiss];
	if (self.doneBlock) {
		self.doneBlock(self.dates);
	}
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - UITableView functions

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
	NSDate *date = [self.dates objectAtIndex:indexPath.row];
	cell.textLabel.text = [self.formatter stringFromDate:date];
	return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dates.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSMutableArray *newDates = [NSMutableArray array];
		for (NSInteger i = 0; i < self.dates.count; i++) {
			if (i != indexPath.row) {
				[newDates addObject:[self.dates objectAtIndex:i]];
			}
		}
		self.dates = [NSArray arrayWithArray:newDates];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

@end
