//
//  Save.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "TouchXML.h"

#import "Save.h"
#import "SaveImage.h"
#import "Novel.h"
#import "State.h"
#import "Script.h"
#import "Variable.h"
#import "Sprite.h"
#import "ScriptInterpreter.h"

@interface Save(Private)
- (NSString *)path;
@end

@implementation Save
@synthesize novel, slot, exists, date, state, image;


#pragma mark - Initialization & Data
- (id)initWithNovel:(Novel *)aNovel saveSlot:(NSInteger)aSlot
{
    if ((self = [super init]))
	{
		novel = aNovel;
		slot = aSlot;
		
		NSFileManager *fm = [[NSFileManager alloc] init];
		exists = [fm fileExistsAtPath:[self path]];
		[fm release];
    }
    
    return self;
}

- (void)collectDataFromParent
{
	self.state = [[novel.currentState copy] autorelease];
}

- (void)loadDate
{
	NSError *error = nil;
	NSString *source = [[NSString alloc] initWithContentsOfFile:[self path] encoding:NSUTF8StringEncoding error:&error];
	if(error)
	{
		MTLog(@"%@", error);
		self.date = @"---";
		[source release];
		return;
	}
	
	NSRange startRange = [source rangeOfString:@"<date>"];
	NSRange endRange = [source rangeOfString:@"</date>"];
	NSRange dateRange = NSMakeRange(startRange.location + startRange.length,
									endRange.location - (startRange.location + startRange.length));
	MTLog(@"SR: %@ ER: %@ DR: %@", NSStringFromRange(startRange), NSStringFromRange(endRange), NSStringFromRange(dateRange));
	self.date = [source substringWithRange:dateRange];
	
	[source release];
}

- (NSString *)path
{
	/*
	 * Note the use of "%02d" instead of "%d": This ensures that the slot number is 2 digits wide and padded with zeroes,
	 * eg. Slot 1 would become "save01.sav" rather than "save1.sav".
	 * Slot "-1" is tanslated into "global.sav" automatically.
	 */
	return [novel relativeToAbsolutePath:(slot > -1 ? [NSString stringWithFormat:@"save/save%02d.sav", slot] : @"save/global.sav")];
}


#pragma mark - Saving
- (void)saveWithScriptInterpreter:(ScriptInterpreter *)si
{
	NSFileManager *fm = [[NSFileManager alloc] init];
	NSError *error = nil;
	if(![fm createDirectoryAtPath:[novel relativeToAbsolutePath:@"save"] withIntermediateDirectories:YES attributes:nil error:&error])
	{
		MTLog(@"Couldn't create save directory: %@", error);
		[fm release];
		return;
	}
	
	exists = YES;
	
	[self collectDataFromParent];
	[self saveXml];
	[image writeToFile];
	
	[fm release];
}

- (void)saveXml
{
	/**
	 * This code was ported directly from VNDS's 'saveload.cpp'.
	 * The only real difference is that we use NSStrings, not CStrings (%s => %@),
	 * and write the buffer to an NSMutableString rather than directly to disk.
	 * Also, -[saveDate] doesn't take a buffer argument as it always writes to the 'date' variable.
	 */
	
	NSMutableString *saveContents = [[NSMutableString alloc] init];
	
	if(slot > -1)
	{
		[saveContents appendString:@"<save>\n"];
		
		//Script State
		MTLog(@"%@ %d %d", state, state.position, state.textSkip);
		[saveContents appendFormat:@"  <script><file>%@</file><position>%d</position></script>\n", state.script.localPath, state.textSkip];
		
		//Date
		[self saveDate];
		[saveContents appendFormat:@"  <date>%@</date>\n", date];
		
		//Variables
		[saveContents appendString:@"  <variables>\n"];
		[self saveVars:saveContents indentation:4];
		[saveContents appendString:@"  </variables>\n"];
		
		//Other State (the { } doesn't actually have a function, it's just for readability)
		[saveContents appendString:@"  <state>\n"];
		{
			[saveContents appendFormat:@"    <music>%@</music>\n", (state.music != nil ? state.music : @"")];
			[saveContents appendFormat:@"    <background>%@</background>\n", (state.background != nil ? state.background : @"")];
			
			[saveContents appendString:@"    <sprites>\n"];
			for(Sprite *sprite in state.sprites)
			{
				[saveContents appendFormat:@"      <sprite path=\"%@\" x=\"%d\" y=\"%d\"/>\n",
				 sprite.path, (int)sprite.point.x, (int)sprite.point.y];
			}
			[saveContents appendString:@"    </sprites>\n"];
		}
		[saveContents appendString:@"  </state>\n"];
		[self saveIOSData:saveContents];
		[saveContents appendString:@"</save>\n"];
	}
	else
	{
		[saveContents appendString:@"<global>\n"];
		[self saveVars:saveContents indentation:2];
		[saveContents appendString:@"</global>\n"];
	}
	
	NSError *error = nil;
	if(![saveContents writeToFile:[self path] atomically:YES encoding:NSUTF8StringEncoding error:&error])
	{
		MTLog(@"Couldn't write save to %@: %@", [self path], error);
	}
	[saveContents release];
}

- (void)saveDate
{
	NSDate *rawDate = [[NSDate alloc] init];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm yyyy/mm/dd"];
	
	[date release];
	date = [[formatter stringFromDate:rawDate] retain];
	
	[rawDate release];
	[formatter release];
}

- (void)saveVars:(NSMutableString *)str indentation:(NSInteger)indent
{
	//Copy-pasted from VNDS's 'saveload.cpp', simply because C/C++ is more efficient at filling strings with padding than ObjC is
	char s[indent+1];
	memset(s, ' ', indent);
	s[indent] = '\0';
	
	//Loop through all variables and write them out
	NSArray *variables = [state.vars allValues];
	for(Variable *var in variables)
	{
		if(var.type != VNVariableTypeUnknown) continue; //Skip Variables with an unknown type
		
		//Write variables to the output string
		[str appendFormat:@"%s<var name=\"%@\" type=\"%@\" value=\"%@\" />\n",
		 s,																					//Indentation
		 (var.type == VNVariableTypeInt ? @"int" : @"str"),									//Variable Type, either 'int' or 'str'
		 var.value];																		//Value
	}
}

- (void)saveIOSData:(NSMutableString *)str
{
	[str appendFormat:@"  <ios absolutePosition=\"%d\" />\n", state.position];
}

- (void)saveIOSCache
{
	
}



#pragma mark - Loading
- (void)loadWithScriptInterpreter:(ScriptInterpreter *)si
{
	[self loadState];
	
	[novel.currentState reset]; //Make sure to unload the in-memory command cache
	novel.currentState = state;
	[si saveLoaded:self];
}

- (void)loadState
{
	//Prepare a State
	[state release];
	state = [[State alloc] init];
	
	//Load XML
	NSData *data = [[NSData alloc] initWithContentsOfFile:[self path]];
	if(data == nil) return; //If there's no data to load, don't do anything
	NSError *error = nil;
	CXMLDocument *doc = [[CXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding options:0 error:&error];
	MTAssertReturn(error == nil, @"Couldn't create XML Document: %@", error);
	CXMLElement *rootE = [doc rootElement];
	
	//Variables
	@try
	{
		CXMLElement *variablesE = [[rootE elementsForName:@"variables"] objectAtIndex:0];
		[self loadVars:variablesE];
	}
	@catch (NSException *exception) {}
	
	//Script Engine
	CXMLElement *scriptE = nil;
	NSString *scriptPath = nil;
	@try
	{
		scriptE = [[rootE elementsForName:@"script"] objectAtIndex:0];
		scriptPath = [[[scriptE  elementsForName:@"file"] objectAtIndex:0] stringValue];
	}
	@catch (NSException *exception) {}
	
	NSInteger position = 0;
	CXMLElement *positionE = nil;
	@try { positionE = [[scriptE elementsForName:@"position"] objectAtIndex:0]; }
	@catch (NSException *exception) {}
	
	if(positionE) position = MAX(0, [[positionE stringValue] integerValue]);
	
	Script *script = [novel.scripts objectForKey:(scriptPath ? scriptPath : @"main.scr")];
	state.script = script;
	state.textSkip = position;
	
	CXMLElement *stateE = nil;
	@try { stateE = [[rootE elementsForName:@"state"] objectAtIndex:0]; }
	@catch (NSException *exception) {}
	
	if(stateE)
	{
		@try { state.background = [[[stateE elementsForName:@"background"] objectAtIndex:0] stringValue]; }
		@catch (NSException *exception) {}
		
		CXMLElement *spritesE = nil;
		@try { spritesE = [[stateE elementsForName:@"sprites"] objectAtIndex:0]; }
		@catch (NSException *exception) {}
		
		[state.sprites removeAllObjects];
		for(CXMLElement *spriteE in [spritesE children])
		{
			if(![[spriteE name] isEqualToString:@"sprite"])
				continue;
			
			int x = [[[spriteE attributeForName:@"x"] stringValue] intValue];
			int y = [[[spriteE attributeForName:@"y"] stringValue] intValue];
			NSString *path = [[spriteE attributeForName:@"path"] stringValue];
			
			//Sprite *sprite = [[Sprite alloc] initWithPath:path absPath:[novel relativeToAbsolutePath:path] point:CGPointMake(x, y)];
			Sprite *sprite = [[Sprite alloc] initWithPath:path data:[novel contentsOfResource:path] point:CGPointMake(x, y)];
			[state.sprites addObject:sprite];
			[sprite release];
		}
		
		//Note: "Music" is sometimes a nonsensical sequence of hex values or it might be nil and is much more likely to fail than
		//any other tag in the save
		@try { state.music = [[[stateE elementsForName:@"music"] objectAtIndex:0] stringValue]; }
		@catch (NSException *exception) {}
	}
	
	//iOS Additions
	CXMLElement *iosE = nil;
	@try { iosE = [[rootE elementsForName:@"ios"] objectAtIndex:0]; }
	@catch (NSException *exception) {}
	
	if(iosE)
	{
		
	}
	
	//Cleanup
	[doc release];
	[data release];
}

- (void)loadVars:(CXMLElement *)varsElement
{
	[state.vars removeAllObjects]; //Make sure we don't accidentally keep deleted variables by removing the old values first
	
	for(CXMLElement *element in [varsElement children])
	{
		if(![[element name] isEqualToString:@"var"]) continue; //Skip non-var elements
		
		NSString *name = [[element attributeForName:@"name"] stringValue];
		NSString *type = [[element attributeForName:@"type"] stringValue];
		
		id value = [[element attributeForName:@"value"] stringValue];
		if([type isEqualToString:@"int"]) value = [NSNumber numberWithInteger:[value integerValue]];
		
		Variable *var = [[Variable alloc] initWithKey:name value:value];
		[state.vars setObject:var forKey:name];
		[var release];
	}
}



#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
	Save *copy = [[Save allocWithZone:zone] initWithNovel:self.novel saveSlot:slot];
	copy.date = [[self.date copyWithZone:zone] autorelease];
	copy.state = [[self.state copyWithZone:zone] autorelease];
	
	return copy;
}

@end
