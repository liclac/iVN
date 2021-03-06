//
//  GameViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "GameViewController.h"
#import "ScriptInterpreter.h"
#import "SoundEngine.h"
#import "Novel.h"
#import "Command.h"
#import "Sprite.h"
#import "State.h"
#import "Save.h"
#import "Script.h"

#import "SpriteView.h"
#import "StandardChoiceViewController.h"
#import "SaveLoadViewController.h"
#import "GameMenuViewController.h"

#import "UIDevice+Tools.h"
#import "UIWebView+BufferFunctions.h"


@implementation GameViewController
@synthesize gameView;
@synthesize sidebarView;
@synthesize interpreter;
@synthesize novel, backgroundImageView, spriteViews, textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
															 [NSNumber numberWithInteger:[UIFont systemFontSize]], kDefaultsKeyFontSize,
															 @"Sazanami Gothic", kDefaultsKeyFont,
															 [NSNumber numberWithInteger:16], kDefaultsKeySoundVolume,
															 [NSNumber numberWithInteger:8], kDefaultsKeyMusicVolume,
															 nil]];
	
	fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultsKeyFontSize];
	font = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsKeyFont];
	soundVolume = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultsKeySoundVolume];
	musicVolume = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultsKeyMusicVolume];
	
	textView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
	textView.opaque = NO;
	textView.userInteractionEnabled = NO;
	textView.delegate = self;
	NSData *indexData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
	[textView loadData:indexData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:[[NSBundle mainBundle] resourceURL]];
	[indexData release];
	
	interpreter = [[ScriptInterpreter alloc] initWithNovel:novel];
	interpreter.delegate = self;
	
	soundEngine = [[SoundEngine alloc] initWithNovel:novel];
	[soundEngine setVolume:soundVolume forChannel:VNSoundChannelSound];
	[soundEngine setVolume:musicVolume forChannel:VNSoundChannelMusic];
	
	spriteViews = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark - Interpreter
- (void)interpreter:(ScriptInterpreter *)si processBGLOAD:(Command *)command
{
	NSTimeInterval time = 0.16;
	if([command parameterCount] > 2)
		time = [[command parameterAtIndex:2 defaultValue:nil] integerValue]/100;
	NSString *path = [command parameterAtIndex:0 defaultValue:nil];
	
	[self loadBackground:path fadeTime:time fromSave:NO];
}

- (void)interpreter:(ScriptInterpreter *)si processSETIMG:(Command *)command
{
	//MTMark();
	
	NSTimeInterval time = 0.16;
	if([command parameterCount] > 2)
		time = [[command parameterAtIndex:2 defaultValue:nil] integerValue]/100;
	
	CGPoint point = CGPointMake([[command parameterAtIndex:1 defaultValue:nil] integerValue],
								[[command parameterAtIndex:2 defaultValue:nil] integerValue]);
	NSString *path = [@"foreground" stringByAppendingPathComponent:[command parameterAtIndex:0 defaultValue:nil]];
	Sprite *sprite = [[Sprite alloc] initWithPath:path data:[novel contentsOfResource:path] point:point];
	[self addSprite:sprite fadeTime:time fromSave:NO];
	[sprite release];
}

- (void)interpreter:(ScriptInterpreter *)si processSOUND:(Command *)command
{
	//MTMark();
	[soundEngine playSound:[command parameterAtIndex:0 defaultValue:nil] onChannel:VNSoundChannelSound
					 loops:[[command parameterAtIndex:1 defaultValue:nil] integerValue]];
}

- (void)interpreter:(ScriptInterpreter *)si processMUSIC:(Command *)command
{
	//MTMark();
	[soundEngine playSound:[command parameterAtIndex:0 defaultValue:nil]
				 onChannel:VNSoundChannelMusic loops:0];
}

- (void)interpreter:(ScriptInterpreter *)si processTEXT:(Command *)command
{
	//MTMark();
	[self writeLine:[command text] quickly:NO];
}

- (void)interpreter:(ScriptInterpreter *)si processCHOICE:(Command *)command
{
	//MTMark();
	choiceOpen = YES;
	StandardChoiceViewController *vc = [[StandardChoiceViewController alloc]
										initWithOptions:[command.text componentsSeparatedByString:@"|"]
										textView:textView novel:novel delegate:self];
	vc.frame = backgroundImageView.frame;
	[self.view addSubview:vc.view];
	[vc show];
	[vc release];
}

- (void)interpreter:(ScriptInterpreter *)si processSETVAR:(Command *)command
{
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processGSETVAR:(Command *)command
{
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processIF:(Command *)command
{
	//NOTE: Handled by the Script Interpreter
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processFI:(Command *)command
{
	//NOTE: Handled by the Script Interpreter
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processJUMP:(Command *)command
{
	//NOTE: Handled by the Script Interpreter
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processDELAY:(Command *)command
{
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processRANDOM:(Command *)command
{
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processSKIP:(Command *)command
{
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processENDSCRIPT:(Command *)command
{
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processLABEL:(Command *)command
{
	//NOTE: Handled by the Script Interpreter
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processGOTO:(Command *)command
{
	//NOTE: Handled by the Script Interpreter
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si processCLEARTEXT:(Command *)command
{
	//>>textView.text = nil;
	[textView clearBuffer];
	
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si restoreWithTextBuffer:(NSMutableArray *)buffer
{
	MTMark();
	
	//Update Background & Music
	[self loadBackground:novel.currentState.background fadeTime:0 fromSave:YES];
	[soundEngine playSound:novel.currentState.music onChannel:VNSoundChannelMusic loops:0];
	
	//Update Sprites
	//NOTE: Due to `self.scaleFactor` being calculated in -[loadBackground:fadeTime:fromSave:], the sprites have to be loaded AFTER that
	for(SpriteView *view in spriteViews) [view removeFromSuperview];
	for(Sprite *sprite in novel.currentState.sprites) [self addSprite:sprite fadeTime:0 fromSave:YES];
	
	//Loop through all the lines and write them to the text area
	[textView clearBuffer];
	for(NSString *line in buffer) [self writeLine:line quickly:YES];
	[self updateOffset];
}


#pragma mark - Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(choiceOpen) return;
	
	CGPoint origin = [[touches anyObject] locationInView:self.view];
	if(origin.x < gameView.frame.size.width && origin.y < gameView.frame.size.height)
	{
		touchOrigin = origin;
		originalOffset = textView.scrollView.contentOffset.y;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(choiceOpen || touchOrigin.x < 0 || touchOrigin.y < 0) return;
	
	moved = YES;
	CGFloat length = touchOrigin.y - [[touches anyObject] locationInView:self.view].y;
	CGFloat offset = originalOffset + length;
	if(offset > textView.scrollView.contentSize.height - textView.frame.size.height)
		offset = textView.scrollView.contentSize.height - textView.frame.size.height;
	if(offset < 0) offset = 0;
	textView.scrollView.contentOffset = CGPointMake(0, offset);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(choiceOpen || touchOrigin.x < 0 || touchOrigin.y < 0) return;
	
	if([[UIDevice currentDevice] isPad] && sidebarView.alpha < 0.5) [self actionToggleText];
	else if(!moved && touchOrigin.x < gameView.frame.size.width && touchOrigin.y < gameView.frame.size.height)
		[interpreter processNextCommand:nil];
	
	moved = NO;
	touchOrigin = CGPointMake(-1, -1);
}


#pragma mark - Interface
- (void)writeLine:(NSString *)text quickly:(BOOL)quickly
{
	MTLog(@"%@", text);
	
	if(text == nil || [text isEqualToString:@"~"] || [text isEqualToString:@"!"]) text = @"";
	else if([text hasPrefix:@"@"]) text = [text substringFromIndex:1];
	
	[textView addLine:text];
}

- (void)updateOffset
{
	CGFloat offset = textView.scrollView.contentSize.height - textView.frame.size.height;
	textView.scrollView.contentOffset = CGPointMake(0, (offset > 0 ? offset : 0));
}

- (void)addSprite:(Sprite *)sprite fadeTime:(NSTimeInterval)time fromSave:(BOOL)fromSave
{
	MTMark();
	SpriteView *view = [[SpriteView alloc] initWithFrame:gameView.bounds sprite:sprite scale:scaleFactor];
	[spriteViews addObject:view];
	[backgroundImageView addSubview:view];
	if(time > 0) [view fadeInWithDuration:time];
	else view.alpha = 1;
	[view release];
	
	if(!fromSave) [novel.currentState.sprites addObject:sprite];
}

- (void)loadBackground:(NSString *)background fadeTime:(NSTimeInterval)time fromSave:(BOOL)fromSave
{
	if(!fromSave)
		for(SpriteView *spriteView in spriteViews) [spriteView fadeOutWithDuration:time];
	
	UIImage *img = [[UIImage alloc] initWithData:[novel contentsOfResource:[@"background/" stringByAppendingPathComponent:background]]];
	if(img != nil)
	{
		CGFloat scale = backgroundImageView.frame.size.width/img.size.width;
		scaleFactor = round(scale*4)/4;
		MTLog(@"Scale: %f", scaleFactor);
		backgroundImageView.image = img;
		
		CGFloat width = img.size.width*scaleFactor;
		CGFloat height = img.size.height*scaleFactor;
		backgroundImageView.frame = CGRectMake((backgroundImageView.superview.frame.size.width - width)/2,
											   backgroundImageView.superview.frame.origin.y + ((backgroundImageView.superview.frame.size.height-height)/2),
											   width, height);
	}
	
	[img release];
	
	novel.currentState.background = background;
	if(!fromSave) [novel.currentState.sprites removeAllObjects];
}


#pragma mark - Delegates
- (void)choiceClosed:(ChoiceViewController *)choice
{
	choiceOpen = NO;
	[interpreter choiceClosed:choice];
}

- (UIView *)viewForSaveThumbnail
{
	return backgroundImageView;
}


#pragma mark - Actions
- (void)actionMenu:(UIButton *)sender
{
	GameMenuViewController *vc = [[GameMenuViewController alloc] init];
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
	nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	nc.navigationBarHidden = YES;
	vc.gameVC = self;
	vc.fontSize = &fontSize;
	vc.font = &font;
	vc.soundVolume = &soundVolume;
	vc.musicVolume = &musicVolume;
	if([[UIDevice currentDevice] isPad])
	{
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nc];
		vc.padPopoverController = popover;
		popover.delegate = vc;
		[popover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
		[popover release];
	}
	else [self presentModalViewController:nc animated:YES];
	[nc release];
	[vc release];
}

- (void)actionSkip
{
	interpreter.skipping = YES;
	[interpreter processNextCommand:nil];
}

- (IBAction)actionStopSkipping
{
	interpreter.skipping = NO;
}

- (IBAction)actionToggleText
{
	[UIView animateWithDuration:0.2 delay:0
						options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 textView.alpha = (textView.alpha > 0 ? 0 : 1);
						 if([[UIDevice currentDevice] isPad]) sidebarView.alpha = (sidebarView.alpha > 0 ? 0 : 0.5);
					 }
					 completion:NULL];
}

- (void)actionLoad
{
	SaveLoadViewController *vc = [[SaveLoadViewController alloc] init];
	vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	vc.novel = novel;
	vc.si = interpreter;
	vc.mode = VNSaveLoadModeLoad;
	vc.delegate = self;
	[self presentModalViewController:vc animated:YES];
	[vc release];
}

- (void)actionSave
{
	SaveLoadViewController *vc = [[SaveLoadViewController alloc] init];
	vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	vc.novel = novel;
	vc.si = interpreter;
	vc.mode = VNSaveLoadModeSave;
	vc.delegate = self;
	[self presentModalViewController:vc animated:YES];
	[vc release];
}

- (void)actionExit
{
	[soundEngine stopChannel:VNSoundChannelMusic];
	[soundEngine stopChannel:VNSoundChannelSound];
	[self quicksave];
	[novel.currentState reset];
	[self dismissModalViewControllerAnimated:YES];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)actionSettingsChanged
{
	[soundEngine setVolume:soundVolume forChannel:VNSoundChannelSound];
	[soundEngine setVolume:musicVolume forChannel:VNSoundChannelMusic];
	[textView setFontSize:fontSize];
	[textView setFont:font];
	[self updateOffset];
}

- (void)actionSettingsClosed
{
	[[NSUserDefaults standardUserDefaults] setInteger:fontSize forKey:kDefaultsKeyFontSize];
	[[NSUserDefaults standardUserDefaults] setObject:font forKey:kDefaultsKeyFont];
	[[NSUserDefaults standardUserDefaults] setInteger:soundVolume forKey:kDefaultsKeySoundVolume];
	[[NSUserDefaults standardUserDefaults] setInteger:musicVolume forKey:kDefaultsKeyMusicVolume];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Text View
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[textView setFont:font];
	[textView setFontSize:fontSize];
	if(novel.quicksave.exists) [self quickload];
	else [interpreter processNextCommand:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quicksave)
												 name:UIApplicationDidEnterBackgroundNotification object:nil];
}


#pragma mark - Quicksaves
- (void)quicksave
{
	[novel.quicksave saveWithScriptInterpreter:interpreter];
}

- (void)quickload
{
	[novel.quicksave loadWithScriptInterpreter:interpreter];
}

@end
