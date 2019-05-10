//
//  UserTableViewCell.swift
//  CoreData_Demo
//
//  Created by LogicalWings Mac on 23/10/18.
//  Copyright © 2018 LogicalWings Mac. All rights reserved.
//

import UIKit
import CoreData

protocol DeleteObj {
    func deleteObj(userData:UserData)
    func editObj(userData:UserData)
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    
    var delegate : DeleteObj? =  nil
    
    var userData : UserData?{
        didSet{
            
          updateCells()
        }
    }
    
    func updateCells(){
        
//        lblUserName.text = userData?.value(forKey: "username") as? String
//        lblPassword.text = userData?.value(forKey: "password") as? String
//        lblAge.text = userData?.value(forKey: "age") as? String
        
        lblUserName.text = userData?.username
        lblPassword.text = userData?.password
        lblAge.text = userData?.age
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        
        delegate?.deleteObj(userData: userData!)
        
    }
    @IBAction func btnEdit(_ sender: Any) {
        
        delegate?.editObj(userData: userData!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
