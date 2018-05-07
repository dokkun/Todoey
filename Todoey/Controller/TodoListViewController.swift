//
//  ViewController.swift
//  Todoey
//
//  Created by noname on 5/2/18.
//  Copyright © 2018 dokku. All rights reserved.
//

import UIKit
       // subclass
class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "find Eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Fas"
        itemArray.append(newItem3)
        
        loadItems()
    }
 // MARK - Tableview Datasource Methods
   //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
    
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ?  .checkmark : .none

        return cell
        
    }
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK-  add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once when the user clicks the Add item button on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
         
            self.itemArray.append(newItem)
            
            self.saveItems()
           
        }
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "Create new item"
           textField = alertTextFiled
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error Coding item Array,\(error)")
        }
         // RELOAD DATA
        tableView.reloadData()
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("\(error)")
        }
    }
  }
}

