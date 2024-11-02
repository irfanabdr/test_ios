//
//  CourseDetalViewController.swift
//  Quipper Test
//
//  Created by Irfan on 02/11/24.
//

import UIKit
import AVKit
import AVFoundation
import Combine

class CourseDetalViewController: UIViewController {
    
    static let segue = "toDetail"
    
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPresenterName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    var viewModel: CourseDetailViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var playerViewController: AVPlayerViewController?
    private var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = viewModel else { return }
        
        navigationItem.title = viewModel.selectedTitle
        
        viewModel.$course
            .receive(on: RunLoop.main)
            .sink { [weak self] course in
                self?.updateView(with: course)
            }
            .store(in: &cancellables)
        
        viewModel.fetchCourse()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        releasePlayer()
    }
    
    private func updateView(with course: Course?) {
        guard let course = course else { return }
        
        labelTitle.text = course.title
        labelPresenterName.text = course.presenterName
        labelDescription.text = course.description
        initializePlayer(videoUrl: course.videoURL)
    }
    
    private func initializePlayer(videoUrl: String) {
        guard let url = URL(string: videoUrl) else { return }
        
        playerViewController = AVPlayerViewController()
        player = AVPlayer(url: url)
        
        guard let playerViewController = playerViewController else { return }
        
        playerViewController.player = player
        addChild(playerViewController)
        videoContainerView.addSubview(playerViewController.view)
        
        playerViewController.view.frame = videoContainerView.bounds
        playerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerViewController.didMove(toParent: self)
    }
    
    private func releasePlayer() {
        player?.pause()
        
        playerViewController?.willMove(toParent: nil)
        playerViewController?.view.removeFromSuperview()
        playerViewController?.removeFromParent()
        
        player = nil
        playerViewController = nil
    }
}
