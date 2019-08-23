//
//  ViewController.swift
//  TodoIT!
//
//  Created by Antonio Orozco on 8/13/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategorie: Category? {
        didSet{
            loadItems()
        }
    }
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(hexString: selectedCategorie?.backgroundColor)

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategorie?.name
        
        guard let colourHex = selectedCategorie?.backgroundColor else { fatalError() }
        
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        //guard (navigationController?.navigationBar) != nil else {fatalError("Navigation controller does not exist.")}

        updateNavBar(withHexCode: "2C3E50")
    }
    
    func updateNavBar(withHexCode colourHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(backgroundColor: navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: navBarColour, returnFlat: true)]
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: navBarColour, returnFlat: true)]

        
        searchBar.barTintColor = navBarColour
        
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

            if let item = todoItems?[indexPath.row] {
                cell.textLabel?.text = item.title
                cell.accessoryType = item.done ? .checkmark : .none
                cell.backgroundColor = UIColor(hexString: item.backgroundColor)
                if let colour = UIColor(hexString: selectedCategorie!.backgroundColor)?.darken(byPercentage:
                    CGFloat(indexPath.row) / (3*CGFloat(todoItems!.count))){
                    cell.backgroundColor = colour
                    cell.textLabel?.textColor = ContrastColorOf(backgroundColor: colour, returnFlat: true)
                }
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
                    newItem.backgroundColor = (UIColor.randomFlat()?.hexValue())!

                    
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
    
    override func updateModels(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row]
        {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("\(error) something happened deleting an item")
            }
        }
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
