//
//  ShowTabViewController.swift
//  Orian
//
//  Created by Catalina19 on 10/02/21.
//

import UIKit
import WebKit


class ShowTabViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    //MARK:- Button Click Methods
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion:    nil)
    }
    
    
    @IBAction func addTabButton(_ sender: Any) {
        self.dismiss(animated: true, completion:    nil)
        NotificationCenter.default.post(name: Notification.Name("NewTab"), object: nil)
    }
    
    //MARK:- Tableview delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabDetails.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil);
        cell.textLabel?.text = tabDetails[indexPath.row]["title"]
        cell.detailTextLabel?.text = tabDetails[indexPath.row]["url"]
        if(selectedIndex == indexPath.row){
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.blue.cgColor
        }
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.dismiss(animated: true, completion:    nil)
        NotificationCenter.default.post(name: Notification.Name("SelectTab"), object: nil)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .destructive, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            NotificationCenter.default.post(name: Notification.Name("RemoveTab"), object: nil,userInfo: ["index":indexPath.row])
            tabDetails.remove(at: indexPath.row)
            if(indexPath.row == 0 && tabDetails.count == 0){
                selectedIndex = -1
                self.dismiss(animated: true, completion:    nil)
                NotificationCenter.default.post(name: Notification.Name("NewTab"), object: nil)
            }else if (selectedIndex == indexPath.row){
                if (indexPath.row == 0){
                   selectedIndex = indexPath.row
                }else{
                    selectedIndex = indexPath.row - 1
                }
                NotificationCenter.default.post(name: Notification.Name("SelectTab"), object: nil)

            }
            tableView.reloadData();
            
            })
           
            return UISwipeActionsConfiguration(actions: [modifyAction])
    }
   
    
}
