//
//  MyShieldConfiguration.swift
//  UnUpset
//
//  Created by Андрей Степанов on 10.03.2025.
//

import ManagedSettings
import ManagedSettingsUI

class MyShieldConfiguration: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return ShieldConfiguration(backgroundBlurStyle: .light, backgroundColor: .first, icon: .unUpset)
    }
}
