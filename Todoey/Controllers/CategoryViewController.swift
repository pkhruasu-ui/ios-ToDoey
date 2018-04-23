//
//  CategoryViewController.swift
//  Todoey
//
//  Created by PRAJAK KHRUASUWAN on 4/22/18.
//  Copyright © 2018 Khruasuwan, Prajak(AWF). All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK - Save and Load Methods
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadItems() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching category \(error)")
        }
        
        tableView.reloadData()
        
    }
    //MARK - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text ?? "New Category"
            self.categoryArray.append(newCategory)
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}
