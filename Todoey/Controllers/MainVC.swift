//
//  MainVC.swift
//  Todoey
//
//  Created by Mehdi Chennoufi on 21/02/2018.
//  Copyright © 2018 Mehdi Chennoufi. All rights reserved.
//

import UIKit

class MainVC: UITableViewController {

  // MARK: - Variables
  let defaults = UserDefaults.standard
  var itemArray : [String] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

      if let items = defaults.array(forKey: "todoListArray") as? [String] {
        itemArray = items
      }
      
    }

  // MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)

         cell.textLabel?.text = itemArray[indexPath.row]

        return cell
    }
 
    //MARK: Table View Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark  {
          tableView.cellForRow(at: indexPath)?.accessoryType = .none
      } else {
          tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
      }
      
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
    //MARK - Actions
  
    @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
        
      guard textField.text?.isEmpty == false else {
        return
      }
        self.itemArray.append(textField.text!)
        self.defaults.set(self.itemArray, forKey: "todoListArray")
        self.tableView.reloadData()
      }
      
      alert.addTextField { (alertTextfield) in
        alertTextfield.placeholder = "Create new Item"
        textField = alertTextfield
      }
      
      alert.addAction(alertAction)
      
      present(alert, animated: true, completion: nil)
    }
  

}
