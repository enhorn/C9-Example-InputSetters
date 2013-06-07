//
//  MultiSelectionViewController.m
//  Halsokollen
//
//  Created by Robin Enhorn on 2012-12-12.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import "MultiChoiceViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MultiChoiceViewController ()
@property (weak, nonatomic) IBOutlet UIView *toolsHolder;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) NSArray *options;
@property (nonatomic, copy) ChoiceChangeBlock changeBlock;
@property (nonatomic, copy) ChoiceDoneBlock doneBlock;
@end

@implementation MultiChoiceViewController

static MultiChoiceViewController *shared;
+ (MultiChoiceViewController*) sharedMultiChooser {
	if (!shared) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InputSetters" bundle: nil];
		shared = [storyboard instantiateViewControllerWithIdentifier:@"MultiChoiceViewController"];
	}

	shared.options = @[];
	shared.changeBlock = nil;
	shared.doneBlock = nil;
	shared.showFullPreview = NO;
	[shared disableCancelButton:NO];

	return shared;
}


/* -------------------------------------------------------------------------------------- */
#pragma mark - ViewController functions

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		self.showFullPreview = NO;
    }
    return self;
}

- (void) viewDidLoad {
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

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
	[self setToolsHolder:nil];
	[self setToolbar:nil];
	[self setPicker:nil];
	[self setCancelButton:nil];
	[self setDoneButton:nil];
	[super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.picker reloadAllComponents];
	UITextView *textView = [self previewTextView];
	if (textView) {
		textView.alpha = 0.0f;
		textView.hidden = !self.showFullPreview;
	}
}

- (void) disableCancelButton:(BOOL)disabled {
	self.cancelButton.enabled = !disabled;
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Setup functions

- (void) setupForParentView:(UIView*)aView options:(NSArray*)someOptions selectedOption:(NSString*)selected changeCallback:(ChoiceChangeBlock)selectionChangeBlock doneCallback:(ChoiceDoneBlock)selectionDoneCallback {
	self.options = someOptions;
	self.changeBlock = selectionChangeBlock;
	self.doneBlock = selectionDoneCallback;
	[self.picker reloadAllComponents];
	
	if (selected) {
		[self.picker selectRow:[self rowForOption:selected] inComponent:0 animated:YES];
	}
	
	[self addAndAnimateViews:aView];
}

- (int) rowForOption:(NSString*)option {
	int row = 0;
	for (int i = 0; i < self.options.count; i++) {
		if ([option isEqualToString:[self.options objectAtIndex:i]]) {
			row = i;
			i = self.options.count;
		}
	}
	return row;
}

- (void) addAndAnimateViews:(UIView*)aView {
	self.view.frame = CGRectMake(0.0f, 0.0f, aView.frame.size.width, aView.frame.size.height);
	self.view.alpha = 0.0;
	[aView addSubview:self.view];
	
	self.toolsHolder.frame = CGRectMake(0.0f, self.view.frame.size.height, self.toolsHolder.frame.size.width, self.toolsHolder.frame.size.height);

	UITextView *textView = [self previewTextView];
	if (textView) {
		textView.alpha = 0.0f;
		textView.hidden = !self.showFullPreview;
	}
	
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

- (UITextView*) previewTextView {
	return (UITextView*) [self.view viewWithTag:4242];
}

- (void) assertFullPreview {
	UITextView *textView = [self previewTextView];
	if (self.showFullPreview) {
		if (!textView) {
			textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, self.toolsHolder.frame.origin.y, 320.0f, 200.0f)];
			textView.textColor = [UIColor whiteColor];
			textView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
			textView.font = [UIFont systemFontOfSize:21.9f];
			textView.editable = NO;
			textView.userInteractionEnabled = NO;
			textView.tag = 4242;
			textView.alpha = 0.0f;
			textView.textAlignment = NSTextAlignmentCenter;
			[self.view addSubview:textView];
		}
		textView.text = @"";
	} else {
		if (textView) {
			textView.text = @"";
			textView.hidden = YES;
		}
	}
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Button functions

- (IBAction)pressedCancel:(id)sender {
	if (self.doneBlock) {
		self.doneBlock(nil, -1);
	}
	[self hideAndRemove];
}

- (IBAction)pressedDone:(id)sender {
	if (self.doneBlock) {
		self.doneBlock([self.options objectAtIndex:[self.picker selectedRowInComponent:0]], [self.picker selectedRowInComponent:0]);
	}
	[self hideAndRemove];
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - UIPickerView functions

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.options.count;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.options objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (self.changeBlock) {
		self.changeBlock([self.options objectAtIndex:row], row);
	}
	[self assertFullPreview];
	if (self.showFullPreview) {
		UITextView *textView = [self previewTextView];
		if (textView) {
			textView.text = [self.options objectAtIndex:row];
			CGSize newSize = [textView.text sizeWithFont:[UIFont systemFontOfSize:22.5f] constrainedToSize:CGSizeMake(320.0f, 200.0f) lineBreakMode:NSLineBreakByWordWrapping];
			CGFloat newHeight = newSize.height + 15.0f;
			CGRect newFrame = CGRectMake(0.0f, self.toolsHolder.frame.origin.y-newHeight, 320.0f, newHeight);;
			if (textView.alpha == 0.0f) {
				textView.frame = newFrame;
				[UIView animateWithDuration:0.25 animations:^(){
					textView.alpha = 1.0f;
				}];
			} else {
				[UIView animateWithDuration:0.25 animations:^(){
					textView.alpha = 1.0f;
					textView.frame = newFrame;
				}];
			}
		}
	}
}

@end
