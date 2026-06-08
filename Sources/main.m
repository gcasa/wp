#import <AppKit/AppKit.h>
#import "WPAppDelegate.h"
#import "WPDocument.h"

int main(int argc, const char *argv[])
{
  (void)argc;
  (void)argv;
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSApplication *application = [NSApplication sharedApplication];
  WPAppDelegate *delegate = [[WPAppDelegate alloc] init];

  [NSDocumentController sharedDocumentController];
  [application setDelegate:delegate];
  [application run];

  [delegate release];
  [pool release];
  return 0;
}
