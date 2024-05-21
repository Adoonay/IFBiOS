//
//  MapViewController.swift
//  Map
//
//  Created by Adonay on 21/05/24.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CodeView, BindableView {
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserTrackingButton = true
        mapView.showsUserLocation = false
        return mapView
    }()

    lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.95)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()

    lazy var mapPin: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "mappin.and.ellipse")
        view.tintColor = .black
        return view
    }()

    let locationManager = CLLocationManager()

    var viewModel: MapViewModel
    var isAddingItem: Bool = false {
        didSet {
            updateAddMode()
        }
    }

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    func updateAddMode() {
        if isAddingItem {
            mapPin.isHidden = false
            addButton.isHidden = true
        } else {
            mapPin.isHidden = true
            addButton.isHidden = false
        }
    }

    @objc
    func handleAdd() {
        viewModel.didTapAdd()
        isAddingItem = true
    }

    func addItem(type: ItemType, description: String) {
        let coordinate = mapView.centerCoordinate
        viewModel.add(item: .init(coordinate: coordinate, type: type, description: description))
        isAddingItem = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }

    func bindViewModel() {
        viewModel.items.bind { items in
            let annotations = items.map({ ItemAnnotation(item: $0) })
            self.mapView.addAnnotations(annotations)
        }
    }

    func buildViewHierarchy() {
        view.addSubview(mapView)
        view.addSubview(mapPin)
        view.addSubview(addButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 44),

            mapPin.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            mapPin.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -8),
            mapPin.heightAnchor.constraint(equalToConstant: 60),
            mapPin.widthAnchor.constraint(equalTo: mapPin.heightAnchor)
        ])
    }

    func setupAdditionalConfiguration() {
        mapView.delegate = self
        mapView.register(ItemAnnotationView.self, forAnnotationViewWithReuseIdentifier: "\(ItemAnnotationView.self)")
        locationManager.delegate = self

        updateAddMode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ItemAnnotation else {
            return nil
        }

        let view = mapView.dequeueReusableAnnotationView(withIdentifier: "\(ItemAnnotationView.self)", for: annotation)
        if let view = view as? ItemAnnotationView {
            view.configure(annotation: annotation)
        }
        return view
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let view = view as? ItemAnnotationView, let annotation = view.annotation as? ItemAnnotation {
            mapView.removeAnnotation(annotation)
            viewModel.markAsReturned(item: annotation.item)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.requestLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
            mapView.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
