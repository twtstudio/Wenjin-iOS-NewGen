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
    
    let NavigationTitleColor: NSDictionary = [NSForegroundColorAttributeName: UIColor.black]
    let NavigationTitleColorNight: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
    let defaults = UserDefaults.standard
    
    func handleNavigationBar(_ VC: UITableViewController) {
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            VC.tableView.backgroundColor = TableViewBgColor
            VC.navigationController?.navigationBar.dk_barTintColorPicker = DKColorTable.shared().picker(withKey: "BAR")
            
            //VC.navigationController?.navigationBar.isTranslucent = true
            VC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
        } else {
            VC.tableView.backgroundColor = UIColor.white
            VC.navigationController?.navigationBar.backgroundColor = NavigationBgColor
            VC.navigationController?.navigationBar.barTintColor = NavigationBgColor
            VC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
        }
    }
    
    func handleTableView(_ TV:UITableView){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            TV.backgroundColor = TableViewBgColor
        } else {
            TV.backgroundColor = NavigationBgColor
        }
    }
    
    func handleHomeTableViewCell(_ cell: HomeTableViewCell) {
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            cell.actionLabel.textColor = UIColor.white
            cell.backgroundColor = UIColor.darkGray
            cell.detailLabel.textColor = UIColor.white
            cell.questionLabel.textColor = UIColor.white
        } else {
            cell.actionLabel.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
            cell.detailLabel.textColor = UIColor.black
            cell.questionLabel.textColor = UIColor.black
        }
    }
    
    func handleTabBar(_ TBC:UITabBarController){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            TBC.tabBar.backgroundColor = TableViewBgColor
            TBC.tabBar.backgroundImage = UIImage.init()
        } else {
            TBC.tabBar.backgroundColor = NavigationBgColor
            // color can't change back
        }
    }
    
    func handleSearchViewController(_ STVC:SearchViewController){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            STVC.view.backgroundColor = TableViewBgColor
            STVC.resultsTableView.backgroundColor = TableViewBgColor
            STVC.searchTextField.backgroundColor = UIColor.darkGray
            STVC.searchTextField.textColor = UIColor.white
            STVC.searchTextField.attributedPlaceholder = NSAttributedString(string:"搜索问题、话题或用户",attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
            STVC.searchTextField.keyboardAppearance = UIKeyboardAppearance.dark
        } else {
            STVC.view.backgroundColor = UIColor.white
            STVC.resultsTableView.backgroundColor = UIColor.white
            STVC.searchTextField.backgroundColor = searchTextFieldBgColor
            STVC.searchTextField.textColor = UIColor.black
            STVC.searchTextField.attributedPlaceholder = NSAttributedString(string:"搜索问题、话题或用户",attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
            STVC.searchTextField.keyboardAppearance = UIKeyboardAppearance.light
        }
    }
    
    
    func handleUserListTableViewCell(_ cell:UserListTableViewCell){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            cell.backgroundColor = UIColor.darkGray
            cell.userNameLabel.textColor = UIColor.white
            cell.userSigLabel.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.white
            cell.userNameLabel.textColor = UIColor.black
            cell.userSigLabel.textColor = UIColor.black
        }
    }
    
    func handleSearchQuestionTableViewCell(_ cell:SearchQuestionTableViewCell){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            cell.backgroundColor = UIColor.darkGray
            cell.titleLabel.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.white
            cell.titleLabel.textColor = UIColor.black
        }
    }
    
    func handleDetailViewController(_ DVC:DetailViewController){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            DVC.view.backgroundColor = UIColor.black
            DVC.answerContentView.scrollView.backgroundColor = TableViewBgColor
            DVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
        } else {
            DVC.view.backgroundColor = UIColor.white
            DVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
        }
    }
    
    func handleCommentViewController(_ CVC:CommentViewController){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            CVC.tableView!.backgroundColor = TableViewBgColor
            CVC.view.backgroundColor = TableViewBgColor
            CVC.textView.textColor = UIColor.white
            CVC.textView.keyboardAppearance = UIKeyboardAppearance.dark
            CVC.textInputbar.backgroundColor = TableViewBgColor
        } else {
            CVC.tableView?.backgroundColor = UIColor.white
            CVC.view.backgroundColor = UIColor.white
            CVC.textView.textColor = UIColor.black
            CVC.textView.keyboardAppearance = UIKeyboardAppearance.light
        }
        
    }
    
    func handleAnswerCommentTableViewCell(_ cell:AnswerCommentTableViewCell){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            cell.backgroundColor = UIColor.darkGray
            cell.commentLabel.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.white
            cell.commentLabel.textColor = UIColor.black
        }
        
    }
    
    func handleQuestionViewController(_ QVC:QuestionViewController){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            QVC.questionTableView.backgroundColor = TableViewBgColor
        } else {
            QVC.questionTableView.backgroundColor = UIColor.white
        }
    }
    
    func handleQuestionHeaderView(_ QHV:QuestionHeaderView){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            QHV.backgroundColor = TableViewBgColor
        } else {
            QHV.backgroundColor = UIColor.white
        }
    }
    
    func handleQuestionAnswerTableViewCell(_ cell:QuestionAnswerTableViewCell){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            cell.answerContentLabel.textColor = UIColor.white
            cell.backgroundColor = UIColor.darkGray
        } else {
            cell.backgroundColor = UIColor.white
            cell.answerContentLabel.textColor = UIColor.black
        }
    }
    
    func handleTopicViewController(_ TVC:TopicViewController){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            TVC.bestAnswerTableView.backgroundColor = TableViewBgColor
            TVC.topicHeaderView.backgroundColor = TableViewBgColor
            TVC.topicTitle.textColor = UIColor.white
            TVC.topicDescription.textColor = UIColor.white
        } else {
            TVC.bestAnswerTableView.backgroundColor = UIColor.white
            TVC.topicHeaderView.backgroundColor = UIColor.white
            TVC.topicTitle.textColor = UIColor.black
            TVC.topicDescription.textColor = UIColor.black
        }
    }
    
    func handleUserViewControllerCell(_ cell:UITableViewCell){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.darkGray
        } else {
            cell.textLabel?.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
        }
    }
    
    func handleFatherTabBarController(_ TBC:UITabBarController){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            TBC.tabBar.backgroundColor = TableViewBgColor
            TBC.tabBar.backgroundImage = UIImage.init()
        } else {
            TBC.tabBar.backgroundColor = UIColor.clear
            TBC.tabBar.backgroundImage = nil
        }
    }
    
    func handleChangeThemeSwitchClicked(_ sender:UISwitch, STVC:UITableViewController){
        if (sender.isOn){
            STVC.tableView.backgroundColor = TableViewBgColor
            STVC.navigationController?.navigationBar.dk_barTintColorPicker = DKColorTable.shared().picker(withKey: "BAR")
            STVC.dk_manager.nightFalling()
            STVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
            defaults.set("night", forKey: "Theme")
            STVC.tableView.reloadData()
        } else {
            STVC.tableView.backgroundColor = NavigationBgColor
            STVC.dk_manager.dawnComing()
            STVC.navigationController?.navigationBar.backgroundColor = UIColor.white
            STVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
            defaults.set("dawn", forKey: "Theme")
            STVC.tableView.reloadData()
        }
    }
    
    func handlePostQuestionViewController(_ PQVC:PostQuestionViewController,questionTagsController:TLTagsControl,accessoryToolbar:UIToolbar,isAnonymousControl:NYSegmentedControl){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            PQVC.view.backgroundColor = TableViewBgColor
            PQVC.questionView.backgroundColor = TableViewBgColor
            PQVC.questionView.textColor = UIColor.white
            questionTagsController.backgroundColor = UIColor.darkGray
            PQVC.navigationController?.navigationBar.dk_barTintColorPicker = DKColorTable.shared().picker(withKey: "BAR")
            PQVC.navigationController?.navigationBar.isTranslucent = false
            PQVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
            PQVC.questionView.keyboardAppearance = UIKeyboardAppearance.dark
            accessoryToolbar.barTintColor = UIColor.black
            isAnonymousControl.backgroundColor = TableViewBgColor
            isAnonymousControl.segmentIndicatorBackgroundColor = UIColor.darkGray
        } else {
            PQVC.view.backgroundColor = UIColor.white
            PQVC.questionView.backgroundColor = UIColor.white
            PQVC.questionView.textColor = UIColor.black
            questionTagsController.backgroundColor = UIColor.white
            PQVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
            PQVC.questionView.keyboardAppearance = UIKeyboardAppearance.light
            accessoryToolbar.barTintColor = NavigationBgColor
            isAnonymousControl.backgroundColor = UIColor(white: 0.9, alpha:1.0)
            isAnonymousControl.segmentIndicatorBackgroundColor = UIColor.white
        }
    }
    
    func handlePQVCkeyboard(_ PQVC:PostQuestionViewController,keyboardHeight:CGFloat,tagControlHeight:CGFloat,questionTagsControl:TLTagsControl){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            PQVC.questionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - keyboardHeight - tagControlHeight - 4 - 64)
            questionTagsControl.frame = CGRect(x: 8, y: PQVC.questionView.frame.size.height, width: PQVC.view.frame.size.width - 16, height: tagControlHeight)
        } else {
            PQVC.questionView.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - keyboardHeight - tagControlHeight - 4 - 64)
            questionTagsControl.frame = CGRect(x: 8, y: PQVC.questionView.frame.size.height + 64, width: PQVC.view.frame.size.width - 16, height: tagControlHeight)
        }
    }
    
    func handleAddDetailViewController(_ ADVC:AddDetailViewController,accessoryToolbar:UIToolbar){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            ADVC.detailTextView.backgroundColor = TableViewBgColor
            ADVC.detailTextView.textColor = UIColor.white
            ADVC.view.backgroundColor = TableViewBgColor
            ADVC.navigationController?.navigationBar.dk_barTintColorPicker = DKColorTable.shared().picker(withKey: "BAR")
            ADVC.navigationController?.navigationBar.isTranslucent = false
            ADVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
            ADVC.detailTextView.keyboardAppearance = UIKeyboardAppearance.dark
            accessoryToolbar.barTintColor = TableViewBgColor
        } else {
            ADVC.detailTextView.backgroundColor = UIColor.white
            ADVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
            ADVC.detailTextView.keyboardAppearance = UIKeyboardAppearance.light
            ADVC.detailTextView.textColor = UIColor.black
            ADVC.view.backgroundColor = UIColor.white
            accessoryToolbar.barTintColor = NavigationBgColor
        }
    }
    
    func handleADVCkeyboard(_ ADVC:AddDetailViewController,keyboardHeight:CGFloat){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            ADVC.detailTextView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - keyboardHeight - 64)
        } else {
            ADVC.detailTextView.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - keyboardHeight - 64)
        }
    }
    
    func handlePostAnswerViewController(_ PAVC:PostAnswerViewController,accessoryToolbar:UIToolbar,isAnonymousControl:NYSegmentedControl){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            PAVC.view.backgroundColor = TableViewBgColor
            PAVC.answerView.backgroundColor = TableViewBgColor
            PAVC.answerView.textColor = UIColor.white
            PAVC.navigationController?.navigationBar.dk_barTintColorPicker = DKColorTable.shared().picker(withKey: "BAR")
            PAVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
            PAVC.answerView.keyboardAppearance = UIKeyboardAppearance.dark
            accessoryToolbar.barTintColor = UIColor.black
            isAnonymousControl.backgroundColor = TableViewBgColor
            isAnonymousControl.segmentIndicatorBackgroundColor = UIColor.darkGray
        } else {
            PAVC.view.backgroundColor = UIColor.white
            PAVC.answerView.backgroundColor = UIColor.white
            PAVC.answerView.textColor = UIColor.black
            PAVC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
            PAVC.answerView.keyboardAppearance = UIKeyboardAppearance.light
            accessoryToolbar.barTintColor = NavigationBgColor
            isAnonymousControl.backgroundColor = UIColor(white: 0.9, alpha:1.0)
            isAnonymousControl.segmentIndicatorBackgroundColor = UIColor.white
        }
    }
    
    func handleHTMLWithTimeWithContent(_ content:NSString, timeStamp:NSInteger) -> NSString{
        var ProcessedHTML:String
        
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            ProcessedHTML = wjStringProcessor.convertToBootstrapHTMLWithTime(withContentDark: content as String, andTimeStamp: timeStamp)
        } else {
            ProcessedHTML = wjStringProcessor.convertToBootstrapHTMLWithTime(withContent: content as String, andTimeStamp: timeStamp)
        }
        return ProcessedHTML as NSString
    }
    
    
    func handleHTMLWithExtraBlankLinesWithContent(_ content:NSString) -> String {
        var ProcessedHTML: String
        
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            ProcessedHTML = wjStringProcessor.convertToBootstrapHTMLWithExtraBlankLines(withContentDark: content as String)
        } else {
            ProcessedHTML = wjStringProcessor.convertToBootstrapHTMLWithExtraBlankLines(withContent: content as String)
        }
        return ProcessedHTML as String
        
    }
    
    func handleQuestionHeaderView(_ headerView:QuestionHeaderView, questionInfo:QuestionInfo){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            headerView.detailView.loadHTMLString(wjStringProcessor.convertToBootstrapHTML(withContentDark: questionInfo.questionDetail), baseURL: URL(fileURLWithPath: Bundle.main.resourcePath!, isDirectory: true))
            headerView.detailView.backgroundColor = UIColor.black
        } else {
            headerView.detailView.loadHTMLString(wjStringProcessor.convertToBootstrapHTML(withContent: questionInfo.questionDetail), baseURL: URL(fileURLWithPath: Bundle.main.resourcePath!, isDirectory: true))
            headerView.detailView.backgroundColor = UIColor.white
        }
    }
    
    func handleQuestionHeaderViewTitle(_ headerView:QuestionHeaderView){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            headerView.questionTitle.textColor = UIColor.white
        } else {
            headerView.questionTitle.textColor = UIColor.black
        }
    }
    
    func handleUserInfoView(_ DVC:DetailViewController){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            DVC.userInfoView.backgroundColor = UIColor.black
            DVC.userSigLabel.textColor = UIColor.white
            DVC.toolBar.barTintColor = TableViewBgColor
            DVC.answerContentView.backgroundColor = UIColor.black
        } else {
            DVC.userInfoView.backgroundColor = UIColor.white
            DVC.userSigLabel.textColor = UIColor.black
            DVC.toolBar.barTintColor = UIColor.white
        }
    }
    
    func handleCommentTextView(_ CTV:CommentTextView){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            CTV.placeholderColor = UIColor.lightGray
            CTV.backgroundColor = UIColor.darkGray
        } else {
            CTV.backgroundColor = UIColor.white
            CTV.placeholderColor = UIColor.lightGray
        }
    }
    
    func handletagInputField(_ tagInputField_:UITextField){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            tagInputField_.backgroundColor = UIColor.darkGray
            tagInputField_.textColor = UIColor.white
            tagInputField_.keyboardAppearance = UIKeyboardAppearance.dark
            print("reached here!!!!")
        } else {
            tagInputField_.backgroundColor = UIColor.white
            tagInputField_.textColor = UIColor.black
            tagInputField_.keyboardAppearance = UIKeyboardAppearance.light
        }
    }
    
    func handleUserHeaderView(_ UHV:UserHeaderView){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            UHV.usernameLabel.textColor = UIColor.white
            UHV.userSigLabel.textColor = UIColor.white
            UHV.backgroundColor = UIColor.clear
        } else {
            UHV.userSigLabel.textColor = UIColor.black
            UHV.usernameLabel.textColor = UIColor.black
        }
    }
    
    func handleAboutViewController(_ AVC:AboutViewController){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            AVC.view.backgroundColor = TableViewBgColor
        } else {
            AVC.view.backgroundColor = UIColor.white
        }
    }
    
    func handleDisappearNavBar(_ VC:UIViewController){
        if (defaults.object(forKey: "Theme")! as AnyObject).isEqual(to: "night") {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            VC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColorNight as? [String : AnyObject]
        } else {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            VC.navigationController?.navigationBar.titleTextAttributes = NavigationTitleColor as? [String : AnyObject]
        }
    }
    
}

