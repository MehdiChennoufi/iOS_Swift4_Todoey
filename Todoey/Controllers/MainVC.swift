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
    
    var itemArray : [Item] = []
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    
    // MARK: - Table View Data Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        item.done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Actions
    
    @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            guard textField.text?.isEmpty == false else {
                return
            }
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Item"
            textField = alertTextfield
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK : - Save and Load items from a local .plist file
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Erreor encoding item array; \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error while decoding item array, \(error)")
            }
        }
    }
}
