//
//  ViewController.m
//  InputSetters
//
//  Created by Robin Enhorn on 2013-02-04.
//  Copyright (c) 2013 Robin Enhorn. All rights reserved.
//

#import "ViewController.h"

#import "DateCollectionViewController.h"
#import "DateSelectionViewController.h"
#import "MultiChoiceViewController.h"
#import "MultiColumnChoiceViewController.h"
#import "MultiSelectionViewController.h"
#import "TextEditorViewController.h"

@interface ViewController ()
@property (nonatomic, retain) NSArray *rows;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.rows = @[
		@"Date Collection - Date",
		@"Date Collection - Time",
		@"Date Collection - DateTime",
		@"Date Selection - Date",
		@"Date Selection - Time",
		@"Date Selection - DateTime",
		@"Date Selection - Count Down",
		@"Multiple Choice",
		@"Multiple Column Choice",
		@"Multiple Selection",
		@"Text Editor"
	];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubtitleCell"];
	cell.textLabel.text = [self.rows objectAtIndex:indexPath.row];
	cell.detailTextLabel.text = @"No Selection";
	return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.rows.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	NSString *currentDetailText = cell.detailTextLabel.text;
	if (indexPath.row == 0) {
		[[DateCollectionViewController sharedDateCollector] setupWithDates:@[] collectionType:DateCollectionTypeDate presentationViewController:self presentationType:CollectionPresentatonTypeModal doneBlock:^(NSArray *dates) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"Selected Number of Dates: %i", dates.count];
		}];
	} else if (indexPath.row == 1) {
		[[DateCollectionViewController sharedDateCollector] setupWithDates:@[] collectionType:DateCollectionTypeTime presentationViewController:self presentationType:CollectionPresentatonTypeModal doneBlock:^(NSArray *dates) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"Selected Number of Dates: %i", dates.count];
		}];
	} else if (indexPath.row == 2) {
		[[DateCollectionViewController sharedDateCollector] setupWithDates:@[] collectionType:DateCollectionTypeDateTime presentationViewController:self presentationType:CollectionPresentatonTypeModal doneBlock:^(NSArray *dates) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"Selected Number of Dates: %i", dates.count];
		}];
	} else if (indexPath.row == 3) {
		[[DateSelectionViewController sharedDateSelector] setupForParentView:self.view defaultDate:[NSDate date] datePickerMode:UIDatePickerModeDate dateChangeBlock:^(NSDate *changeDate) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", changeDate];
		} dateDoneBlock:^(NSDate *chosenDate) {
			if (chosenDate) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", chosenDate];
			} else {
				cell.detailTextLabel.text = currentDetailText;
			}
		}];
	} else if (indexPath.row == 4) {
		[[DateSelectionViewController sharedDateSelector] setupForParentView:self.view defaultDate:[NSDate date] datePickerMode:UIDatePickerModeTime dateChangeBlock:^(NSDate *changeDate) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", changeDate];
		} dateDoneBlock:^(NSDate *chosenDate) {
			if (chosenDate) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", chosenDate];
			} else {
				cell.detailTextLabel.text = currentDetailText;
			}
		}];
	} else if (indexPath.row == 5) {
		[[DateSelectionViewController sharedDateSelector] setupForParentView:self.view defaultDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime dateChangeBlock:^(NSDate *changeDate) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", changeDate];
		} dateDoneBlock:^(NSDate *chosenDate) {
			if (chosenDate) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", chosenDate];
			} else {
				cell.detailTextLabel.text = currentDetailText;
			}
		}];
	} else if (indexPath.row == 6) {
		[[DateSelectionViewController sharedDateSelector] setupForParentView:self.view defaultDate:[NSDate date] datePickerMode:UIDatePickerModeCountDownTimer dateChangeBlock:^(NSDate *changeDate) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", changeDate];
		} dateDoneBlock:^(NSDate *chosenDate) {
			if (chosenDate) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", chosenDate];
			} else {
				cell.detailTextLabel.text = currentDetailText;
			}
		}];
	} else if (indexPath.row == 7) {
		[[MultiChoiceViewController sharedMultiChooser] setupForParentView:self.view options:@[@"Option 1", @"Option 2", @"Option 3"] selectedOption:currentDetailText changeCallback:^(NSString *selected) {
			cell.detailTextLabel.text = selected;
		} doneCallback:^(NSString *selected) {
			if (selected) {
				cell.detailTextLabel.text = selected;
			} else {
				cell.detailTextLabel.text = currentDetailText;
			}
		}];
	} else if (indexPath.row == 8) {
		NSArray *columns = @[
			@[@"Value 1", @"Value 2", @"Value 3"],
			@[@"Value 4", @"Value 5", @"Value 6"]
		];

		[[MultiColumnChoiceViewController sharedMultiSelector] setupForParentView:self.view options:columns selectedOption:nil changeCallback:^(NSArray *selected) {
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ + %@", [selected objectAtIndex:0], [selected objectAtIndex:1]];
		} doneCallback:^(NSArray *selected) {
			if (selected) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ + %@", [selected objectAtIndex:0], [selected objectAtIndex:1]];;
			} else {
				cell.detailTextLabel.text = currentDetailText;
			}
		}];
	} else if (indexPath.row == 9) {
		[[MultiSelectionViewController sharedMultiSelector] setupWithOptions:@[@"Option 1", @"Option 2", @"Option 3"] preSelectedOptions:@[@"Option 2"] presentationViewController:self presentationType:PresentatonTypeModal doneBlock:^(NSArray *chosen) {
			if (chosen) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"Selected Number of options: %i", chosen.count];
			}
		} cancelBlock:^{
			cell.detailTextLabel.text = currentDetailText;
		}];
	} else if (indexPath.row == 10) {
		NSString *defaultText = [currentDetailText isEqualToString:@"No Selection"] ? @"" : currentDetailText;
		[[TextEditorViewController sharedTextEditor] setupForParentView:self.view defaultString:defaultText placeholderText:@"Text Editor" doneBlock:^(NSString *newText) {
			if (newText) {
				newText = [newText isEqualToString:@""] ? @"No Selection" : newText;
				cell.detailTextLabel.text = newText;
			}
		}];
	}
}

@end
