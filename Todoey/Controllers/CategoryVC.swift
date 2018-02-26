//
//  CategoryVC.swift
//  Todoey
//
//  Created by Mehdi Chennoufi on 21/02/2018.
//  Copyright © 2018 Mehdi Chennoufi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryVC: SwipeTableViewController {

    // MARK: - Variables
    let realm = try! Realm()
    var categoriesArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }

    //MARK: - Table Views Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categoriesArray?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        guard let categoryColor = UIColor(hexString: category?.backGroundColor) else {fatalError()}
        cell.backgroundColor =  categoryColor
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: categoryColor, isFlat: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
        }
    }
    
    
    //MARK: - Actions
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            guard textField.text?.isEmpty == false else {
                return
            }
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.backGroundColor = UIColor.randomFlat().hexValue()
            
            self.save(newCategory)
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create a new category"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadCategories() {
        categoriesArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Delete data from a swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let catToDelete = self.categoriesArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(catToDelete)
                }
            } catch {
                print("Error deleting item : \(error)")
            }
        }
    }

}
