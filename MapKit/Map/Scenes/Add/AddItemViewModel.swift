//
//  AddItemViewModel.swift
//  Map
//
//  Created by Adonay on 21/05/24.
//

import Foundation

class AddItemViewModel {
    var coordinator : MapCoordinator
    var isEnabled: Bindable<Bool> = .init(false)

    init(coordinator: MapCoordinator) {
        self.coordinator = coordinator
    }

    func didTapAdd(type: ItemType, description: String) {
        coordinator.addAndDismiss(type: type, description: description)
    }

    func didTapCancel() {
        coordinator.cancelAndDismiss()
    }

    func validate(text: String) {
        isEnabled.value = !text.isEmpty
    }
}
