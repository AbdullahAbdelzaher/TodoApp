//
//  ViewController.swift
//  TodoApp
//
//  Created by Abdullah on 10/26/19.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import UIKit
import  CoreData

@available(iOS 13.0, *)

class TodoListViewController: UITableViewController {
    var itemArray = [ Item ] ()
    var selectedCategories: Category? {
        
        didSet{
            loadItems()
        }
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        
        print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
                return cell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//       context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()

        
                
        
        //print(itemArray[indexPath.row])
    }
    
    //MARK - add new items
    
    @available(iOS 13.0, *)
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user click the add button
            
          
            let newitem = Item(context: self.context)
            newitem.title = textField.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategories
            self.itemArray.append(newitem)
            self.saveData()
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert , animated: true , completion: nil)
    }
    
    
    func saveData () {
                           do {
                    
                            try context.save()
                   }
                   catch {
                       
                       print("there is error\(error)")
                   }
                   
        self.tableView.reloadData()
    }
    
    
    func loadItems (with   request: NSFetchRequest<Item> = Item.fetchRequest() , predicate: NSPredicate? = nil) {

        let categoreyPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategories!.name!)
        if let aditionalPredicate = predicate {
             
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [aditionalPredicate , categoreyPredicate])
            
        } else {
            request.predicate = categoreyPredicate
            
        }
        
        do{
        itemArray = try context.fetch(request)
            let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategories!.name!)
            request.predicate = predicate
        }catch
        {
        print("there is error fetching data from cotext \(error)")
            
            
        }

        tableView.reloadData()
    }


}
//MARK: - search bar methods
@available(iOS 13.0, *)
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
        loadItems(with: request , predicate: predicate )
        
        
        
        
        
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



