//
//  RootViewController.m
//  MSC20Demo
//
//  Created by yangchen on 11-3-24.
//  Copyright 2011 IFLYTEK. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

- (id)init
{
	if (self = [super initWithStyle:UITableViewStyleGrouped])
	{
		self.title = TITLE;
		
		_tableArray = [[NSArray alloc] initWithObjects:@"语音识别",@"语音转写",@"语音合成",nil];

        
        _asrController = [[UIAsrController alloc] init];
        
		_recognizeController = [[UIRecognizeController alloc] init];

		_synthesizerController = [[UISynthesizerController alloc] init];
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.tableView.allowsSelection = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)onRecognizer
{
	[self.navigationController pushViewController:_recognizeController animated:YES];
	
}
//- (void)onKeyword
//{
//	[self.navigationController pushViewController:_keywordController animated:YES];
//	
//}

- (void) onAsr
{
    [self.navigationController pushViewController:_asrController animated:YES];
}

- (void)onSynthesizer
{
	[self.navigationController pushViewController:_synthesizerController animated:YES];
	
}
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 0;
	if (indexPath.section == 0) 
	{
		height = 185;
	}
	else 
	{
		height = 110;
	}
	return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* sectionTitle = nil;
	switch (section) 
	{
		case 0:
			sectionTitle = SECTION_TITLE1;
			break;
		case 1: 
			sectionTitle = SECTION_TITLE2;
			break;
	}
	return sectionTitle;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    }
	
	//cell.textLabel.text = [_tableArray objectAtIndex:indexPath.row];
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	// Configure the cell.
	
	if (indexPath.section == 0)
	{
		UITextView *textview = [[[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 100)] autorelease];
		textview.backgroundColor = [UIColor clearColor];
		textview.scrollEnabled = NO;
		textview.editable = NO;
		textview.text = RECOGNIZE_TITLE;
		[cell addSubview:textview];
		
		UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button1.frame = CGRectMake(20, 90, 280, 40);
		
		[button1 setTitle:BUTTON_TITLE1 forState:UIControlStateNormal];
		[cell addSubview:button1];
		
		[button1 addTarget:self action:@selector(onRecognizer) forControlEvents:UIControlEventTouchDown];

		UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button2.frame = CGRectMake(20, 135, 280, 40);
		[button2 setTitle:BUTTON_TITLE2 forState:UIControlStateNormal];
//		[button2 addTarget:self action:@selector(onKeyword) forControlEvents:UIControlEventTouchDown];
        [button2 addTarget:self action:@selector(onAsr) forControlEvents:UIControlEventTouchDown];
		
		[cell addSubview:button2];		
	}
	else
	{
		UITextView *textview = [[[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 50)] autorelease];
		textview.backgroundColor = [UIColor clearColor];
		textview.text = SYNTHESIZER_TITLE;
		textview.scrollEnabled = NO;
		textview.editable = NO;
		[cell addSubview:textview];
		
		UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button1.frame = CGRectMake(20, 60, 280, 40);
		[button1 setTitle:BUTTON_TITLE3 forState:UIControlStateNormal];
		[button1 addTarget:self action:@selector(onSynthesizer) forControlEvents:UIControlEventTouchDown];

		[cell addSubview:button1];
	}


    return cell;
}

#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	

	UIViewController *detailViewController;

	switch (indexPath.row) 
	{
		case 0:
			detailViewController = _asrController;
			break;
		case 1:
			detailViewController = _recognizeController;
			break;
		case 2:
			detailViewController = _synthesizerController;
			break;
		default:
			break;
	}

	[self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark -
#pragma mark 系统调用

- (void)dealloc {
    
    [_asrController release];
    
    [super dealloc];
}

/*
#ifdef __IPHONE_3_0
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
#else
	- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {    
		UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
#endif
		
		if (interfaceOrientation == UIInterfaceOrientationPortrait 
			|| interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
		{// 竖屏幕设置视图坐标
			
		}
		else 
		{// 横屏幕设置视图坐标
			
		}
	}
	
	// Override to allow orientations other than the default portrait orientation.
	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{	
		// Return YES for supported orientations
		return YES;
		
	}*/


@end

