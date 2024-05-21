//
//  MapViewModel.swift
//  Map
//
//  Created by Adonay on 21/05/24.
//

import Foundation

class MapViewModel {
    var coordinator: MapCoordinator
    var items: Bindable<[Item]> = .init([])

    init(coordinator: MapCoordinator) {
        self.coordinator = coordinator
    }

    func add(item: Item) {
        items.value.append(item)
    }

    func didTapAdd() {
        coordinator.presentAdd()
    }

    func markAsReturned(item: Item) {
        if let index = items.value.firstIndex(of: item) {
            self.items.value.remove(at: index)
            self.items.value.append(.init(coordinate: item.coordinate, type: .returned, description: item.description))
        }
    }
}
