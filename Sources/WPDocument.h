#import <AppKit/AppKit.h>

@interface WPDocument : NSDocument <NSTextViewDelegate>
{
  NSWindowController *_windowController;
  NSTextView *_textView;
  NSScrollView *_scrollView;
  BOOL _loadingContent;
  NSAttributedString *_loadedString;
}
@end
