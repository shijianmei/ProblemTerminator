class AWUserHomePageController : AWViewController{

-(void )bindEvent{
    id weakSelf = self;
    self.naviBar.backBlock = ^void {
        ids strongSelf = weakSelf;
        self.backAction();
    };
    self.naviBar.rightClickBlock = ^void {
        ids strongSelf = weakSelf;
        self.naviRightAction();
    };
    NSLog(@"mango new ——");

}
}
