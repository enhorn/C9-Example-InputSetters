//
//  MultiSelectionViewController.m
//  Halsodagboken
//
//  Created by Robin Enhorn on 2012-12-20.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import "MultiSelectionViewController.h"

@interface MultiSelectionViewController ()
@property (nonatomic, retain) NSArray *options;
@property (nonatomic, retain) NSArray *selected;
@property (nonatomic, copy) SelectionDoneBlock doneBlock;
@property (nonatomic, copy) SelectionCancelBlock cancelBlock;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) UIViewController *ownerViewController;
@property (nonatomic, readwrite) PresentatonType presentationType;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@end

@implementation MultiSelectionViewController

static MultiSelectionViewController *shared;
+ (MultiSelectionViewController*) sharedMultiSelector {
	if (!shared) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InputSetters" bundle: nil];
		shared = [storyboard instantiateViewControllerWithIdentifier:@"MultiSelectionViewController"];
	}
	shared.options = @[];
	shared.selected = @[];
	shared.cancelBlock = nil;
	shared.doneBlock = nil;
	shared.ownerViewController = nil;
	return shared;
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - ViewController functions

- (void) setupWithOptions:(NSArray*)someOptions preSelectedOptions:(NSArray*)somePreselected presentationViewController:(UIViewController*)viewController presentationType:(PresentatonType)presentationType doneBlock:(SelectionDoneBlock)selectionDoneBlock cancelBlock:(SelectionCancelBlock)selectionCancelBlock {
	self.options = someOptions ? someOptions : @[];
	self.selected = somePreselected ? somePreselected : @[];
	self.doneBlock = selectionDoneBlock;
	self.cancelBlock = selectionCancelBlock;
	if (viewController) {
		self.ownerViewController = viewController;
		self.presentationType = presentationType;
		if (PresentatonTypeModal == self.presentationType) {
			[viewController presentModalViewController:self animated:YES];
		} else {
			[viewController.navigationController pushViewController:self animated:YES];
		}
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	NSArray *buttons = @[self.cancelButton, self.doneButton];
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

- (void)viewDidUnload {
	[self setNavBar:nil];
	[self setTable:nil];
	[self setNavItem:nil];
	[self setCancelButton:nil];
	[self setDoneButton:nil];
	[super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
	self.navItem.title = [NSString stringWithFormat:@"%i / %i", self.selected.count, self.options.count];
	[self.table reloadData];
	[self setupGUI];
	[super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (PresentatonTypePush == self.presentationType) {
		if (self.doneBlock) {
			self.doneBlock(self.selected);
		}
	}
}

- (void) setupGUI {
	if (PresentatonTypePush == self.presentationType) {
		self.navBar.hidden = YES;
		self.table.frame = self.view.frame;
	} else {
		self.navBar.hidden = NO;
		self.table.frame = CGRectMake(0.0f, 44.0f, self.view.frame.size.width, self.view.frame.size.height);
	}
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Data functions

- (BOOL) isSelected:(id)option {
	BOOL isSelected = NO;
	if (self.selected) {
		NSString *optionTitle = [option isKindOfClass:[NSString class]] ? option : [option title];
		NSString *selectedTitle = nil;
		id selectedOption = nil;
		for (int i = 0; i < self.selected.count; i++) {
			selectedOption = [self.selected objectAtIndex:i];
			selectedTitle = [selectedOption isKindOfClass:[NSString class]] ? selectedOption : [selectedOption title];
			if ([optionTitle isEqualToString:selectedTitle]) {
				isSelected = YES;
				i = self.selected.count;
			}
		}
	}
	return isSelected;
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - UITableView functions

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id selectable = [self.options objectAtIndex:indexPath.row];

	NSString *title = nil;
	NSString *detailText = nil;
	if ([selectable isKindOfClass:[NSString class]]) {
		title = selectable;
	} else {
		title = [selectable title];
		if ([selectable respondsToSelector:@selector(detailText)]) {
			detailText = [selectable detailText];
		}
	}

	NSString *CellIdentifier = detailText != nil ? @"DetailCell" : @"StadardCell";
	UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	cell.textLabel.text = title;
	if (detailText) {
		cell.detailTextLabel.text = detailText;
	}

	cell.accessoryType = [self isSelected:selectable] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

	return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.options.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id toggledOption = [self.options objectAtIndex:indexPath.row];
	NSString *toggledTitle = [toggledOption isKindOfClass:[NSString class]] ? toggledOption : [toggledOption title];
	if (self.selected.count == 0) {
		self.selected = @[toggledOption];
	} else {
		BOOL isSelected = [self isSelected:toggledOption];
		NSMutableArray *newOptions = [[NSMutableArray alloc] init];
		id selectedOption = nil;
		NSString *selectedTitle = nil;
		for (int i = 0; i < self.selected.count; i++) {
			selectedOption = [self.selected objectAtIndex:i];
			selectedTitle = [selectedOption isKindOfClass:[NSString class]] ? selectedOption : [selectedOption title];
			if (![selectedTitle isEqualToString:toggledTitle]) {
				[newOptions addObject:selectedOption];
			}
		}
		if (!isSelected) {
			[newOptions addObject:toggledOption];
		}
		self.selected = [NSArray arrayWithArray:newOptions];
	}
	self.navItem.title = [NSString stringWithFormat:@"%i / %i", self.selected.count, self.options.count];
	[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Interface functions

- (void) dismiss {
	if (self.ownerViewController) {
		if (PresentatonTypeModal == self.presentationType) {
			[self.ownerViewController dismissModalViewControllerAnimated:YES];
		} else {
			[self.ownerViewController.navigationController popViewControllerAnimated:YES];
		}
	}
}

- (IBAction)pressedCancel:(UIBarButtonItem *)sender {
	[self dismiss];
	if (self.cancelBlock) {
		self.cancelBlock();
	}
}

- (IBAction)pressedDone:(UIBarButtonItem *)sender {
	[self dismiss];
	if (self.doneBlock) {
		self.doneBlock(self.selected);
	}
}

@end
