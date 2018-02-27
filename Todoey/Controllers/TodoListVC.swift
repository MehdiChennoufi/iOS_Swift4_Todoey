//
//  TodoListVC.swift
//  Todoey
//
//  Created by Mehdi Chennoufi on 21/02/2018.
//  Copyright © 2018 Mehdi Chennoufi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListVC: SwipeTableViewController {
    
    // MARK: - Variables
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //MARK: - View's Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.backGroundColor else { fatalError() }
        
        updateNavBar(withHexCode: colorHex)
        
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        updateNavBar(withHexCode: "55ACEE")
    }

    
    //MARK: - NavBar Setup Methods
    func updateNavBar(withHexCode colourHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exists.")}
        
        guard let navBarColor = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.flatWhite()]
        searchBar.barTintColor = navBarColor
        
        //Handle SearchBar borders
        navBar.backgroundImage(for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
    }
    
    // MARK: - Table View Data Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let colour = UIColor(hexString: selectedCategory!.backGroundColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error saving datas \(error)")
            }
            
            tableView.reloadData()
        }
        
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
            //Optionnal binding on category, if ok I make my Item and add it to the current category
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Erro while adding a newItem : \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Item"
            textField = alertTextfield
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Save and Load items
    
    //Load function
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete from a swipe
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item : \(error)")
            }
        }
    }
}


//MARK: - Search bar methods
extension TodoListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Filtering datas
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
