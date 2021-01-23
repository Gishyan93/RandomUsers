//
//  UserProfileRootView.swift
//  RandomUsers
//
//  Created by Tigran Gishyan on 1/15/21.
//

import UIKit
import RxSwift
import MapKit
import Kingfisher
import CoreData

class UserProfileRootView: NiblessView {
    //
    // MARK: - Properties
    //
    let viewModel: UserProfileViewModel
    var hierarchyNotReady = true
    let disposeBag = DisposeBag()
    
    let selectedUser = PublishSubject<RandomUserProfile>()
    
    var currentUser = RandomUserProfile()
    
    var isSaved: Bool = false
    //Layout
    var stackView = UIStackView()
    
    private lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.isUserInteractionEnabled = false

        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 2000)
        mv.setCameraZoomRange(zoomRange, animated: true)
        mv.delegate = self
        
        return mv
    }()
    
    let userImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.setFrame(.init(width: 140, height: 140))
        imageview.layer.cornerRadius = 70
        imageview.layer.borderWidth = 4
        imageview.layer.borderColor = UIColor.white.cgColor
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
private var saveUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appGreen
        button.layer.cornerRadius = 25
        button.setTitle("Save user", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(" user", for: .selected)
        button.setTitleColor(.black, for: .selected)
        button.setHeight(50)
        return button
    }()
    
    private let removeUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove user")
        button.setTitleColor(.appRed, for: .normal)
        button.setHeight(50)
        return button
    }()
    
    let userNamelabel: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 18)
        name.textAlignment = .center
        name.numberOfLines = 0
        name.textColor = .black
        return name
    }()
    
    let userInfoLabel: UILabel = {
        let gender = UILabel()
        gender.font = .systemFont(ofSize: 12)
        gender.textAlignment = .center
        gender.textColor = .gray
        return gender
    }()
    
    let countryLabel: UILabel = {
        let country = UILabel()
        country.font = .systemFont(ofSize: 12)
        country.textAlignment = .center
        country.textColor = .gray
        return country
    }()
    
    let addressLabel: UILabel = {
        let address = UILabel()
        address.numberOfLines = 0
        address.font = .systemFont(ofSize: 12)
        address.textAlignment = .center
        address.textColor = .gray
        return address
    }()
    
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        
        viewModel.selectedUser
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected view model search results observable error.") })
            .drive(onNext: { [weak self] user in
                guard let strongSelf = self else {return}
                strongSelf.selectedUser.onNext(user)
                
            })
            .disposed(by: disposeBag)
        
        
        selectedUser
            .asDriver(onErrorRecover: { _ in fatalError("Encountered unexpected view model search results observable error.") })
            .drive(onNext: { [weak self] user in
                guard let strongSelf = self else {return}
                //Accepting new value
                guard let url = URL(string: user.picture.large) else {return}
                let imageResource = ImageResource(downloadURL: url)
                strongSelf.userImageView.kf.setImage(with: imageResource)
                
                strongSelf.userNamelabel.text = "\(String(describing: user.name.first)) \(String(describing: user.name.last))"
                
                let capitilizedGender = user.gender.capitalizingFirstLetter()
                strongSelf.userInfoLabel.text = "\(String(describing: capitilizedGender)), \(String(describing: user.phone))"
                strongSelf.countryLabel.text = user.location.country
                
                let streetNumber = String(user.location.street.number)
                strongSelf.addressLabel.text = "\(streetNumber) \(String(describing: user.location.street.name)) \(String(describing: user.location.city))"
                
                
                //CLLocationDegrees
                let latitude =  CLLocationDegrees(user.location.coordinates.latitude ?? "0")
                let longitude = CLLocationDegrees(user.location.coordinates.longitude ?? "0")
                
                
                let london = MKPointAnnotation()
                let location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let loc = CLLocation(latitude: latitude!, longitude: longitude!)
                london.coordinate = location
    
                strongSelf.mapView.addAnnotation(london)
                strongSelf.mapView.centerToLocation(loc)
                
                strongSelf.currentUser = user
                      
                let fetchedUsers: NSFetchRequest<Person> = Person.fetchRequest()
                do {
                    let savedUsers = try PersistanceService.context.fetch(fetchedUsers)
                    let foundUser = savedUsers.filter {
                        $0.id == user.id
                    }
                    if foundUser.count > 0 {
                        viewModel.indicateSavingUser()
                        viewModel.buttonPressedColor()
                    } else {
                        viewModel.indicateRemoveUser()
                    }
                } catch {
                    fatalError("Error fetching data from Person class")
                }                
                
            })
            .disposed(by: disposeBag)
        
        
        
        bindViewModelToViews()
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = .white
        constructHierarchy()
        activateConstraints()
        wireSaveUser()
        wireRemoveUser()
        
        hierarchyNotReady = false
    }
    
    func constructHierarchy() {
        addSubview(mapView)
        addSubview(userImageView)
        addSubview(removeUserButton)
        addSubview(saveUserButton)
    }
    
    func activateConstraints() {
        activateConstraintsMapView()
        activateConstraintsImageView()
        activateConstraintsSaveUserButton()
        activateConstraintsRemoveUserButton()
        activateContraintsStackView()
    }
    
    private func activateConstraintsMapView() {
        mapView.setHeight(200)
        mapView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    }
    
    private func activateConstraintsImageView() {
        userImageView.centerXInSuperview()
        let yConstraint = NSLayoutConstraint(item: userImageView, attribute: .centerY, relatedBy: .equal, toItem: self.mapView, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([yConstraint])
    }
    
    private func activateConstraintsSaveUserButton() {
        saveUserButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 50, bottom: 100, right: 50))
    }
    
    private func activateConstraintsRemoveUserButton() {
        
        removeUserButton.anchor(top: saveUserButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil)
        removeUserButton.centerXInSuperview()
    }
    
    private func activateContraintsStackView() {
        stackView = VerticalStackView(arrangedSubviews: [userNamelabel,
                                                         userInfoLabel,
                                                         countryLabel,
                                                         addressLabel
        ], spacing: 8)
        
        
        addSubview(stackView)
        stackView.anchor(top: userImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    }
    
    func wireSaveUser() {
        saveUserButton.addTarget(
            self,
            action: #selector(saveUser),
            for: .touchUpInside)
    }
    
    @objc
    private func saveUser() {
        viewModel.saveUser(savedUser: currentUser)
    }
    
    func wireRemoveUser() {
        removeUserButton.addTarget(
            self,
            action: #selector(removeUser),
            for: .touchUpInside)
    }
    
    @objc
    private func removeUser() {
        viewModel.removeUser(removedUser: currentUser)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}

//
//MARK: - Dynamic behavior
//
extension UserProfileRootView {
    func bindViewModelToViews() {
        bindViewModelToSaveUserButton()
        bindViewModelToRemoveUserButton()
    }
    
    
    func bindViewModelToSaveUserButton() {
        enablingSaveUserButton()
        setingUpBackgroungColorSaveUserButton()
    }
    
    private func enablingSaveUserButton() {
        viewModel
            .saveUserButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(saveUserButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func setingUpBackgroungColorSaveUserButton() {
        viewModel
            .saveUserButtonColor
            .asDriver(onErrorJustReturn: .appGreen)
            .drive(saveUserButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToRemoveUserButton() {
        viewModel
            .removeUserButtonHidden
            .asDriver(onErrorJustReturn: true)
            .drive(removeUserButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}




private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 10000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension UserProfileRootView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {

            let identifier = "stopAnnotation"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if pinView == nil {

                //Create a plain MKAnnotationView if using a custom image...
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)

                pinView!.canShowCallout = true
                pinView!.image = #imageLiteral(resourceName: "marker25")
            }
            else {
                //Unrelated to the image problem but...
                //Update the annotation reference if re-using a view...
                pinView!.annotation = annotation
            }

            return pinView
        }
        return nil
    }
}
