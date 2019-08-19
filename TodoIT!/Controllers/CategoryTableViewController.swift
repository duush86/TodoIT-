//
//  CategoryTableViewController.swift
//  TodoIT!
//
//  Created by Antonio Orozco on 8/17/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    //MARK - TableView add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // declares textField variable to host what the user's input
        var textField = UITextField()
        // alert constant will host an alertController view element
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        // action handles the event when the user taps on add element inside the alert alement.
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once the user clicks the add item alert in our alert
            //creates a new instance of the item clasdsadsa
            let newCategory = Category(context: self.context)
            //assigns .name the value hosted on textField.text
            newCategory.name = textField.text!
            //appends the new category element on the itemArray array
            self.categoryArray.append(newCategory)
            // calls saveData function
            self.saveCategory()
            
        }
        // prints alert on screen
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        // prints and links the alert with the action method
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
  
    //MARK - TableView datasource methods
    // numberOfRowsInSection method that prints all the cells for every item on itemArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    // cellForRowAt method that is used to set the text for every cell element
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // reference to the ToDoItemCell element
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        // pulls every item on itemArray
        let category = categoryArray[indexPath.row]
        // assigns the item.title text to the cell element's text
        cell.textLabel?.text = category.name
        // prints the checkmark if needed depending on the object .done element
        //cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {            destinationVC.selectedCategorie = categoryArray[indexPath.row]
        }
    }
    
    //MARK - Save Data Method
    func saveCategory(){
        do {
            try context.save()
        } catch {
            print("\(error) something happened loading categories")
        }
        tableView.reloadData()
    }
    
    //MARK - Load data method
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    

}
