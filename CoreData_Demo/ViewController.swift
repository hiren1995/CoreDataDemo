//
//  ViewController.swift
//  CoreData_Demo
//
//  Created by LogicalWings Mac on 23/10/18.
//  Copyright © 2018 LogicalWings Mac. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var usersTableView: UITableView!
    
    var usersArray = [UserData]()
    
    var appdelegate : AppDelegate? = nil
    var context : NSManagedObjectContext? = nil
    
    var editFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Core Data Demo"
        
        usersTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userTableViewCell")
        
        appdelegate = UIApplication.shared.delegate as? AppDelegate
        context = appdelegate?.persistentContainer.viewContext
        
        loadData()
    }
    
    func loadData(){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.returnsObjectsAsFaults = false //why using this
        
        do {
            
            let result = try context?.fetch(request)
            for data in result as! [UserData]{
                usersArray.append(data)
            }
        }catch(let error){
            print(error)
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
        if !editFlag{
            
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: context!)
            let newuser = NSManagedObject(entity: entity!, insertInto: context)
            
            newuser.setValue(txtUserName.text!, forKey: "username")
            newuser.setValue(txtPassword.text, forKey: "password")
            newuser.setValue(txtAge.text!, forKey: "age")
            
            do{
                try context?.save()
                usersArray = []
                loadData()
                usersTableView.reloadData()
                
                txtUserName.text = nil
                txtPassword.text = nil
                txtAge.text = nil
                txtUserName.becomeFirstResponder()
                
            }catch(let error){
                print(error)
            }
            
        }else{
            
            let updateRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            updateRequest.predicate = NSPredicate(format: "password = %@", "\(txtPassword.text!)")
            
            do{
                
                let updateResult = try context?.fetch(updateRequest)
                
                let updateObj = updateResult![0] as! NSManagedObject
                
                updateObj.setValue(txtUserName.text!, forKey: "username")
                updateObj.setValue(txtPassword.text!, forKey: "password")
                updateObj.setValue(txtAge.text!, forKey: "age")
                
                do{
                    try context?.save()
                    usersArray = []
                    loadData()
                    usersTableView.reloadData()
                    
                    txtUserName.text = nil
                    txtPassword.text = nil
                    txtAge.text = nil
                    txtUserName.becomeFirstResponder()
                    
                    txtPassword.isUserInteractionEnabled = true
                    editFlag = false
                }catch(let error){
                    print(error)
                }
            }catch(let error){
                print(error)
            }
        }
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "userTableViewCell", for: indexPath) as! UserTableViewCell
        cell.userData = usersArray[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
}

extension ViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension ViewController:DeleteObj{
    func deleteObj(userData: UserData) {
        
        context?.delete(userData)
        
        do{
            try context?.save()
            usersArray = []
            loadData()
            usersTableView.reloadData()
        }catch(let error){
            print(error)
        }
    }
    
    func editObj(userData: UserData){
        
//        txtUserName.text = userData.value(forKey: "username") as? String
//        txtPassword.text = userData.value(forKey: "password") as? String
//        txtAge.text = userData.value(forKey: "age") as? String

        txtUserName.text = userData.username
        txtPassword.text = userData.password
        txtAge.text = userData.age
        
        txtPassword.isUserInteractionEnabled = false
        editFlag = true
        
    }
}
