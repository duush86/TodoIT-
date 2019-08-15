//
//  ViewController.swift
//  TodoIT!
//
//  Created by Antonio Orozco on 8/13/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    // setting up itemArray, that will be used to host the items retrieved from Items.plist and the new items.
    var itemArray = [item]()
    // setting up dataFilePath that will be a reference to the app .plist
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK - Tableview Datasource Methods
    // numberOfRowsInSection method that prints all the cells for every item on itemArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // cellForRowAt method that is used to set the text for every cell element
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // reference to the ToDoItemCell element
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // pulls every item on itemArray
        let item = itemArray[indexPath.row]
        // assigns the item.title text to the cell element's text
        cell.textLabel?.text = item.title
        // prints the checkmark if needed depending on the object .done element
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    //MARK - TableView delegate methods
    //method triggered after the user selects a row on the table
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if the .done element is true, set the element to false. If the .done element is false, set the element to true
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //call method to save data into the .plist file, here you'll be saving if the user made a change on the .done element
        saveData()
        // animate the table
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
            //what will happen once the user clicks the add item alert in our alert
            //creates a new instance of the item class
            let newItem = item()
            //assigns .title the value hosted on textField.text
            newItem.title = textField.text!
            //appends the new item element on the itemArray array
            self.itemArray.append(newItem)
            
            
            // calls saveData function
            self.saveData()
            
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
    
    //MARK - saveData function - Encodes the itemArray array and writes the content into the dataFilePath reference. Then reloads the table data.
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("some happened")
        }
        tableView.reloadData()
    }
    
    //MARK - loadItems - Decodes the file on dataFilePath and assigns it to itemArray for the app to handle it
    func loadItems(){
      if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                    itemArray = try decoder.decode([item].self, from: data)
            } catch {
                print("Error decoding item array \(error)")
            }
        }
    }
}

