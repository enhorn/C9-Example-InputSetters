//
//  MultiColumnSelectionViewController.m
//  LoggaHalsan
//
//  Created by Robin Enhorn on 2013-01-10.
//  Copyright (c) 2013 Cloud Nine. All rights reserved.
//

#import "MultiColumnChoiceViewController.h"

@interface MultiColumnChoiceViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIView *toolsHolder;
@property (nonatomic, retain) NSArray *options;
@property (nonatomic, retain) NSArray *selected;
@property (nonatomic, copy) MultiChoiceChangeBlock changeBlock;
@property (nonatomic, copy) MultiChoiceDoneBlock doneBlock;
@property (nonatomic, retain) UIViewController *ownerViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@end

@implementation MultiColumnChoiceViewController

static MultiColumnChoiceViewController *shared;
+ (MultiColumnChoiceViewController*) sharedMultiSelector {
	if (!shared) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InputSetters" bundle: nil];
		shared = [storyboard instantiateViewControllerWithIdentifier:@"MultiColumnChoiceViewController"];
	}
	shared.options = @[];
	shared.selected = @[];
	shared.changeBlock = nil;
	shared.doneBlock = nil;
	shared.ownerViewController = nil;
	return shared;
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - UIViewController functions

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

	NSArray *buttons = @[self.cancelButton, self.doneButton];
	for (NSInteger i = 0; i < buttons.count; i++) {
		UIBarButtonItem *button = [buttons objectAtIndex:i];
		[button setTitleTextAttributes:@{
				   UITextAttributeFont: [UIFont boldSystemFontOfSize:12.0f],
			 UITextAttributeTextColor : [UIColor whiteColor],
	   UITextAttributeTextShadowColor : [UIColor clearColor]
		 } forState:UIControlStateNormal];
	}

	[self addCancelView];
}

- (void) addCancelView {
	UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.toolsHolder.frame.origin.y)];
	cancelView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:cancelView];
	[cancelView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedCancel:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[self setToolbar:nil];
	[self setPicker:nil];
	[self setToolsHolder:nil];
	[self setCancelButton:nil];
	[self setDoneButton:nil];
	[super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.picker reloadAllComponents];
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Setup functions

- (void) setupForParentView:(UIView*)aView options:(NSArray*)someOptions selectedOption:(NSString*)selected changeCallback:(MultiChoiceChangeBlock)selectionChangeBlock doneCallback:(MultiChoiceDoneBlock)selectionDoneCallback {
	self.options = someOptions;
	self.changeBlock = selectionChangeBlock;
	self.doneBlock = selectionDoneCallback;
	[self.picker reloadAllComponents];

	if (selected) {
		//[self.picker selectRow:[self rowForOption:selected] inComponent:0 animated:YES];
	}

	[self addAndAnimateViews:aView];
}

- (void) addAndAnimateViews:(UIView*)aView {
	self.view.frame = CGRectMake(0.0f, 0.0f, aView.frame.size.width, aView.frame.size.height);
	self.view.alpha = 0.0;
	[aView addSubview:self.view];

	self.toolsHolder.frame = CGRectMake(0.0f, self.view.frame.size.height, self.toolsHolder.frame.size.width, self.toolsHolder.frame.size.height);

	[UIView animateWithDuration:0.25 animations:^(){
		self.view.alpha = 1.0;
		self.toolsHolder.frame = CGRectMake(0.0f, self.view.frame.size.height-self.toolsHolder.frame.size.height, self.toolsHolder.frame.size.width, self.toolsHolder.frame.size.height);
	}];
}

- (void) hideAndRemove {
	[UIView animateWithDuration:0.25 animations:^(){
		self.view.alpha = 0.0;
		self.toolsHolder.frame = CGRectMake(0.0f, self.view.frame.size.height, self.toolsHolder.frame.size.width, self.toolsHolder.frame.size.height);
	} completion:^(BOOL success){
		[self.view removeFromSuperview];
	}];
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - UIPickerView functions

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return self.options.count;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [[self.options objectAtIndex:component] count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[self.options objectAtIndex:component] objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (self.changeBlock) {
		self.changeBlock([self currentValues]);
	}
}

- (NSArray*) currentValues {
	NSMutableArray *values = [NSMutableArray array];
	for (NSInteger i = 0; i < self.options.count; i++) {
		[values addObject:[[self.options objectAtIndex:i] objectAtIndex:[self.picker selectedRowInComponent:i]]];
	}
	return [NSArray arrayWithArray:values];
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Button functions

- (IBAction)pressedDone:(id)sender {
	if (self.doneBlock) {
		self.doneBlock([self currentValues]);
	}
	[self hideAndRemove];
}

- (IBAction)pressedCancel:(id)sender {
	if (self.doneBlock) {
		self.doneBlock(nil);
	}
	[self hideAndRemove];
}

@end
