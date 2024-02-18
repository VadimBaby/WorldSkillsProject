//
//  DeviceMotionMonitor.swift
//  RediExpress
//
//  Created by Вадим Мартыненко on 18.02.2024.
//

import Foundation
import CoreMotion

final class DeviceMotionMonitor {
    @Published var angle: Double = 0
    
    static let instance = DeviceMotionMonitor()
    
    private let motionManager = CMMotionManager()
    
    init() {
        motionManager.deviceMotionUpdateInterval = 0.3
        motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let motion else { return }
            
            let roll = motion.attitude.roll
            
            let angle: Double = roll / 180 * .pi
            DispatchQueue.main.async {
                self.angle = angle
            }
        }
    }
}
