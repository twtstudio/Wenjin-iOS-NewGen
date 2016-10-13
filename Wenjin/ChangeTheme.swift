//
//  ChangeTheme.swift
//  Wenjin
//
//  Created by Kyrie Wei on 9/17/16.
//  Copyright © 2016 TWT Studio. All rights reserved.
//

import Foundation
import UIKit


@objc class ThemeChangeManager: UIViewController {
    
    let TableViewBgColor = UIColor(red: CGFloat(52/255.0), green: CGFloat(52/255.0), blue: CGFloat(52/255.0), alpha: CGFloat(1.0))
    let NavigationBgColor = UIColor(red: CGFloat(244/255.0), green: CGFloat(244/255.0), blue: CGFloat(244/255.0), alpha: CGFloat(1.0))
    let NavigationBgColorNight = UIColor(red: CGFloat(79/255.0), green: CGFloat(79/255.0), blue: CGFloat(79/255.0), alpha: CGFloat(1.0))
    let searchTextFieldBgColor = UIColor(red: CGFloat(238/255.0), green: CGFloat(238/255.0), blue: CGFloat(238/255.0), alpha: CGFloat(1.0))
    
    let NavigationTitleColor: NSDictionary = [NSForegroundColorAttributeName: UIColor.blackColor()]
    let NavigationTitleColorNight: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func handleNavigationBar(VC: UITableViewController) {
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            VC.tableView.backgroundColor = TableViewBgColor
            VC.navigationController?.navigationBar.dk_barTintColorPicker = DKColorTable.sharedColorTable().pickerWithKey("BAR")
            
            //VC.navigationController?.navigationBar.translucent = true
            VC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
        }
        else
        {
            VC.tableView.backgroundColor = UIColor.whiteColor()
            VC.navigationController?.navigationBar.backgroundColor = NavigationBgColor
            VC.navigationController?.navigationBar.barTintColor = NavigationBgColor
            VC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
        }
    }
    
    func handleTableView(TV:UITableView){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            TV.backgroundColor = TableViewBgColor
        }
        else{
            TV.backgroundColor = NavigationBgColor
        }
    }
    
    func handleHomeTableViewCell(cell: HomeTableViewCell) {
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            cell.actionLabel.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor.darkGrayColor()
            cell.detailLabel.textColor = UIColor.whiteColor()
            cell.questionLabel.textColor = UIColor.whiteColor()
        }
        else{
            cell.actionLabel.textColor = UIColor.blackColor()
            cell.backgroundColor = UIColor.whiteColor()
            cell.detailLabel.textColor = UIColor.blackColor()
            cell.questionLabel.textColor = UIColor.blackColor()
        }
    }
    
    func handleTabBar(TBC:UITabBarController){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            TBC.tabBar.backgroundColor = TableViewBgColor
            TBC.tabBar.backgroundImage = UIImage.init()
        }
        else
        {
            TBC.tabBar.backgroundColor = NavigationBgColor
            // color can't change back
        }
    }
    
    func handleSearchViewController(STVC:SearchViewController){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            STVC.view.backgroundColor = TableViewBgColor
            STVC.resultsTableView.backgroundColor = TableViewBgColor
            STVC.searchTextField.backgroundColor = UIColor.darkGrayColor()
            STVC.searchTextField.textColor = UIColor.whiteColor()
            STVC.searchTextField.attributedPlaceholder = NSAttributedString(string:"搜索问题、话题或用户",attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
            STVC.searchTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        }
        else{
            STVC.view.backgroundColor = UIColor.whiteColor()
            STVC.resultsTableView.backgroundColor = UIColor.whiteColor()
            STVC.searchTextField.backgroundColor = searchTextFieldBgColor
            STVC.searchTextField.textColor = UIColor.blackColor()
            STVC.searchTextField.attributedPlaceholder = NSAttributedString(string:"搜索问题、话题或用户",attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
            STVC.searchTextField.keyboardAppearance = UIKeyboardAppearance.Light
        }
    }
    
    
    func handleUserListTableViewCell(cell:UserListTableViewCell){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            cell.backgroundColor = UIColor.darkGrayColor()
            cell.userNameLabel.textColor = UIColor.whiteColor()
            cell.userSigLabel.textColor = UIColor.whiteColor()
        }
        else{
            cell.backgroundColor = UIColor.whiteColor()
            cell.userNameLabel.textColor = UIColor.blackColor()
            cell.userSigLabel.textColor = UIColor.blackColor()
        }
    }
    
    func handleSearchQuestionTableViewCell(cell:SearchQuestionTableViewCell){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            cell.backgroundColor = UIColor.darkGrayColor()
            cell.titleLabel.textColor = UIColor.whiteColor()
        }
        else{
            cell.backgroundColor = UIColor.whiteColor()
            cell.titleLabel.textColor = UIColor.blackColor()
        }
    }
    
    func handleDetailViewController(DVC:DetailViewController){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            DVC.view.backgroundColor = UIColor.blackColor()
            DVC.answerContentView.scrollView.backgroundColor = TableViewBgColor
            DVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
        }
        else{
            DVC.view.backgroundColor = UIColor.whiteColor()
            DVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
        }
    }
    
    func handleCommentViewController(CVC:CommentViewController){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            CVC.tableView!.backgroundColor = TableViewBgColor
            CVC.view.backgroundColor = TableViewBgColor
            CVC.textView.textColor = UIColor.whiteColor()
            CVC.textView.keyboardAppearance = UIKeyboardAppearance.Dark
        }
        else{
            CVC.tableView?.backgroundColor = UIColor.whiteColor()
            CVC.view.backgroundColor = UIColor.whiteColor()
            CVC.textView.textColor = UIColor.blackColor()
            CVC.textView.keyboardAppearance = UIKeyboardAppearance.Light
        }
        
    }
    
    func handleAnswerCommentTableViewCell(cell:AnswerCommentTableViewCell){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            cell.backgroundColor = UIColor.darkGrayColor()
            cell.commentLabel.textColor = UIColor.whiteColor()
        }
        else{
            cell.backgroundColor = UIColor.whiteColor()
            cell.commentLabel.textColor = UIColor.blackColor()
        }
        
    }
    
    func handleQuestionViewController(QVC:QuestionViewController){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            QVC.questionTableView.backgroundColor = TableViewBgColor
        }
        else{
            QVC.questionTableView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func handleQuestionHeaderView(QHV:QuestionHeaderView){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            QHV.backgroundColor = TableViewBgColor
        }
        else{
            QHV.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func handleQuestionAnswerTableViewCell(cell:QuestionAnswerTableViewCell){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            cell.answerContentLabel.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor.darkGrayColor()
        }
        else{
            cell.backgroundColor = UIColor.whiteColor()
            cell.answerContentLabel.textColor = UIColor.blackColor()
        }
    }
    
    func handleTopicViewController(TVC:TopicViewController){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            TVC.bestAnswerTableView.backgroundColor = TableViewBgColor
            TVC.topicHeaderView.backgroundColor = TableViewBgColor
            TVC.topicTitle.textColor = UIColor.whiteColor()
            TVC.topicDescription.textColor = UIColor.whiteColor()
        }
        else{
            TVC.bestAnswerTableView.backgroundColor = UIColor.whiteColor()
            TVC.topicHeaderView.backgroundColor = UIColor.whiteColor()
            TVC.topicTitle.textColor = UIColor.blackColor()
            TVC.topicDescription.textColor = UIColor.blackColor()
        }
    }
    
    func handleUserViewControllerCell(cell:UITableViewCell){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor.darkGrayColor()
        }
        else{
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func handleFatherTabBarController(TBC:UITabBarController){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            TBC.tabBar.backgroundColor = TableViewBgColor
            TBC.tabBar.backgroundImage = UIImage.init()
        }
        else{
            TBC.tabBar.backgroundColor = UIColor.clearColor()
            TBC.tabBar.backgroundImage = nil
        }
    }
    
    func handleChangeThemeSwitchClicked(sender:UISwitch, STVC:UITableViewController){
        if (sender.on){
            STVC.tableView.backgroundColor = TableViewBgColor
            STVC.navigationController?.navigationBar.dk_barTintColorPicker = DKColorTable.sharedColorTable().pickerWithKey("BAR")
            STVC.dk_manager.nightFalling()
            STVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
            defaults.setObject("night", forKey: "Theme")
            STVC.tableView.reloadData()
        }
        else
        {
            STVC.tableView.backgroundColor = NavigationBgColor
            STVC.dk_manager.dawnComing()
            STVC.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
            STVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
            defaults.setObject("dawn", forKey: "Theme")
            STVC.tableView.reloadData()
        }
    }
    
    func handlePostQuestionViewController(PQVC:PostQuestionViewController,questionTagsController:TLTagsControl,accessoryToolbar:UIToolbar,isAnonymousControl:NYSegmentedControl){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            PQVC.view.backgroundColor = TableViewBgColor
            PQVC.questionView.backgroundColor = TableViewBgColor
            PQVC.questionView.textColor = UIColor.whiteColor()
            questionTagsController.backgroundColor = UIColor.darkGrayColor()
            PQVC.navigationController?.navigationBar.dk_barTintColorPicker = DKColorTable.sharedColorTable().pickerWithKey("BAR")
            PQVC.navigationController?.navigationBar.translucent = false
            PQVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
            PQVC.questionView.keyboardAppearance = UIKeyboardAppearance.Dark
            accessoryToolbar.barTintColor = UIColor.blackColor()
            isAnonymousControl.backgroundColor = TableViewBgColor
            isAnonymousControl.segmentIndicatorBackgroundColor = UIColor.darkGrayColor()
        }
        else{
            PQVC.view.backgroundColor = UIColor.whiteColor()
            PQVC.questionView.backgroundColor = UIColor.whiteColor()
            PQVC.questionView.textColor = UIColor.blackColor()
            questionTagsController.backgroundColor = UIColor.whiteColor()
            PQVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
            PQVC.questionView.keyboardAppearance = UIKeyboardAppearance.Light
            accessoryToolbar.barTintColor = NavigationBgColor
            isAnonymousControl.backgroundColor = UIColor(white: 0.9, alpha:1.0)
            isAnonymousControl.segmentIndicatorBackgroundColor = UIColor.whiteColor()
        }
    }
    
    func handlePQVCkeyboard(PQVC:PostQuestionViewController,keyboardHeight:CGFloat,tagControlHeight:CGFloat,questionTagsControl:TLTagsControl){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            PQVC.questionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight - tagControlHeight - 4 - 64)
            questionTagsControl.frame = CGRectMake(8, PQVC.questionView.frame.size.height, PQVC.view.frame.size.width - 16, tagControlHeight)
        }
        else{
            PQVC.questionView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight - tagControlHeight - 4 - 64)
            questionTagsControl.frame = CGRectMake(8, PQVC.questionView.frame.size.height + 64, PQVC.view.frame.size.width - 16, tagControlHeight)
        }
    }
    
    func handleAddDetailViewController(ADVC:AddDetailViewController,accessoryToolbar:UIToolbar){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            ADVC.detailTextView.backgroundColor = TableViewBgColor
            ADVC.detailTextView.textColor = UIColor.whiteColor()
            ADVC.view.backgroundColor = TableViewBgColor
            ADVC.navigationController?.navigationBar.dk_barTintColorPicker = DKColorTable.sharedColorTable().pickerWithKey("BAR")
            ADVC.navigationController?.navigationBar.translucent = false
            ADVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
            ADVC.detailTextView.keyboardAppearance = UIKeyboardAppearance.Dark
            accessoryToolbar.barTintColor = TableViewBgColor
        }
        else{
            ADVC.detailTextView.backgroundColor = UIColor.whiteColor()
            ADVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
            ADVC.detailTextView.keyboardAppearance = UIKeyboardAppearance.Light
            ADVC.detailTextView.textColor = UIColor.blackColor()
            ADVC.view.backgroundColor = UIColor.whiteColor()
            accessoryToolbar.barTintColor = NavigationBgColor
        }
    }
    
    func handleADVCkeyboard(ADVC:AddDetailViewController,keyboardHeight:CGFloat){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            ADVC.detailTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight - 64)
        }
        else{
            ADVC.detailTextView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - keyboardHeight - 64)
        }
    }
    
    func handlePostAnswerViewController(PAVC:PostAnswerViewController,accessoryToolbar:UIToolbar,isAnonymousControl:NYSegmentedControl){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            PAVC.view.backgroundColor = TableViewBgColor
            PAVC.answerView.backgroundColor = TableViewBgColor
            PAVC.answerView.textColor = UIColor.whiteColor()
            PAVC.navigationController?.navigationBar.dk_barTintColorPicker = DKColorTable.sharedColorTable().pickerWithKey("BAR")
            PAVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
            PAVC.answerView.keyboardAppearance = UIKeyboardAppearance.Dark
            accessoryToolbar.barTintColor = UIColor.blackColor()
            isAnonymousControl.backgroundColor = TableViewBgColor
            isAnonymousControl.segmentIndicatorBackgroundColor = UIColor.darkGrayColor()
        }
        else{
            PAVC.view.backgroundColor = UIColor.whiteColor()
            PAVC.answerView.backgroundColor = UIColor.whiteColor()
            PAVC.answerView.textColor = UIColor.blackColor()
            PAVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
            PAVC.answerView.keyboardAppearance = UIKeyboardAppearance.Light
            accessoryToolbar.barTintColor = NavigationBgColor
            isAnonymousControl.backgroundColor = UIColor(white: 0.9, alpha:1.0)
            isAnonymousControl.segmentIndicatorBackgroundColor = UIColor.whiteColor()
        }
    }
    
    func handleHTMLWithTimeWithContent(content:NSString, timeStamp:NSInteger) -> NSString{
        var ProcessedHTML:String
        
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            ProcessedHTML = wjStringProcessor.convertToBootstrapHTMLWithTimeWithContentDark(content as String, andTimeStamp: timeStamp)
        }
        else
        {
            ProcessedHTML = wjStringProcessor.convertToBootstrapHTMLWithTimeWithContent(content as String, andTimeStamp: timeStamp)
        }
        return ProcessedHTML
    }
    
    
    func handleHTMLWithExtraBlankLinesWithContent(content:NSString) -> String {
        var ProcessedHTML: String
        
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            ProcessedHTML = wjStringProcessor.convertToBootstrapHTMLWithExtraBlankLinesWithContentDark(content as String)
        }
        else
        {
            ProcessedHTML = wjStringProcessor.convertToBootstrapHTMLWithExtraBlankLinesWithContent(content as String)
        }
        return ProcessedHTML as String
        
    }
    
    func handleQuestionHeaderView(headerView:QuestionHeaderView, questionInfo:QuestionInfo){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            headerView.detailView.loadHTMLString(wjStringProcessor.convertToBootstrapHTMLWithContentDark(questionInfo.questionDetail), baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!, isDirectory: true))
            headerView.detailView.backgroundColor = UIColor.blackColor()
        }
        else{
            headerView.detailView.loadHTMLString(wjStringProcessor.convertToBootstrapHTMLWithContent(questionInfo.questionDetail), baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle().resourcePath!, isDirectory: true))
            headerView.detailView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func handleQuestionHeaderViewTitle(headerView:QuestionHeaderView){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            headerView.questionTitle.textColor = UIColor.whiteColor()
        }
        else{
            headerView.questionTitle.textColor = UIColor.blackColor()
        }
    }
    
    func handleUserInfoView(DVC:DetailViewController){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            DVC.userInfoView.backgroundColor = UIColor.blackColor()
            DVC.userSigLabel.textColor = UIColor.whiteColor()
            DVC.toolBar.barTintColor = TableViewBgColor
            DVC.answerContentView.backgroundColor = UIColor.blackColor()
        }
        else{
            DVC.userInfoView.backgroundColor = UIColor.whiteColor()
            DVC.userSigLabel.textColor = UIColor.blackColor()
            DVC.toolBar.barTintColor = UIColor.whiteColor()
        }
    }
    
    func handleCommentTextView(CTV:CommentTextView){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            CTV.placeholderColor = UIColor.lightGrayColor()
            CTV.backgroundColor = UIColor.darkGrayColor()
        }
        else{
            CTV.backgroundColor = UIColor.whiteColor()
            CTV.placeholderColor = UIColor.lightGrayColor()
        }
    }
    
    func handletagInputField(tagInputField_:UITextField){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            tagInputField_.backgroundColor = UIColor.darkGrayColor()
            tagInputField_.textColor = UIColor.whiteColor()
            tagInputField_.keyboardAppearance = UIKeyboardAppearance.Dark
            print("reached here!!!!")
        }
        else{
            tagInputField_.backgroundColor = UIColor.whiteColor()
            tagInputField_.textColor = UIColor.blackColor()
            tagInputField_.keyboardAppearance = UIKeyboardAppearance.Light
        }
    }
    
    func handleUserHeaderView(UHV:UserHeaderView){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            UHV.usernameLabel.textColor = UIColor.whiteColor()
            UHV.userSigLabel.textColor = UIColor.whiteColor()
            UHV.backgroundColor = UIColor.clearColor()
        }
        else{
            UHV.userSigLabel.textColor = UIColor.blackColor()
            UHV.usernameLabel.textColor = UIColor.blackColor()
        }
    }
    
    func handleAboutViewController(AVC:AboutViewController){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            AVC.view.backgroundColor = TableViewBgColor
        }
        else{
            AVC.view.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func handleDisappearNavBar(VC:UIViewController){
        if((defaults.objectForKey("Theme") )! .isEqualToString("night")){
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
            VC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
        }
        else{
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
            VC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
        }
    }
    
}

