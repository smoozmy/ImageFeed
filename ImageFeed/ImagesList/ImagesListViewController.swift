import UIKit

import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - UI and Lyfe Cycle
    
    private lazy var tableView: UITableView = {
        let element = UITableView(
//            frame: .zero,
//            style: .insetGrouped
        )
        element.backgroundColor = .ypBlack
//        element.separatorStyle = .none
        element.dataSource = self
        element.delegate = self
        
        element.register(
            ImagesListCell.self,
            forCellReuseIdentifier: ImagesListCell.reuseIdentifier
        )
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypRed
        
        setView()
        setupConstraints()
    }
    private func setView() {
        view.addSubview(tableView)
    }
    
    // MARK: - Actions
    
    func configCell(for cell: ImagesListCell) { }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
         Вызывая этот метод у dataSource, таблица узнаёт, сколько ячеек будет в конкретной секции. Номер секции передаётся в параметре numberOfRowsInSection
         */
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
         Основной метод для работы с таблицей. В нём мы создаём ячейку, наполняем её данными и передаём таблице. Таблица вызывает метод dataSource для каждой ячейки.
         */
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // 1
                
                guard let imageListCell = cell as? ImagesListCell else { // 2
                    return UITableViewCell()
                }
                
                configCell(for: imageListCell) // 3
                return imageListCell // 4
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    /*
     Этот метод отвечает за действия, которые будут выполнены при тапе по ячейке таблицы. «Адрес» ячейки, который содержится в indexPath, передаётся в качестве аргумента. Пока оставьте реализацию метода пустой — он ещё пригодится нам в этом же проекте.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
}

// MARK: - Constraints

extension ImagesListViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


