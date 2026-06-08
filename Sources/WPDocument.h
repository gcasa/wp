#import <AppKit/AppKit.h>

@interface WPDocument : NSDocument <NSTextViewDelegate>
{
  NSWindowController *_windowController;
  NSTextView *_textView;
  NSScrollView *_scrollView;
  NSTextStorage *_textStorage;
  NSLayoutManager *_layoutManager;
  NSTextContainer *_textContainer;
  BOOL _loadingContent;
  NSAttributedString *_loadedString;
}
@end
