//
//  RegionsViewModel.swift
//  RegionsListImproved
//
//  Created by Anup Kuriakose on 15/11/2023.
//

import Foundation

struct RegionsData {
    let name: String
    var isSelected: Bool
}

class RegionsViewModel {
    
    var regionsBaseData: [RegionsData] = []
    var regionsFilteredLoadingData: [RegionsData] = []
    
    func initializeRegionsData(){
    regionsBaseData = []
        for regionName in regionsNames.sorted() {
           let regionData = RegionsData(name: regionName, isSelected: false)
            regionsBaseData.append(regionData)
        }
    }
    
    func updateFilteredLoadingData(index: Int){
        let tempIsSelectedValue = regionsFilteredLoadingData[index].isSelected
        //initializeRegionsData()
        for (indexOfRegions, _) in regionsFilteredLoadingData.enumerated() {
            if indexOfRegions == index {
                regionsFilteredLoadingData[indexOfRegions].isSelected = !tempIsSelectedValue
            } else{
                regionsFilteredLoadingData[indexOfRegions].isSelected = false
            }
        }
    }
    
    func updateRegionsBaseData(){
        initializeRegionsData()
        for regionsFilteredLoadingDatum in regionsFilteredLoadingData {
            let regionName = regionsFilteredLoadingDatum.name
            let isSelectedValue = regionsFilteredLoadingDatum.isSelected
            var iterationIndex = 0
            
            repeat{
                if regionsBaseData[iterationIndex].name == regionName {
                    regionsBaseData[iterationIndex].isSelected = isSelectedValue
                }
                iterationIndex += 1
            } while(regionsBaseData[iterationIndex-1].name != regionName)
        }
    }
    
    func findSelectedRegion() -> (selectedRegionFound: Bool, selectedIndex:Int) {
        var selectedIndex = 0
        var selectedRegionFound = false
        repeat {
                // Check if we've found a selected item
                if selectedIndex < regionsBaseData.count && regionsBaseData[selectedIndex].isSelected {
                    selectedRegionFound = true
                    break // Exit the loop
                }
            selectedIndex += 1
            } while selectedIndex < regionsBaseData.count
       return (selectedRegionFound, selectedIndex)
    }
    
    func filterRegions(searchText: String) -> [RegionsData] {
        regionsFilteredLoadingData = regionsBaseData
        if searchText.isEmpty{
            return regionsFilteredLoadingData
        }else{
            return regionsFilteredLoadingData.filter { region in
                region.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

}
