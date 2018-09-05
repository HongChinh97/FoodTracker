//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by admin on 7/31/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var meals = [Meal]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredData = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //Sử dụng mục nút chỉnh sửa do bộ điều khiển xem bảng cung cấp.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedMeals = DataService.shared.loadMeals() {
            meals += savedMeals
        }
        else {
           DataService.shared.loadSampleMeals()
            
        }
        filteredData = meals
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instant of MealTableViewCell.")
            
        }

        // Configure the cell...
        let meal = filteredData[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        

        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return}
        filteredData = searchText.isEmpty ? (meals) : (meals.filter({(meals: Meal) -> Bool in return meals.name.lowercased().contains(searchText.lowercased())
            
        }))
        tableView.reloadData()
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //xem xet gia tri va so sanh de su dung lenh chuyen doi
        switch(segue.identifier ?? "") {
            
            //
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender!)")
            }
            
            if let indexPath = tableView.indexPath(for: selectedMealCell){
                if let index = meals.index(of: filteredData[indexPath.row]) {
                    mealDetailViewController.meal = meals[index]
                }
            }
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let _ = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                if let index = meals.index(of: filteredData[selectedIndexPath.row]) {
                    // cap nhat bua an hien co
                    meals[index] = sourceViewController.meal!
                    filteredData = meals
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    
                }
            } else {
                
                meals.append(sourceViewController.meal!)
                filteredData = meals
               
            }
            DataService.shared.saveMeals()
            tableView.reloadData()
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if let index = meals.index(of: filteredData[indexPath.row]) {
                meals.remove(at: index)
            }
            filteredData.remove(at: indexPath.row)
            DataService.shared.saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            print("Delete")
        }
    }
    

    
}


