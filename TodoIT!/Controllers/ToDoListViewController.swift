//
//  ViewController.swift
//  TodoIT!
//
//  Created by Antonio Orozco on 8/13/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategorie: Category? {
        didSet{
            loadItems()
        }
    }
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

            if let item = todoItems?[indexPath.row] {
                cell.textLabel?.text = item.title
                cell.accessoryType = item.done ? .checkmark : .none
                
            } else {
                
                cell.textLabel?.text = "No items under this category"
            }
     
        return cell
    }

    //MARK - TableView delegate methods
    //method triggered after the user selects a row on the table
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                     item.done = !item.done
                }
                
            } catch {
                        print("Error editing an item \(error)")
                    }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new TodoIT! item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
    
            if let currentCategory = self.selectedCategorie {
                do {
                try self.realm.write {
                    
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.done = false
                    newItem.createdDate = Date()
                    
                    currentCategory.items.append(newItem)
                    
                    }} catch {
                        print("Error saving items, \(error)")
                    }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - loadItems - Decodes the file on dataFilePath and assigns it to itemArray for the app to handle it
    func loadItems(){
        todoItems = selectedCategorie?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
 
   
}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
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
