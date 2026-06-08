#import "WPAppDelegate.h"

@implementation WPAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
  (void)notification;
  [self buildMainMenu];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
  (void)sender;
  return YES;
}

- (void)buildMainMenu
{
  NSMenu *mainMenu = [[[NSMenu alloc] initWithTitle:@"WordProcessor"] autorelease];
  NSMenuItem *appMenuItem = [[[NSMenuItem alloc] initWithTitle:@"WordProcessor"
                                                        action:NULL
                                                 keyEquivalent:@""] autorelease];
  NSMenuItem *fileMenuItem = [[[NSMenuItem alloc] initWithTitle:@"File"
                                                         action:NULL
                                                  keyEquivalent:@""] autorelease];
  NSMenuItem *editMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Edit"
                                                         action:NULL
                                                  keyEquivalent:@""] autorelease];
  NSMenuItem *formatMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Format"
                                                           action:NULL
                                                    keyEquivalent:@""] autorelease];
  NSMenuItem *viewMenuItem = [[[NSMenuItem alloc] initWithTitle:@"View"
                                                         action:NULL
                                                  keyEquivalent:@""] autorelease];
  NSMenuItem *windowMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Window"
                                                           action:NULL
                                                    keyEquivalent:@""] autorelease];

  [mainMenu addItem:appMenuItem];
  [mainMenu addItem:fileMenuItem];
  [mainMenu addItem:editMenuItem];
  [mainMenu addItem:formatMenuItem];
  [mainMenu addItem:viewMenuItem];
  [mainMenu addItem:windowMenuItem];

  [appMenuItem setSubmenu:[self applicationMenu]];
  [fileMenuItem setSubmenu:[self fileMenu]];
  [editMenuItem setSubmenu:[self editMenu]];
  [formatMenuItem setSubmenu:[self formatMenu]];
  [viewMenuItem setSubmenu:[self viewMenu]];
  [windowMenuItem setSubmenu:[self windowMenu]];

  [NSApp setMainMenu:mainMenu];
}

- (NSMenu *)applicationMenu
{
  NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"WordProcessor"] autorelease];
  NSMenuItem *item = nil;

  item = (NSMenuItem *)[menu addItemWithTitle:@"About WordProcessor" action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];
  [item setTarget:NSApp];
  [menu addItem:[NSMenuItem separatorItem]];
  item = (NSMenuItem *)[menu addItemWithTitle:@"Services" action:NULL keyEquivalent:@""];
  [item setSubmenu:[[[NSMenu alloc] initWithTitle:@"Services"] autorelease]];
  [NSApp setServicesMenu:[item submenu]];
  [menu addItem:[NSMenuItem separatorItem]];
  item = (NSMenuItem *)[menu addItemWithTitle:@"Hide WordProcessor" action:@selector(hide:) keyEquivalent:@"h"];
  [item setTarget:NSApp];
  item = (NSMenuItem *)[menu addItemWithTitle:@"Hide Others" action:@selector(hideOtherApplications:) keyEquivalent:@"h"];
  [item setTarget:NSApp];
  [item setKeyEquivalentModifierMask:(NSEventModifierFlagCommand | NSEventModifierFlagOption)];
  item = (NSMenuItem *)[menu addItemWithTitle:@"Show All" action:@selector(unhideAllApplications:) keyEquivalent:@""];
  [item setTarget:NSApp];
  [menu addItem:[NSMenuItem separatorItem]];
  item = (NSMenuItem *)[menu addItemWithTitle:@"Quit WordProcessor" action:@selector(terminate:) keyEquivalent:@"q"];
  [item setTarget:NSApp];
  return menu;
}

- (NSMenu *)fileMenu
{
  NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"File"] autorelease];
  NSDocumentController *controller = [NSDocumentController sharedDocumentController];
  NSMenuItem *item = nil;

  item = (NSMenuItem *)[menu addItemWithTitle:@"New" action:@selector(newDocument:) keyEquivalent:@"n"];
  [item setTarget:controller];
  item = (NSMenuItem *)[menu addItemWithTitle:@"Open..." action:@selector(openDocument:) keyEquivalent:@"o"];
  [item setTarget:controller];
  item = (NSMenuItem *)[menu addItemWithTitle:@"Open Recent" action:NULL keyEquivalent:@""];
  [item setSubmenu:[self openRecentMenu]];
  [menu addItem:[NSMenuItem separatorItem]];
  [menu addItemWithTitle:@"Close" action:@selector(performClose:) keyEquivalent:@"w"];
  [menu addItemWithTitle:@"Save" action:@selector(saveDocument:) keyEquivalent:@"s"];
  [menu addItemWithTitle:@"Save As..." action:@selector(saveDocumentAs:) keyEquivalent:@"S"];
  [menu addItemWithTitle:@"Save To..." action:@selector(saveDocumentTo:) keyEquivalent:@""];
  [menu addItemWithTitle:@"Revert to Saved" action:@selector(revertDocumentToSaved:) keyEquivalent:@""];
  [menu addItem:[NSMenuItem separatorItem]];
  [menu addItemWithTitle:@"Page Setup..." action:@selector(runPageLayout:) keyEquivalent:@"P"];
  [menu addItemWithTitle:@"Print..." action:@selector(printDocument:) keyEquivalent:@"p"];
  return menu;
}

- (NSMenu *)openRecentMenu
{
  NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"Open Recent"] autorelease];
  NSMenuItem *item = (NSMenuItem *)[menu addItemWithTitle:@"Clear Menu"
                                                   action:@selector(clearRecentDocuments:)
                                            keyEquivalent:@""];
  [item setTarget:[NSDocumentController sharedDocumentController]];
  return menu;
}

- (NSMenu *)editMenu
{
  NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"Edit"] autorelease];
  [menu addItemWithTitle:@"Undo" action:@selector(undo:) keyEquivalent:@"z"];
  [menu addItemWithTitle:@"Redo" action:@selector(redo:) keyEquivalent:@"Z"];
  [menu addItem:[NSMenuItem separatorItem]];
  [menu addItemWithTitle:@"Cut" action:@selector(cut:) keyEquivalent:@"x"];
  [menu addItemWithTitle:@"Copy" action:@selector(copy:) keyEquivalent:@"c"];
  [menu addItemWithTitle:@"Paste" action:@selector(paste:) keyEquivalent:@"v"];
  [menu addItemWithTitle:@"Paste and Match Style" action:@selector(pasteAsPlainText:) keyEquivalent:@"V"];
  [menu addItemWithTitle:@"Delete" action:@selector(delete:) keyEquivalent:@""];
  [menu addItemWithTitle:@"Select All" action:@selector(selectAll:) keyEquivalent:@"a"];
  [menu addItem:[NSMenuItem separatorItem]];
  [menu addItemWithTitle:@"Find..." action:@selector(performFindPanelAction:) keyEquivalent:@"f"];
  [[menu itemWithTitle:@"Find..."] setTag:NSFindPanelActionShowFindPanel];
  [menu addItemWithTitle:@"Find Next" action:@selector(performFindPanelAction:) keyEquivalent:@"g"];
  [[menu itemWithTitle:@"Find Next"] setTag:NSFindPanelActionNext];
  [menu addItemWithTitle:@"Find Previous" action:@selector(performFindPanelAction:) keyEquivalent:@"G"];
  [[menu itemWithTitle:@"Find Previous"] setTag:NSFindPanelActionPrevious];
  [menu addItem:[NSMenuItem separatorItem]];
  [menu addItemWithTitle:@"Check Spelling" action:@selector(checkSpelling:) keyEquivalent:@";"];
  return menu;
}

- (NSMenu *)formatMenu
{
  NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"Format"] autorelease];
  NSMenu *fontMenu = [[[NSMenu alloc] initWithTitle:@"Font"] autorelease];
  NSMenu *textMenu = [[[NSMenu alloc] initWithTitle:@"Text"] autorelease];
  NSMenuItem *fontItem = [[[NSMenuItem alloc] initWithTitle:@"Font" action:NULL keyEquivalent:@""] autorelease];
  NSMenuItem *textItem = [[[NSMenuItem alloc] initWithTitle:@"Text" action:NULL keyEquivalent:@""] autorelease];

  [fontMenu addItemWithTitle:@"Show Fonts" action:@selector(orderFrontFontPanel:) keyEquivalent:@"t"];
  [fontMenu addItem:[NSMenuItem separatorItem]];
  [fontMenu addItemWithTitle:@"Bold" action:@selector(toggleBold:) keyEquivalent:@"b"];
  [fontMenu addItemWithTitle:@"Italic" action:@selector(toggleItalic:) keyEquivalent:@"i"];
  [fontMenu addItemWithTitle:@"Underline" action:@selector(underline:) keyEquivalent:@"u"];
  [fontMenu addItem:[NSMenuItem separatorItem]];
  [fontMenu addItemWithTitle:@"Bigger" action:@selector(modifyFont:) keyEquivalent:@"+"];
  [[fontMenu itemWithTitle:@"Bigger"] setTag:NSSizeUpFontAction];
  [fontMenu addItemWithTitle:@"Smaller" action:@selector(modifyFont:) keyEquivalent:@"-"];
  [[fontMenu itemWithTitle:@"Smaller"] setTag:NSSizeDownFontAction];

  [fontItem setSubmenu:fontMenu];
  [menu addItem:fontItem];
  [textMenu addItemWithTitle:@"Align Left" action:@selector(alignLeft:) keyEquivalent:@"{"];
  [textMenu addItemWithTitle:@"Center" action:@selector(alignCenter:) keyEquivalent:@"|"];
  [textMenu addItemWithTitle:@"Justify" action:@selector(alignJustified:) keyEquivalent:@""];
  [textMenu addItemWithTitle:@"Align Right" action:@selector(alignRight:) keyEquivalent:@"}"];
  [textMenu addItem:[NSMenuItem separatorItem]];
  [textMenu addItemWithTitle:@"Copy Ruler" action:@selector(copyRuler:) keyEquivalent:@""];
  [textMenu addItemWithTitle:@"Paste Ruler" action:@selector(pasteRuler:) keyEquivalent:@""];
  [textItem setSubmenu:textMenu];
  [menu addItem:textItem];
  [[NSFontManager sharedFontManager] setFontMenu:fontMenu];
  return menu;
}

- (NSMenu *)viewMenu
{
  NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"View"] autorelease];
  [menu addItemWithTitle:@"Show Ruler" action:@selector(toggleRuler:) keyEquivalent:@"r"];
  return menu;
}

- (NSMenu *)windowMenu
{
  NSMenu *menu = [[[NSMenu alloc] initWithTitle:@"Window"] autorelease];
  [menu addItemWithTitle:@"Minimize" action:@selector(performMiniaturize:) keyEquivalent:@"m"];
  [menu addItemWithTitle:@"Zoom" action:@selector(performZoom:) keyEquivalent:@""];
  [NSApp setWindowsMenu:menu];
  return menu;
}

@end
