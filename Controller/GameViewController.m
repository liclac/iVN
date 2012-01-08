//
//  GameViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "GameViewController.h"
#import "ScriptInterpreter.h"
#import "Novel.h"
#import "Command.h"
#import "Sprite.h"
#import "State.h"
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
@synthesize interpreter, soundEngine;
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
															 [NSNumber numberWithDouble:12], kDefaultsKeyFontSize,
															 [NSNumber numberWithDouble:16/16], kDefaultsKeySoundVolume,
															 [NSNumber numberWithDouble:8/16], kDefaultsKeyMusicVolume,
															 nil]];
	
	fontSize = [[NSUserDefaults standardUserDefaults] doubleForKey:kDefaultsKeyFontSize];
	soundVolume = [[NSUserDefaults standardUserDefaults] doubleForKey:kDefaultsKeySoundVolume];
	musicVolume = [[NSUserDefaults standardUserDefaults] doubleForKey:kDefaultsKeyMusicVolume];
	
	textView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
	textView.opaque = NO;
	textView.userInteractionEnabled = NO;
	[textView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"]]];
	[textView setFontSize:fontSize];
	
	interpreter = [[ScriptInterpreter alloc] initWithNovel:novel];
	interpreter.delegate = self;
	
	spriteViews = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [self setBackgroundImageView:nil];
	[self setTextView:nil];
	[self setGameView:nil];
	[self setSidebarView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(!started)
	{
		started = YES;
		[interpreter processNextCommand:nil];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [backgroundImageView release];
	[textView release];
	[gameView release];
	[sidebarView release];
    [super dealloc];
}


#pragma mark - Interpreter
- (void)interpreter:(ScriptInterpreter *)si processBGLOAD:(Command *)command
{
	NSTimeInterval time = 0.16;
	if([command.parameters count] > 1)
		time = [[command.parameters objectAtIndex:2] integerValue]/100;
	NSString *path = [command.parameters objectAtIndex:0];
	
	[self loadBackground:path fadeTime:time fromSave:NO];
}

- (void)interpreter:(ScriptInterpreter *)si processSETIMG:(Command *)command
{
	//MTMark();
	
	NSTimeInterval time = 0.16;
	if([command.parameters count] > 1)
		time = [[command.parameters objectAtIndex:2] integerValue]/100;
	
	CGPoint point = CGPointMake([[command.parameters objectAtIndex:1] integerValue],
								[[command.parameters objectAtIndex:2] integerValue]);
	NSString *path = [@"foreground" stringByAppendingPathComponent:[command.parameters objectAtIndex:0]];
	Sprite *sprite = [[Sprite alloc] initWithPath:path
										  absPath:[novel relativeToAbsolutePath:path]
											point:point];
	[self addSprite:sprite fadeTime:time fromSave:NO];
	[sprite release];
}

- (void)interpreter:(ScriptInterpreter *)si processSOUND:(Command *)command
{
	//MTMark();
	[self playSound:[command.parameters objectAtIndex:0] onMusicChannel:NO
			  loops:([command.parameters count] > 1 ? [[command.parameters objectAtIndex:1] integerValue] : 0)
		   fromSave:NO];
}

- (void)interpreter:(ScriptInterpreter *)si processMUSIC:(Command *)command
{
	//MTMark();
	[self playSound:[command.parameters objectAtIndex:0] onMusicChannel:YES
			  loops:0 //Loops are ignored on the music channel anyways
		   fromSave:NO];
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
	lineCount = 0;
	
	//MTMark();
}

- (void)interpreter:(ScriptInterpreter *)si restoreWithTextBuffer:(NSMutableArray *)buffer
{
	MTMark();
	
	//Loop through all the lines and write them to the text area
	//>>textView.text = nil;
	[textView clearBuffer];
	lineCount = 0;
	for(NSString *line in buffer) [self writeLine:line quickly:YES];
	[self updateOffset];
	
	//Update Background & Music
	[self loadBackground:novel.currentState.background fadeTime:0 fromSave:YES];
	[self playSound:novel.currentState.music onMusicChannel:YES loops:0 fromSave:YES];
	
	//Update Sprites
	//NOTE: Due to `self.scaleFactor` being calculated in -[loadBackground:fadeTime:fromSave:], the sprites have to be loaded afterwards
	for(SpriteView *view in spriteViews) [view removeFromSuperview];
	for(Sprite *sprite in novel.currentState.sprites) [self addSprite:sprite fadeTime:0 fromSave:YES];
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
- (void)playSound:(NSString *)filename onMusicChannel:(BOOL)music loops:(NSInteger)loops fromSave:(BOOL)fromSave
{
	AVAudioPlayer *player = (music ? musicPlayer : soundPlayer);
	[player stop];
	[player release];
	
	if([filename isEqualToString:@"~"])
	{
		if(music) musicPlayer = nil;
		else soundPlayer = nil;
	}
	else
	{
		NSError *error = nil;
		NSString *path = [novel relativeToAbsolutePath:[@"sound" stringByAppendingPathComponent:filename]];
		AVAudioPlayer *newPlayer =  [[AVAudioPlayer alloc]
									 initWithContentsOfURL:[NSURL fileURLWithPath:path]
									 error:&error];
		if(music)
		{
			novel.currentState.music = filename;
			newPlayer.volume = musicVolume;
			musicPlayer = newPlayer;
		}
		else
		{
			[newPlayer setNumberOfLoops:loops];
			newPlayer.volume = soundVolume;
			soundPlayer = newPlayer;
		}
		
		if(error != nil) MTLog(@"%@ -> %@: %@", filename, path, error);
		else
		{
			MTLog(@"Playing %@ %@", (music ? @"Music" : @"Sound"), filename);
			[newPlayer play];
		}
	}
}

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
	
	UIImage *img = [[UIImage alloc] initWithContentsOfFile:
					[novel relativeToAbsolutePath:[@"background" stringByAppendingPathComponent:background]]];
	if(img != nil)
	{
		scaleFactor = CGSizeMake(backgroundImageView.frame.size.width/img.size.width,
								 backgroundImageView.frame.size.height/img.size.height);
		MTLog(@"Scale: %@", NSStringFromCGSize(scaleFactor));
		backgroundImageView.image = img;
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
	vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	vc.gameVC = self;
	vc.fontSize = &fontSize;
	vc.soundVolume = &soundVolume;
	vc.musicVolume = &musicVolume;
	if([[UIDevice currentDevice] isPad])
	{
		UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
		vc.padPopoverController = popover;
		popover.delegate = vc;
		[popover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
		[popover release];
	}
	else [self presentModalViewController:vc animated:YES];
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
	[soundPlayer stop];
	[musicPlayer stop];
	[novel.currentState reset];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)actionMenuClosed
{
	[[NSUserDefaults standardUserDefaults] setDouble:fontSize forKey:kDefaultsKeyFontSize];
	[[NSUserDefaults standardUserDefaults] setDouble:soundVolume forKey:kDefaultsKeySoundVolume];
	[[NSUserDefaults standardUserDefaults] setDouble:musicVolume forKey:kDefaultsKeyMusicVolume];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	musicPlayer.volume = musicVolume;
	soundPlayer.volume = soundVolume;
	[textView setFontSize:fontSize];
	[self updateOffset];
}

@end
