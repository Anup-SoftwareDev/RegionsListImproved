//
//  RegionsViewModel.swift
//  RegionsListImproved
//
//  Created by Anup Kuriakose on 15/11/2023.
//

import Foundation

// Structure to store region data
struct RegionsData {
    let name: String
    var isSelected: Bool
}

class RegionsViewModel {
    
    // Arrays to store base and filtered region data
    var regionsBaseData: [RegionsData] = []
    var regionsFilteredLoadingData: [RegionsData] = []
    
    // Resets and initializes the region data
    func resetAllRegionsData() {
        initializeRegionsData()
        regionsFilteredLoadingData = regionsBaseData
    }
    
    // Initializes the regions data with names and default selection status
    func initializeRegionsData() {
        regionsBaseData = []
        for regionName in regionsNames.sorted() {
            let regionData = RegionsData(name: regionName, isSelected: false)
            regionsBaseData.append(regionData)
        }
    }
    
    // Updates the selection status of a region in the filtered data
    func updateFilteredLoadingData(index: Int) {
        let tempIsSelectedValue = regionsFilteredLoadingData[index].isSelected
        for (indexOfRegions, _) in regionsFilteredLoadingData.enumerated() {
            if indexOfRegions == index {
                regionsFilteredLoadingData[indexOfRegions].isSelected = !tempIsSelectedValue
            } else {
                regionsFilteredLoadingData[indexOfRegions].isSelected = false
            }
        }
    }
    
    // Updates the base regions data to reflect changes in the filtered data
    func updateRegionsBaseData() {
        initializeRegionsData()
        for regionsFilteredLoadingDatum in regionsFilteredLoadingData {
            let regionName = regionsFilteredLoadingDatum.name
            let isSelectedValue = regionsFilteredLoadingDatum.isSelected
            var iterationIndex = 0
            
            repeat {
                if regionsBaseData[iterationIndex].name == regionName {
                    regionsBaseData[iterationIndex].isSelected = isSelectedValue
                }
                iterationIndex += 1
            } while(regionsBaseData[iterationIndex-1].name != regionName)
        }
    }
    
    // Finds the selected region in the base data
    func findSelectedRegion() -> (selectedRegionFound: Bool, selectedIndex: Int) {
        var selectedIndex = 0
        var selectedRegionFound = false
        repeat {
            if selectedIndex < regionsBaseData.count && regionsBaseData[selectedIndex].isSelected {
                selectedRegionFound = true
                break
            }
            selectedIndex += 1
        } while selectedIndex < regionsBaseData.count
        return (selectedRegionFound, selectedIndex)
    }
    
    // Filters regions based on the search text
    func filterRegions(searchText: String) -> [RegionsData] {
        regionsFilteredLoadingData = regionsBaseData
        if searchText.isEmpty {
            return regionsFilteredLoadingData
        } else {
            return regionsFilteredLoadingData.filter { region in
                region.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
