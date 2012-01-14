# iVN - a Visual Novel Interpreter for iPod Touch, iPhone and iPad
iVN is a project for bringing Visual Novels to Apple iOS by "interpreting" the scripts from other engines.

The current version supports only *VNDS* (a homebrew Visual Novel engine for the Nintendo DS) due to the simplicity of the format being ideal for the sake of getting a framework up and running, but support for other engines will be added in later versions.

The current version will be replaced by a more flexible (and portable) OpenGL-based engine once the main difficulties are dealt with.

*NOTE:* This is not yet on the App Store. It's right before Beta stage, and will be released once it's finished. Feel free to help out!

## Features
#### No Jailbreak Required
    
Apple forbids Emulators and any kind of emulation in the App Store.
However, the word "Emulation" refers to translating microcode meant for one system to a format another system can understand, thus allowing a device or computer to run software it should not be able to run. And thus also run software Apple has not sanctioned.

iVN does not strictly speaking Emulate anything. It reads the script files used by another engine and displays what it reads. Thus it's operation is no different from for example an ebook reader - what it reads is a document, not an application.

#### Reads VNDS Scripts

VNDS is a homebrew application for the Nintendo DS that has received quite some popularity on the NDS Homebrew Market and among english-speaking Visual Novel fans.

It uses a simple text-based script format intended for use on a device much weaker than the iPhone, making it very easy to use and port games to.

As of writing, there are ports of a dozen or so visual novels, including _Saya no Uta_ (also known as _Saya's Song_), _Fate/Stay Night_, _Cross Channel_ and _Tsukihime_ to name a few, with ports of among others _Clannad_ and _Umineko no Naku Koro ni_ in progress on the forums.

#### Full Save Compatibility
iVN doesn't just read VNDS games, it can also both read and write it's save files. This means you can transfer saves freely back and forth between your DS and your iDevice!

## Fonts
iVN allows you to use any font built into iOS, and also includes these nonstandard ones:
* *Sazanami Gothic* - The original VNDS's default font
* *Osaka Mono* - Apple-developed Japanese typeface recommended by [Phlebas](http://twitter.com/#!/PhleBuster)
* *Osaka* - Variable Width version of Osaka Mono

## External Dependencies
Building the iVN Source requires these libraries to be present in the correct locations:

* [MacaroniTools](https://github.com/uppfinnarn/MacaroniTools)
A toolkit containing useful macros and utility categories.

* [TouchXML](https://github.com/TouchCode/TouchXML)
A Lightweight XML Processing library used for reading XML Save Files
*(Note: iVN Uses a not yet merged [branch](https://github.com/uppfinnarn/TouchXML), that mutes a Compiler Warning)*

* [SSZipArchive](https://github.com/samsoffes/ssziparchive)
Objective-C Wrapper around the C-Based MiniZip utility to compress and decompress ZIP archives.
*(Note: iVN Uses a not yet merged [branch](https://github.com/uppfinnarn/ssziparchive), that adds support for a Progress Delegate)*

## Version 2.0
A 'Version 2.0' is currently in very early stages of development. This version will use OpenGL for a more flexible and portable graphics engine, and a Plugin architecture to make adding support for new engines easy.

## Help out!
Feel free to branch the repo and add your own changes for me to pull back - this is a work in progress and there are always things that can be done better.

If you have ideas, questions, bugs or words of encouragement, please tell me! You can contact me at [*@uppfinnarn*](http://twitter.com/uppfinnarn) on Twitter or by email at *uppfinnarn (at) gmail (dot) com*.