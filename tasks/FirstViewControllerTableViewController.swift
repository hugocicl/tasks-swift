//
//  FirstViewControllerTableViewController.swift
//  tasks
//
//  Created by Francisco Pronto on 08/09/2018.
//  Copyright © 2018 Francisco Pronto. All rights reserved.
//

import UIKit

class FirstViewControllerTableViewController: UITableViewController{

    @IBOutlet weak var myTableView: UITableView!
    
    var auxList = ["test1","test2"]
    var taskList:NSMutableArray = NSMutableArray()
    
    override func viewDidAppear(_ animated: Bool) {
        print("apareceu")
        let userDefaults:UserDefaults = UserDefaults.standard
        UserDefaults.standard.synchronize()
        let itemListFromUD: NSMutableArray? = userDefaults.object(forKey: "itemList") as? NSMutableArray
        print(itemListFromUD)
        if (itemListFromUD != nil){
            print("entrou")
            taskList=itemListFromUD!
        }
        self.myTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (taskList.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"Cell")
        let taskItem:NSDictionary = taskList.object(at: indexPath.row) as! NSDictionary
        
        cell?.textLabel?.text=taskItem.object(forKey: "itemTitle") as! String

        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let userDefaults:UserDefaults = UserDefaults.standard
            
            let itemListArray:NSMutableArray? = userDefaults.object(forKey: "itemList") as? NSMutableArray
            if(itemListArray != nil){
                
            
            let mutableItemList: NSMutableArray = NSMutableArray()
            for dict:Any in itemListArray!{
                mutableItemList.add(dict as! NSDictionary)
            }
            mutableItemList.remove(taskList.object(at: indexPath.row))
            
            userDefaults.removeObject(forKey: "itemList")
            userDefaults.set(mutableItemList, forKey:"itemList")
            userDefaults.synchronize()
            
            taskList=mutableItemList
            
            self.myTableView.reloadData()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.myTableView.deselectRow(at: indexPath, animated: false)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue != nil && segue.identifier == "showEdit"){
            let selectedIndexPath:NSIndexPath = self.myTableView.indexPathForSelectedRow! as NSIndexPath
            let editViewController:editViewController = segue.destination as! editViewController
            editViewController.taskData = taskList.object(at: selectedIndexPath.row) as! NSDictionary
            editViewController.idTask = selectedIndexPath.row
        }
    }
    

}
