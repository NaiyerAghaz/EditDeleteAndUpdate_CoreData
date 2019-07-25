//
//  CoreDataTV.swift
//  TableCoreData
//
//  Created by Naiyer on 23/07/19.
//  Copyright © 2019 Naiyer. All rights reserved.
//

import UIKit
import CoreData

class CoreDataTV: UITableViewController {
    var userList  = [NSManagedObject]()
    var userId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getDataFromTable()
    }
    func getDataFromTable(){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let manageContainer = appdelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "TableData")
        do {
            userList = try manageContainer.fetch(fetchReq) as! [NSManagedObject]
            
//            if userList.count > 0 {
//
//            }
            tableView.reloadData()
            fetchMaxId()
        }
        catch {
            print(error)
        }
    }
    func fetchMaxId() {
        for items in userList {
            let id = items.value(forKey: "id") as? Int
            if (id! > userId) {
                userId = id!
            }
        }

    }
    
  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tblDataCell
        let user = userList[indexPath.row]
        let idss = user.value(forKey: "id") as? Int64
        print("idss=",idss!)
        cell.age.text = user.value(forKey: "userAge") as? String
        cell.name.text = user.value(forKey: "userName") as? String
        cell.describtion.text = user.value(forKey: "userDesignation") as? String
        cell.dob.text = user.value(forKey: "userDOB") as? String
        if let imgData = user.value(forKey: "userImg") as? NSData {
            let userImage = UIImage(data: imgData as Data)
        cell.img.image = userImage
        }
       return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
// Override to support editing the table view.
   /* override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            guard let appdelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
            }
            let manageContext = appdelegate.persistentContainer.viewContext
            manageContext.delete(userList[indexPath.row])
            do {
                try manageContext.save()
                getDataFromTable()
            }
            catch _{
                
            }
            // Delete the row from the data source
          //  tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }*/
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
         
                guard let appdelegate = UIApplication.shared.delegate as? AppDelegate
                    else {
                        return
                }
                let manageContext = appdelegate.persistentContainer.viewContext
          //  print("index11=",indexPath.row)
           // let dIndx = self.userList[indexPath.row].value(forKey: "id") as! Int
            //print("deleteIndx=", dIndx)
            manageContext.delete(self.userList[indexPath.row])
                do {
                    try manageContext.save()
                    self.getDataFromTable()
                }
                catch _{
                    
                }
                // Delete the row from the data source
           }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            let editVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let objList = self.userList[indexPath.row]
            editVC.updateImg = objList.value(forKey: "userImg") as? NSData
            editVC.updateAge = objList.value(forKey: "userAge") as! String
            editVC.updateId = objList.value(forKey: "id") as! Int
            editVC.updateName = objList.value(forKey: "userName") as! String
            editVC.updateDob = objList.value(forKey: "userDOB") as! String
            editVC.updateDesignation = objList.value(forKey: "userDesignation") as! String
            editVC.isUpdates = true
           // story.usersId = self.userId
            
            self.navigationController?.pushViewController(editVC, animated: true)
            
        }
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func btnAddTapped(_ sender: Any) {
         let story = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
         story.usersId = userId
         self.navigationController?.pushViewController(story, animated: true)
    }
    
}

class tblDataCell: UITableViewCell {
    
    @IBOutlet weak var describtion: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        
    }
   override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
struct Users {
    var id : Int?
    var name: String?
    var dob: String?
    
}
