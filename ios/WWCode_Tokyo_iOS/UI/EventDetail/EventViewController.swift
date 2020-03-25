import UIKit
import PureLayout

class EventViewController: UIViewController {
    
    private var dateLabel: UILabel!
    private var timeLabel: UILabel!
    
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    private var venueName: UILabel!
    private var venueAddress: UILabel!
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!

    private var didSetupConstraints = false
    private var event: Event!
    
    init(event: Event) {
        super.init(nibName: nil, bundle: nil)
        self.event = event
        view.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        configureNavigationBar()
        addSubviews()
        configureSubviews()
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            scrollView.autoPinEdgesToSuperviewSafeArea()
            contentView.autoPinEdgesToSuperviewEdges()
            contentView.autoMatch(.width, to: .width, of: view)
            
            dateLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: 15.0)
            dateLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: 15.0)
            dateLabel.autoPinEdge(.right, to: .left, of: timeLabel)

            timeLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: 15.0)
            timeLabel.autoPinEdge(.left, to: .right, of: dateLabel)
            timeLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: -15.0)

            titleLabel.autoPinEdge(.top, to: .bottom, of: dateLabel)
            titleLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: 15.0)
            titleLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: -15.0)
            
            descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel)
            descriptionLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: 15.0)
            descriptionLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: -15.0)
            descriptionLabel.numberOfLines = 0
            
            venueName.autoPinEdge(.top, to: .bottom, of: descriptionLabel)
            venueName.autoPinEdge(.left, to: .left, of: contentView, withOffset: 15.0)
            venueName.autoPinEdge(.right, to: .right, of: contentView, withOffset: -15.0)
            
            venueAddress.autoPinEdge(.top, to: .bottom, of: venueName)
            venueAddress.autoPinEdge(.left, to: .left, of: contentView, withOffset: 15.0)
            venueAddress.autoPinEdge(.right, to: .right, of: contentView, withOffset: -15.0)
            venueAddress.autoPinEdge(toSuperviewEdge: .bottom, withInset: 60, relation: .greaterThanOrEqual)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    func initializeViews() {
        scrollView = UIScrollView.newAutoLayout()
        contentView = UIView.newAutoLayout()
        
        dateLabel = UILabel.newAutoLayout()
        timeLabel = UILabel.newAutoLayout()
        titleLabel = UILabel.newAutoLayout()
        descriptionLabel = UILabel.newAutoLayout()
        venueName = UILabel.newAutoLayout()
        venueAddress = UILabel.newAutoLayout()
    }
    
    func addSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(venueName)
        contentView.addSubview(venueAddress)
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    
    func configureSubviews() {
        view.backgroundColor = .white
        contentView.backgroundColor = .white
    }
    
    func configureNavigationBar() {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let startDateTime = startDateFormatter.date(from: event.startDateTime)!
        
        let dateLabelFormatter = DateFormatter()
        dateLabelFormatter.dateFormat = "MMM d, E"
        
        dateLabel.text = dateLabelFormatter.string(from: startDateTime)
        
        let endDateTime = startDateFormatter.date(from: event.endDateTime)!
        let timeLabelFormatter = DateFormatter()
        timeLabelFormatter.dateFormat = "HH:mm"
        
        timeLabel.text = "\(timeLabelFormatter.string(from: startDateTime)) - \(timeLabelFormatter.string(from: endDateTime))"
        
        titleLabel.text = event.name
        descriptionLabel.text = event.description
        
        venueName.text = event.venue.name
        venueAddress.text = "\(event.venue.address) \(event.venue.city)"
        
        do {
            let data = event.description.data(using: .utf8)!
            let description = try NSAttributedString(
                data: data,
                options: [ .documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue ],
                documentAttributes: nil)
            
            descriptionLabel.attributedText = description
        } catch {
            // noop
        }
    }
}
