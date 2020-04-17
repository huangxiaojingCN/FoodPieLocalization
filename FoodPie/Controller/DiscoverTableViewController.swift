//
//  DiscoverTableViewController.swift
//  FoodPie
//
//  Created by ciggo on 4/16/20.
//  Copyright © 2020 ciggo. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {

    var restaurants: [CKRecord] = []

    var spinner = UIActivityIndicatorView()

    private var imageCache = NSCache<CKRecord.ID, NSURL>()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = true

        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont]
        }

        tableView.cellLayoutMarginsFollowReadableWidth = true

        spinner.hidesWhenStopped = true
        view.addSubview(spinner)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0), spinner.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)])
         spinner.startAnimating()

        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged)

        fetchRecordsFromCloud()
    }

    @objc func fetchRecordsFromCloud() {

        self.restaurants.removeAll()
        self.tableView.reloadData()

        let cloudContainer = CKContainer(identifier: "iCloud.com.honey.FoodPieCloudDB")
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

//        publicDatabase.perform(query, inZoneWith: nil, completionHandler: {
//            (results, error) -> Void in
//
//            if let error = error {
//                print(error)
//                return
//            }
//
//            if let results = results {
//                print("Completed the download of Restaurant Data.")
//                self.restaurants = results
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        })

        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name", "type", "location", "phone", "description"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50

        queryOperation.recordFetchedBlock = { (record) -> Void in
            self.restaurants.append(record)
        }

        queryOperation.queryCompletionBlock = {
            [unowned self] (cursor, error) -> Void in

            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }

            print("Successfully retrieve the data from iCloud")
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.reloadData()

                if let refreshControl = self.refreshControl {
                    refreshControl.endRefreshing()
                }
            }
        }

        publicDatabase.add(queryOperation)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath) as! DiscoverRestaurantCell
        let restaurant = restaurants[indexPath.row]

        cell.nameLabel.text = restaurant.object(forKey: "name") as? String
        cell.typeLabel.text = restaurant.object(forKey: "type") as? String
        cell.locationLabel.text = restaurant.object(forKey: "location") as? String
        cell.phoneLabel.text = restaurant.object(forKey: "phone") as? String
        cell.descriptionLabel.text = restaurant.object(forKey: "description") as? String

        //cell.textLabel?.text = restaurant.object(forKey: "name") as? String

        ///cell.imageView?.image = UIImage(systemName: "photo")

        if let imageFileUrl = imageCache.object(forKey: restaurant.recordID) {
            if let imageData = try? Data(contentsOf: imageFileUrl as URL) {
                //cell.imageView?.image = UIImage(data: imageData)
                cell.headerImageView.image = UIImage(data: imageData)
            }
        } else {
            let publicContainer = CKContainer(identifier: "iCloud.com.honey.FoodPieCloudDB")
                   let publicDatabase = publicContainer.publicCloudDatabase
                   let fetchRecordOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
                   fetchRecordOperation.desiredKeys = ["image"]
                   fetchRecordOperation.queuePriority = .veryHigh
                   fetchRecordOperation.perRecordCompletionBlock = {(record, recordId, error) in
                       if let error = error {
                           print("Failed to get restaurant image: \(error.localizedDescription)")
                           return
                       }

                       if let restaurantRecord = record {
                           if let image = restaurantRecord.object(forKey: "image"), let imageAsset = image as? CKAsset {
                               if let imageData = try? Data(contentsOf: imageAsset.fileURL!) {
                                   DispatchQueue.main.async {
//                                       cell.imageView?.image = UIImage(data: imageData)
                                    cell.headerImageView.image = UIImage(data: imageData)
                                       self.tableView.setNeedsLayout()
                                   }

                                self.imageCache.setObject(imageAsset.fileURL! as NSURL, forKey: restaurantRecord.recordID)
                               }
                           }
                       }
                   }

                   publicDatabase.add(fetchRecordOperation)
        }

        return cell
    }
}
