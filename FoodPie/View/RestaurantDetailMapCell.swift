//
//  RestaurantDetailMapCell.swift
//  FoodPie
//
//  Created by ciggo on 4/7/20.
//  Copyright © 2020 ciggo. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailMapCell: UITableViewCell {

    @IBOutlet var mapView: MKMapView!

    func configure(location: String) {
        let geoCoder = CLGeocoder()
        print(location)

        geoCoder.geocodeAddressString(location) {
            placemarks, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let placemarks = placemarks {
                let placemark = placemarks.first

                let annotation = MKPointAnnotation()
                if let location = placemark?.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)

                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
