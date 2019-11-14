//
//  CategoryViewController.swift
//  TodoApp
//
//  Created by Abdullah on 11/12/19.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import UIKit
import  CoreData
@available(iOS 13.0, *)
class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK: - TableView DataSource Model
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        
        return cell
    }
    
    
    
    //MARK: - Data Manipuolation Methods
    
    
    func loadCategory(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        
        do {
            categoryArray = try (context?.fetch(request))!
        }
        
        catch{
            
            print("fetching error \(error)")
            
        }
        
        tableView.reloadData()
    }
    
    
    
    
    func saveCategories() {
        do {
        try context?.save()
        }
        catch {
            
            
            print("saving error \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    
    //MARK: - Add New Category
    
    
    
    
    @IBAction func addButtonPressd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory =  Category(context: self.context!)
            
            newCategory.name = textField.text
            
            self.categoryArray.append(newCategory)
            self.tableView.reloadData()
            
            self.saveCategories()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = " Add New Category "
            textField = alertTextField
        }
        
        
        
        alert.addAction(action)
        
        present(alert, animated: true , completion: nil)
    
    }
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath =  tableView.indexPathForSelectedRow{
            
            destinationVC.selectedCategories = categoryArray[indexPath.row]
            
        }
        
        
    }
    
    
    
}
