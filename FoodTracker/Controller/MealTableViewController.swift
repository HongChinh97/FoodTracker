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
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredData = DataService.shared.meals
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell else {
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
        filteredData = searchText.isEmpty ? (DataService.shared.meals) : (DataService.shared.meals.filter({(meals: Meal) -> Bool in return meals.name.lowercased().contains(searchText.lowercased())
            
        }))
        tableView.reloadData()
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let detailViewController = segue.destination as? MealViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let index = DataService.shared.meals.index(of: filteredData[indexPath.row]) {
                    detailViewController.index = index
                }
            }
        }
    }
    
    
//    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.source as? MealViewController,
//            let _ = sourceViewController.meal {
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                if let index = meals.index(of: filteredData[selectedIndexPath.row]) {
//                    // cap nhat bua an hien co
//                    meals[index] = sourceViewController.meal!
//                    filteredData = meals
//                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
//
//                }
//            } else {
//
////                meals.append(sourceViewController.meal!)
//                filteredData = meals
//
//            }
//            DataService.shared.saveMeals()
//            tableView.reloadData()
//        }
//    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
//            if let index = meals.index(of: filteredData[indexPath.row]) {
//                meals.remove(at: index)
//            }
//            filteredData.remove(at: indexPath.row)
//            DataService.shared.saveMeals()
            
                //lay vi tri index cua mang filteredData
            if let index = DataService.shared.meals.index(of: filteredData[indexPath.row]) {
                //lay vi tri cua mang du lieu goc
                DataService.shared.removeMeal(at: index)
                filteredData.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            print("Delete")
        }
    }
    

    
}


