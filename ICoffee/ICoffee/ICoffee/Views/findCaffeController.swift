//
//  findCaffeController.swift
//  ICoffee
//
//  Created by student on 18/05/2020.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class findCaffeController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var MyMapView: MKMapView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var getDirection: UIButton!
    
    @IBOutlet var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var nameL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        checkLocationServices()
        
        MyMapView.delegate = self
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let homeViewC = self.storyboard?.instantiateViewController(identifier: Constants.self.Storyboard.homeViewC) as? HomeController
        
        self.view.window?.rootViewController = homeViewC
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func getDirectionTapped(_ sender: Any) {
        getAddress(name: nameL)
        self.nameL = ""
    }
    
    func setUpElements(){
        
        // styl jednotlivých elementů
        Utilities.styleFilledB(getDirection)
    }
    
    
    func getAddress(name: String){
        print(name)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(name){ (placemarks, error) in
            guard let placemarks = placemarks,
                let location = placemarks.first?.location
                else{
                    print("No location found")
                    return
            }
            print("location")
            print(location.coordinate)
            self.mapThis(destinationCord: location.coordinate)
        }
        
    }
    
    func mapThis(destinationCord: CLLocationCoordinate2D){
        let sourceCoordinate = (locationManager.location?.coordinate)!
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        destinationRequest.transportType = .walking
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate{(response, error) in
            guard let response = response else {
                if let error = error{
                    print("Something is wrong (:")
                }
                return
            }
            let route = response.routes[0]
            self.MyMapView.addOverlay(route.polyline)
            self.MyMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .brown
        return render
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start {
            (response, error ) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil {
                print("error")
            } else {
                
                let latitude = response!.boundingRegion.center.latitude
                let longitute = response!.boundingRegion.center.longitude
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitute)
                self.MyMapView.addAnnotation(annotation)
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitute)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                
                self.MyMapView.setRegion(region, animated: true)
                
                let geoCoder2 = CLGeocoder()
                let center2 = CLLocation(latitude: latitude, longitude: longitute)
                geoCoder2.reverseGeocodeLocation(center2){ [weak self] (placemarks, error) in
                    guard let self = self else {return}
                    if let _ = error{
                        return
                    }
                    
                    guard let placemark = placemarks?.first else {
                        return
                    }
                    
                    let city = placemark.locality ?? ""
                    let streetNumber = placemark.subThoroughfare ?? ""
                    let streetName = placemark.thoroughfare ?? ""
                    print(city)
                    DispatchQueue.main.async {
                        self.addressLabel.text = "\(streetName) \(streetNumber) \(city)"
                        self.nameL = "\(streetName) \(streetNumber) \(city)"
                    }
                    
                    
                }
            }
            
        }
        
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            MyMapView.setRegion(region, animated: true)
        }
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case . authorizedWhenInUse:
            MyMapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation();
            break
        case . denied:
            // alerts about permissions
            
            break
        case . notDetermined:
            //asking permissions
            locationManager.requestWhenInUseAuthorization()
            break
        case . restricted:
            // alerts about service
            break
        case . authorizedAlways:
            break
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //alert
        }
    }
    
}

extension findCaffeController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{ return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        MyMapView.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: [CLAuthorizationStatus]){
        checkLocationAuthorization()
    }
    
}
