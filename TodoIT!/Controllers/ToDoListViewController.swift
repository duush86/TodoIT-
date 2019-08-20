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

    // setting up itemArray, that will be used to host the items retrieved from Items.plist and the new items.
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
    // numberOfRowsInSection method that prints all the cells for every item on items
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // cellForRowAt method that is used to set the text for every cell element
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // reference to the ToDoItemCell element
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

            if let item = todoItems?[indexPath.row] {
                cell.textLabel?.text = item.title
                cell.accessoryType = item.done ? .checkmark : .none
               // print(item)
                
            } else {
                
                cell.textLabel?.text = "No items under this category"
                //print("No items here")
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
    //this method will handle the event when the user taps on the "+" button on the user interface
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // declares textField variable to host what the user's input
        var textField = UITextField()
        // alert constant will host an alertController view element
        let alert = UIAlertController(title: "Add new TodoIT! item", message: "", preferredStyle: .alert)
        // action handles the event when the user taps on add element inside the alert alement.
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
    
            if let currentCategory = self.selectedCategorie {
                do {
                try self.realm.write {
                    
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.done = false
                    currentCategory.items.append(newItem)
                    
                    }} catch {
                        print("Error saving items, \(error)")
                    }
            }
            self.tableView.reloadData()
        }
        
       // prints alert on screen
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        // prints and links the alert with the action method
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
//extension ToDoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: predicate)
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
