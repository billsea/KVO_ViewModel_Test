//
//  InputTableViewController.m
//  KVO_ViewModel_Test
//
//  Created by Loud on 3/27/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "InputTableViewController.h"
#import "TextInputTableViewCell.h"
#import "Item.h"

@interface InputTableViewController (){
	NSMutableArray* _itemArray;
}

@end

@implementation InputTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Data items
	Item* item1 = [[Item alloc] init];
	item1.itemName = @"first item";
	item1.itemId = @"01";
	Item* item2 = [[Item alloc] init];
	item2.itemName = @"second item";
	item2.itemId = @"02";
	
	_itemArray = [[NSMutableArray alloc] init];
	[_itemArray addObject:item1];
	[_itemArray addObject:item2];
}

- (void)viewWillDisappear:(BOOL)animated
{
	//Remove observers final
	for (TextInputTableViewCell *cell in self.tableView.visibleCells) {
		// note! didEndDisplayingCell: isn't sent when the entire controller is going away!
		[self removeObservers:cell];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"TextInputTableViewCell";
	TextInputTableViewCell *cell = (TextInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	Item* item = (Item*)[_itemArray objectAtIndex:indexPath.row];
	cell.labelCell.text = item.itemName;
	cell.textInput.text = item.itemId;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(TextInputTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Add observers to each cell(to recognize changes to the cell.textInput.text property)
	[cell.textInput addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Remove observers!
	[self removeObservers:cell];
}

- (void)removeObservers:(UITableViewCell*)cell{
	TextInputTableViewCell *cCell = (TextInputTableViewCell *)cell;
	[cCell.textInput removeObserver:self forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	
	NSString *message = [(NSString *)object valueForKey:@"text"];
	NSLog(@"The message was %@", message);
	
	// if implemented in the parent class, it can't hurt to call this:
	// WILL CAUSE A CRASH IF NOT IMPLEMENTED IN PARENT CLASS
	// [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


@end
