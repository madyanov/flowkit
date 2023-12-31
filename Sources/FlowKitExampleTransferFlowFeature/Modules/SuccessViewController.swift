import UIKit

final class SuccessViewController: UIViewController {
    private let transfer: Transfer
    private let completion: () -> Void

    init(transfer: Transfer, completion: @escaping () -> Void) {
        self.transfer = transfer
        self.completion = completion

        super.init(nibName: nil, bundle: nil)

        title = "Success"
        navigationItem.hidesBackButton = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        let identifierLabel = UILabel()
        let countryLabel = UILabel()
        let amountLabel = UILabel()
        let commissionLabel = UILabel()

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)

        view.addSubview(stackView)
        stackView.addArrangedSubview(identifierLabel)
        stackView.addArrangedSubview(countryLabel)
        stackView.addArrangedSubview(amountLabel)
        stackView.addArrangedSubview(commissionLabel)
        stackView.addArrangedSubview(closeButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ])

        identifierLabel.text = "Identifier: \(transfer.identifier)"
        countryLabel.text = "Country: \(transfer.country.name)"
        amountLabel.text = "Amount: \(transfer.amount)"
        commissionLabel.text = "Commission: \(transfer.tariff.commission)%"
    }
}

private extension SuccessViewController {
    @objc
    func didTapCloseButton() {
        completion()
    }
}
