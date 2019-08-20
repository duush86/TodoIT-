//
//  CategoryTableViewController.swift
//  TodoIT!
//
//  Created by Antonio Orozco on 8/17/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: UITableViewController {
 
    let realm = try! Realm()
    var categories: Results<Category>?

    
    override func viewDidLoad() {
       super.viewDidLoad()
       loadCategories()
    }
    //MARK - TableView add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
           
            self.saveCategory(category: newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
    //MARK - TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
      
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories yet"
    
        return cell
    }
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategorie = categories?[indexPath.row]
        }
    }
    
    //MARK - Save Data Method
    func saveCategory(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("\(error) something happened loading categories")
        }
        tableView.reloadData()
    }
    
    //MARK - Load data method
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    

}
