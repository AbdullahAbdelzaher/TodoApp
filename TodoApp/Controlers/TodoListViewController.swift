//
//  ViewController.swift
//  TodoApp
//
//  Created by Abdullah on 10/26/19.
//  Copyright © 2019 Abdullah. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [ Item ] ()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.Plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        
        print(dataFilePath)
        loadItems()
        
      
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()

        
                
        
        print(itemArray[indexPath.row])
    }
    
    //MARK - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user click the add button
            let newitem = Item()
            newitem.title = textField.text!
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
        
        let encoder = PropertyListEncoder()
                   do {
                       let data = try encoder.encode(itemArray)
                       try data.write(to:dataFilePath!)
                   }
                   catch {
                       
                       print("there is error\(error)")
                   }
                   
        self.tableView.reloadData()
    }
    
    
    func loadItems () {
        
        if  let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
        }catch{
            
            print("there is error \(error)")
        
        
        
    }
        
        
}

}
}
