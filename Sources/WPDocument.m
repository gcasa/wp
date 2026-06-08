#import "WPDocument.h"

static NSString *WPDefaultDocumentType(void)
{
  return NSRTFTextDocumentType;
}

@implementation WPDocument

- (id)init
{
  self = [super init];
  if (self) {
    _loadedString = [[NSAttributedString alloc] initWithString:@""
                                                    attributes:[self defaultTypingAttributes]];
  }
  return self;
}

- (void)dealloc
{
  [_loadedString release];
  [super dealloc];
}

+ (BOOL)autosavesInPlace
{
  return YES;
}

+ (NSArray *)readableTypes
{
  return [NSArray arrayWithObjects:@"Rich Text Format", @"rtf", nil];
}

+ (NSArray *)writableTypes
{
  return [NSArray arrayWithObjects:@"Rich Text Format", @"rtf", nil];
}

+ (BOOL)isNativeType:(NSString *)type
{
  return ([type isEqualToString:@"Rich Text Format"] || [type isEqualToString:@"rtf"]);
}

- (NSString *)windowNibName
{
  return nil;
}

- (void)makeWindowControllers
{
  NSRect frame = NSMakeRect(0.0, 0.0, 760.0, 920.0);
  NSUInteger style = NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask;
  NSWindow *window = [[[NSWindow alloc] initWithContentRect:frame
                                                  styleMask:style
                                                    backing:NSBackingStoreBuffered
                                                      defer:NO] autorelease];
  _windowController = [[[NSWindowController alloc] initWithWindow:window] autorelease];

  [window setTitle:@"Untitled"];
  [window setReleasedWhenClosed:NO];
  [self buildEditorInWindow:window];
  [self addWindowController:_windowController];
}

- (void)buildEditorInWindow:(NSWindow *)window
{
  NSView *contentView = [window contentView];
  NSRect bounds = [contentView bounds];
  NSSize paperSize = [[self printInfo] paperSize];
  CGFloat pageWidth = paperSize.width > 0.0 ? paperSize.width : 612.0;

  _scrollView = [[[NSScrollView alloc] initWithFrame:bounds] autorelease];
  [_scrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
  [_scrollView setHasVerticalScroller:YES];
  [_scrollView setHasHorizontalScroller:YES];
  [_scrollView setBorderType:NSNoBorder];
  [_scrollView setRulersVisible:YES];
  [_scrollView setHasHorizontalRuler:YES];

  NSTextStorage *textStorage = [[[NSTextStorage alloc] init] autorelease];
  NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
  NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(pageWidth, 10000000.0)] autorelease];

  [layoutManager addTextContainer:textContainer];
  [textStorage addLayoutManager:layoutManager];
  [textContainer setWidthTracksTextView:NO];
  [textContainer setHeightTracksTextView:NO];

  _textView = [[[NSTextView alloc] initWithFrame:NSMakeRect(28.0, 28.0, pageWidth, bounds.size.height - 56.0)
                                   textContainer:textContainer] autorelease];
  [_textView setMinSize:NSMakeSize(0.0, bounds.size.height)];
  [_textView setMaxSize:NSMakeSize(10000000.0, 10000000.0)];
  [_textView setVerticallyResizable:YES];
  [_textView setHorizontallyResizable:YES];
  [_textView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
  [_textView setRichText:YES];
  [_textView setImportsGraphics:YES];
  [_textView setUsesFontPanel:YES];
  [_textView setUsesRuler:YES];
  [_textView setAllowsUndo:YES];
  [_textView setContinuousSpellCheckingEnabled:YES];
#ifdef __APPLE__
  [_textView setGrammarCheckingEnabled:YES];
  [_textView setAutomaticQuoteSubstitutionEnabled:YES];
  [_textView setAutomaticDashSubstitutionEnabled:YES];
#endif
  [_textView setTypingAttributes:[self defaultTypingAttributes]];
  [_textView setDelegate:self];
  [_textView setBackgroundColor:[NSColor whiteColor]];

  [_scrollView setDocumentView:_textView];
  [contentView addSubview:_scrollView];

  if (_loadedString) {
    _loadingContent = YES;
    [[_textView textStorage] setAttributedString:_loadedString];
    _loadingContent = NO;
  }
}

- (NSDictionary *)defaultTypingAttributes
{
  NSMutableParagraphStyle *paragraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
  [paragraph setLineSpacing:1.0];
  [paragraph setParagraphSpacing:6.0];

  return [NSDictionary dictionaryWithObjectsAndKeys:
          [NSFont userFontOfSize:12.0], NSFontAttributeName,
          [NSColor textColor], NSForegroundColorAttributeName,
          paragraph, NSParagraphStyleAttributeName,
          nil];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  (void)typeName;
  NSAttributedString *storage = _textView ? (NSAttributedString *)[_textView textStorage] : _loadedString;
  NSRange range = NSMakeRange(0, [storage length]);
  NSDictionary *attributes = [NSDictionary dictionaryWithObject:WPDefaultDocumentType()
                                                        forKey:NSDocumentTypeDocumentAttribute];
  NSData *data = [storage RTFFromRange:range documentAttributes:attributes];

  if (!data && outError) {
    *outError = [NSError errorWithDomain:NSCocoaErrorDomain
                                    code:NSFileWriteUnknownError
                                userInfo:[NSDictionary dictionaryWithObject:@"The document could not be converted to RTF."
                                                                     forKey:NSLocalizedDescriptionKey]];
  }
  return data;
}

- (NSData *)dataRepresentationOfType:(NSString *)type
{
  NSError *error = nil;
  return [self dataOfType:type error:&error];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  (void)typeName;
  NSDictionary *attributes = nil;
  NSAttributedString *string = [[[NSAttributedString alloc] initWithRTF:data
                                                    documentAttributes:&attributes] autorelease];

  if (!string) {
    NSString *plain = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if (plain) {
      string = [[[NSAttributedString alloc] initWithString:plain
                                                attributes:[self defaultTypingAttributes]] autorelease];
    }
  }

  if (!string) {
    if (outError) {
      *outError = [NSError errorWithDomain:NSCocoaErrorDomain
                                      code:NSFileReadCorruptFileError
                                  userInfo:[NSDictionary dictionaryWithObject:@"The file is not valid RTF or UTF-8 text."
                                                                       forKey:NSLocalizedDescriptionKey]];
    }
    return NO;
  }

  [_loadedString release];
  _loadedString = [string copy];
  if (_textView) {
    _loadingContent = YES;
    [[_textView textStorage] setAttributedString:_loadedString];
    _loadingContent = NO;
  }
  return YES;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type
{
  NSError *error = nil;
  return [self readFromData:data ofType:type error:&error];
}

- (NSString *)displayName
{
  NSString *name = [super displayName];
  return name ? name : @"Untitled";
}

- (void)textDidChange:(NSNotification *)notification
{
  (void)notification;
  if (!_loadingContent) {
    [self updateChangeCount:NSChangeDone];
  }
}

- (NSPrintOperation *)printOperationWithSettings:(NSDictionary *)printSettings
                                           error:(NSError **)outError
{
  (void)outError;
  NSPrintInfo *printInfo = [[[self printInfo] copy] autorelease];
  if (printSettings) {
    [[printInfo dictionary] addEntriesFromDictionary:printSettings];
  }
  return [NSPrintOperation printOperationWithView:_textView printInfo:printInfo];
}

@end
