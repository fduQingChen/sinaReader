//
//  UIAsrController.m
//  MSC20

//  description:

//  Created by msp on 12-10-23.
//
//

#import "UIAsrController.h"

@interface UIAsrController(private)

- (void) onButtonAsr;
- (void) onButtonSetup;
- (void) onButtonUpload;

@end
@implementation UIAsrController

@synthesize iflyRecognizeControl = _iflyRecognizeControl;
@synthesize grammer = _grammer;

- (id)init
{
	if (self = [super init])
	{
		self.title = TITLE;
	}
	return self;
}


- (void) onButtonAsr
{
    NSString *initParam = [[NSString alloc] initWithFormat:@"server_url=%@,appid=%@",ENGINE_URL,APPID];

    _iflyRecognizeControl = [[IFlyRecognizeControl alloc] initWithOrigin:H_CONTROL_ORIGIN initParam:initParam];
    [self.view addSubview: _iflyRecognizeControl];
    _iflyRecognizeControl.delegate = self;
    [_iflyRecognizeControl setEngine:nil engineParam:nil grammarID:_grammer];
    if ([_iflyRecognizeControl start]) {
        _upLoadButton.enabled = NO;
    }
}

- (void) onButtonSetup
{
    
}
- (void) onButtonUpload
{
    [self onUpdateTextView:@"正在登录......"];
    SpeechUser *usr = [[SpeechUser alloc] init];
    NSString *appid = [[NSString alloc] initWithFormat: @"appid=%@",APPID ];
    [usr login:nil password:nil params:appid];
    
    // 判断登录的状态
    if ([usr getLoginSate])
    {
        [self onUpdateTextView: @"登录成功"];
        _asrButton.enabled = NO;
        // 初始化数据上传控件
        UpLoadController *upLoadController = [[UpLoadController alloc] initWithOrigin:H_CONTROL_ORIGIN];
        [upLoadController setContent: @"asrName" data: ASRWORD params:@"subject=asr,data_type=keylist"];
        upLoadController.delegate = self;
        [self.view addSubview: upLoadController];
        [upLoadController start];
        
    }
    else
    {
        [self onUpdateTextView: @"登录失败"];
    }
    [usr release];
    [appid release];
}

- (void)onUpdateTextView:(NSString *)sentence
{
	_textView.text = sentence;
}

- (void)onAsrResult:(NSArray*)array
{
	NSMutableString *sentence = [[[NSMutableString alloc] init] autorelease];
	
	for (int i = 0; i < [array count]; i++)
	{
		[sentence appendFormat:@"%@		置信度:%@\n",[[array objectAtIndex:i] objectForKey:@"NAME"],
		 [[array objectAtIndex:i] objectForKey:@"SCORE"]];
	}
	[self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:sentence waitUntilDone:YES];
}
- (void)viewDidLoad
{
    
	[super viewDidLoad];
}

#pragma mark
#pragma 接口实现

- (void) onGrammer:(NSString *)grammer error:(int)err
{
    if (!err) {
        [self onUpdateTextView: @"上传成功"];
    }
    _asrButton.enabled = YES;
    NSLog(@"the error is:%d",err);
    self.grammer = grammer;
    
}

- (void) onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(int)error
{
    NSLog(@"识别结束回调finish.....");
    _upLoadButton.enabled = YES;

}

- (void) onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
    [self onAsrResult: resultArray];
}

#pragma mark
#pragma table source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    }
	
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	// Configure the cell.
	
	if (indexPath.section == 0)
	{
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input.png"]];
		imageView.frame = H_BACK_TEXTVIEW_FRAME;
		[cell addSubview:imageView];
		[imageView release];
		
		_textView = [[self addTextViewWithFrame:H_TEXTVIEW_FRAME theText:INTRODUCTION] retain];
		_textView.backgroundColor = [UIColor clearColor];
		[cell addSubview: _textView];
	}
	else
	{
		_asrButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_asrButton.frame = CGRectMake(20, 10, 280, 40);
		[_asrButton setTitle:@"开始识别" forState:UIControlStateNormal];
		[_asrButton addTarget:self action:@selector(onButtonAsr) forControlEvents:UIControlEventTouchDown];
		
		[cell addSubview:_asrButton];
		
		_upLoadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_upLoadButton.frame = CGRectMake(20, 60, 280, 40);
		[_upLoadButton setTitle:@"上传" forState:UIControlStateNormal];
		[_upLoadButton addTarget:self action:@selector(onButtonUpload) forControlEvents:UIControlEventTouchDown];
		
		[cell addSubview:_upLoadButton];
	}
	
    return cell;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_textView resignFirstResponder];
}
- (void) dealloc
{
    [_asrButton release];
    [_upLoadButton release];
    [_setUpButton release];
    [_grammer release];
    
    [_iflyRecognizeControl release];
    [super dealloc];
}
@end
