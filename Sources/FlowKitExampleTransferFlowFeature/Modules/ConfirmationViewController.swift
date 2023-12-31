import UIKit
import FlowKitExamplePromises

final class ConfirmationViewController: UIViewController {
    private let loadingPublisher: Publisher<Bool>
    private let country: Country
    private let amount: Int
    private let tariff: Tariff
    private let completion: (ConfirmationResult) -> Void

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    init(loadingPublisher: Publisher<Bool>,
         country: Country,
         amount: Int,
         tariff: Tariff,
         completion: @escaping (ConfirmationResult) -> Void) {

        self.loadingPublisher = loadingPublisher
        self.country = country
        self.amount = amount
        self.tariff = tariff
        self.completion = completion

        super.init(nibName: nil, bundle: nil)

        title = "Confirmation"
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

        let countryLabel = UILabel()
        let amountLabel = UILabel()
        let commissionLabel = UILabel()

        let editAmountButton = UIButton(type: .system)
        editAmountButton.setTitle("Edit Amount", for: .normal)
        editAmountButton.addTarget(self, action: #selector(didTapEditAmountButton), for: .touchUpInside)

        let editTariffButton = UIButton(type: .system)
        editTariffButton.setTitle("Edit Tariff", for: .normal)
        editTariffButton.addTarget(self, action: #selector(didTapEditTariffButton), for: .touchUpInside)

        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)

        let dimBackgroundButton = UIButton(type: .system)
        dimBackgroundButton.setTitle("Dim Background", for: .normal)
        dimBackgroundButton.addTarget(self, action: #selector(didTapDimBackgroundButton), for: .touchUpInside)

        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        stackView.addArrangedSubview(countryLabel)
        stackView.addArrangedSubview(amountLabel)
        stackView.addArrangedSubview(commissionLabel)
        stackView.addArrangedSubview(editAmountButton)
        stackView.addArrangedSubview(editTariffButton)
        stackView.addArrangedSubview(continueButton)
        stackView.addArrangedSubview(dimBackgroundButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        countryLabel.text = "Country: \(country.name)"
        amountLabel.text = "Amount: \(amount)"
        commissionLabel.text = "Commission: \(tariff.commission)%"

        loadingPublisher.subscribe { [weak self] loading in
            if loading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

private extension ConfirmationViewController {
    @objc
    func didTapEditAmountButton() {
        completion(.editAmount)
    }

    @objc
    func didTapEditTariffButton() {
        completion(.editTariff)
    }

    @objc
    func didTapContinueButton() {
        completion(.continue)
    }

    @objc
    func didTapDimBackgroundButton() {
        view.backgroundColor = view.backgroundColor == .white ? .lightGray : .white
        completion(.dimBackground)
    }
}
