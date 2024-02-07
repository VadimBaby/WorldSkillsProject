//
//  OnboardingViewModel_Tests.swift
//  RediExpress_Tests
//
//  Created by Вадим Мартыненко on 07.02.2024.
//

import XCTest
@testable import RediExpress

final class OnboardingViewModel_Tests: XCTestCase {
    
    let queue: [QueueItemModel] = [
        .init(id: "QuickDelivery", image: "QuickDelivery", title: "Quick Delivery At YourDoorstep", subtitle: "Enjoy quick pick-up and delivery toyour destination"),
        .init(id: "FlexiblePayment", image: "FlexiblePayment", title: "Flexible Payment", subtitle: "Different modes of payment eitherbefore and after delivery withoutstress"),
        .init(id: "RealTimeTracking", image: "RealTimeTracking", title: "Real-time Tracking", subtitle: "Track your packages/items from the comfort of your home till final destination")
    ]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Изображение и текста из очереди извлекается правильно (в порядке добавления в очередь).
    
    func test_OnboardingViewModel_ImagesAndTextsExtractedFromQueueSuccess() {
        let viewModel = OnboardingView.ViewModel(watchedQueueItemId: nil, customQueue: queue)
        
        var i = viewModel.queue.count
        
        while true {
            guard let firstElementQueue = viewModel.queue.first else { return }
            
            guard i != 0 else { XCTFail(); return }
            
            viewModel.next()
            i -= 1
            
            guard let currentQueueItem = viewModel.currentQueueItem else { return }
            
            XCTAssertEqual(currentQueueItem.id, firstElementQueue.id)
        }
    }
    
    // Корректное извлечение элементов из очереди (количество элементов в очереди уменьшается на единицу).
    
    func test_OnboardingViewModel_CorrectExtractElementsFromQueue() {
        let viewModel = OnboardingView.ViewModel(watchedQueueItemId: nil, customQueue: queue)
        
        var i = viewModel.queue.count
        
        while true {
            guard !viewModel.queue.isEmpty else { return }
            
            guard i != 0 else { XCTFail(); return }
            
            let oldCount = viewModel.queue.count
            
            viewModel.next()
            i -= 1
            
            let newCount = viewModel.queue.count
            
            let difference = oldCount - newCount
            
            XCTAssertEqual(difference, 1)
        }
    }
    
    // В случае, когда в очереди несколько картинок, устанавливается правильная надпись на кнопке.
    
    func test_OnboardingViewModel_IfQueueHasSeveralElementsThenSetRightButton() {
        let viewModel = OnboardingView.ViewModel(watchedQueueItemId: nil, customQueue: queue)
        
        var i = viewModel.queue.count
        
        while true {
            guard viewModel.queue.count > 1 else { return }
            
            guard i > 1 else { XCTFail(); return }
    
            XCTAssertEqual(viewModel.showSkipAndNextButton, true)
            
            viewModel.next()
            i -= 1
        }
    }
    
    // Случай, когда очередь пустая, надпись на кнопке должна измениться на "Sing Up".
    
    func test_OnboardingViewModel_IfQueueIsEmptyThenShowSkipAndNextButtonShouldEqualFalse() {
        let viewModel = OnboardingView.ViewModel(watchedQueueItemId: nil, customQueue: [])
        
        XCTAssertFalse(viewModel.showSkipAndNextButton)
    }
    
    // Если очередь пустая и пользователь нажал на кнопку “Sing in”, происходит открытие пустого экрана «Holder» приложения. Если очередь не пустая – переход отсутствует.
    
    func test_OnboardingViewModel_IfQueueIsEmptyAndUserPressSignInThenHolderIsOpenedElseQueueIsNotEmptyThenHolderIsNotOpened() {
        let viewModel = OnboardingView.ViewModel(watchedQueueItemId: nil, customQueue: [])
        
        viewModel.next()
        
        XCTAssertNil(viewModel.currentQueueItem)
        
        let viewModel2 = OnboardingView.ViewModel(watchedQueueItemId: nil, customQueue: queue)
        
        viewModel2.next()
        
        XCTAssertNotNil(viewModel2.currentQueueItem)
    }
}
