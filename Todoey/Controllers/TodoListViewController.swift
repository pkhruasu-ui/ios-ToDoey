//
//  ViewController.swift
//  Todoey
//
//  Created by Khruasuwan, Prajak(AWF) on 4/20/18.
//  Copyright © 2018 Khruasuwan, Prajak(AWF). All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

//    var itemArray = ["Find mike", "Buy Games", "Destroy this reality"]
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    // Storing data using default plist
    // let defaults = UserDefaults.standard
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        let item1 = Item()
//        item1.title = "Find Mike"
//        itemArray.append(item1)
//
//        let item2 = Item()
//        item2.title = "Buy Games"
//        itemArray.append(item2)
//
//        let item3 = Item()
//        item3.title = "Destroy this reality"
//        itemArray.append(item3)

        
        
//        loadItems()
        
        
        
//        itemTableView.delegate = self
//        itemTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return itemArray.count
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])    // delete the virtual data first
//        itemArray.remove(at: indexPath.row)         // then remove from array so index does not go out of bound
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if itemArray[indexPath.row].done == false {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in

            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? "New Item"
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            
// plist way
//            let newItem = Item()
//            newItem.title = textField.text ?? "New Item"
//            self.itemArray.append(newItem)
            
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
//            self.saveItems()
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!)
//
//        } catch {
//            print("Error encoding item array, \(error)")
//        }
        
        tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            request.predicate = categoryPredicate
        }
        
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
//    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                fatalError("Error decoding data")
//            }
//
//        }
        
        
        // Using default plist to save data
        //        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
        //            itemArray = items
        //        }
//    }
    
}

//MARK - Search Bar delegate
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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
