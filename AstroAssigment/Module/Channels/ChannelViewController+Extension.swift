//
//  ChannelViewController+Extension.swift
//  AstroAssigment
//
//  Created by hungnguyen on 11/4/17.
//  Copyright © 2017 hungnguyen. All rights reserved.
//

import Foundation

extension ChannelsViewController {
	func sort(by sortType: SortType, with channels: [ChannelsResponse.Channel]) -> [ChannelsResponse.Channel] {
		switch sortType {
		case .channelNumber:
			return channels.sorted { (lhs, rhs)  in
				lhs.channelStbNumber < rhs.channelStbNumber
			}
		case .name:
			return channels.sorted { (lhs, rhs)  in
				lhs.channelTitle.localizedCaseInsensitiveCompare(rhs.channelTitle) == ComparisonResult.orderedAscending
			}
		}
	}
}
