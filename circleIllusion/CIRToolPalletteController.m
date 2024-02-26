//
//  CIRToolPalletteController.m
//  circleIllusion
//
//  Created by David Phillip Oster on 2/22/24.
//

#import "CIRToolPalletteController.h"

#import "CIRItem.h"

NSString *const ItemChangedNotification = @"ItemChangedNotification";

@interface CIRToolPalletteController () <NSTableViewDataSource, NSTableViewDelegate>
@property IBOutlet NSTableView *tableView;
@end

static CIRToolPalletteController *sSharedToolPaletteController;

@implementation CIRToolPalletteController

+ (CIRToolPalletteController *)sharedToolPaletteController {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sSharedToolPaletteController = [[self alloc] initWithWindowNibName:@"ToolPallette"];
    [sSharedToolPaletteController setShouldCascadeWindows:NO];
    [sSharedToolPaletteController setWindowFrameAutosaveName:@"ToolPallette"];
  });
  return sSharedToolPaletteController;
}

- (NSResponder *)nextResponder {
  return [(id)NSApp.delegate window];
}

- (void)setModel:(NSArray<CIRItem *> *)model {
  _model = model;
  [self.tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return self.model.count;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)rowIndex {
  NSTableCellView *row = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
  row.textField.stringValue = self.model[rowIndex].name;
  return row;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
  [nc postNotificationName:ItemChangedNotification object:[self.model[self.tableView.selectedRow] copy]];
}

- (void)windowDidLoad {
  [super windowDidLoad];
}

- (void)toggleWindow {
  NSWindow *window = [self window];
  if ([window isVisible]) {
    [window orderOut:self];
  } else {
    [self showWindow:self];
  }
}

@end
