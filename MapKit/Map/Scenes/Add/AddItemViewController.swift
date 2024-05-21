//
//  AddItemViewController.swift
//  Map
//
//  Created by Adonay on 21/05/24.
//

import UIKit

class AddItemViewController: UIViewController, CodeView, BindableView {
    var viewModel: AddItemViewModel

    lazy var contentStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(top: 16, left: 16, bottom: 0, right: 16)
        return view
    }()

    lazy var typeSegmented: UISegmentedControl = {
        let segmented = UISegmentedControl()
        segmented.insertSegment(withTitle: "Achei um item", at: 0, animated: false)
        segmented.insertSegment(withTitle: "Perdi um item", at: 1, animated: false)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()

    lazy var descriptionTextfield: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "O que objeto você achou?"
        field.tintColor = .black
        field.returnKeyType = .done
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return field
    }()

    lazy var addButton: UIButton = {
        let view = UIButton()
        view.setTitle("Adicionar", for: .normal)
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        view.tintColor = .white
        view.setTitleColor(.white, for: .normal)
        view.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
        view.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.isEnabled = false
        return view
    }()

    lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle("Cancelar", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        view.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return view
    }()

    @objc
    func handleAdd() {
        let type: ItemType = typeSegmented.selectedSegmentIndex == 0 ? .found : .lost
        viewModel.didTapAdd(type: type, description: descriptionTextfield.text ?? "")
    }

    @objc
    func handleCancel() {
        viewModel.didTapCancel()
    }

    @objc
    func handleTextChange() {
        viewModel.validate(text: descriptionTextfield.text ?? "")
    }

    init(viewModel: AddItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }

    func bindViewModel() {
        viewModel.isEnabled.bind { isEnabled in
            self.addButton.isEnabled = isEnabled
        }
    }

    func buildViewHierarchy() {
        view.addSubview(contentStack)

        contentStack.addArrangedSubview(typeSegmented)
        contentStack.addArrangedSubview(descriptionTextfield)
        contentStack.addArrangedSubview(.stack(views: [cancelButton, addButton], axis: .horizontal, spacing: 16, distribution: .fillEqually))
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.topAnchor),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addButton.heightAnchor.constraint(equalToConstant: 48),
            cancelButton.heightAnchor.constraint(equalToConstant: 48),
            descriptionTextfield.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
