//
//  Path.swift
//
//
//  Created by Giovanni Noa on 4/29/20.
//

// MARK: - Path
/// Enum containing the sub-path for specifying an endpoint within the Ergast API.
enum Path {
    private static let basePath = "/api/f1" 
    
    /// Circuits (all, specific season)
    case circuits(Season?)
    
    /// Constructors(all, specific season)
    case constructors(Season?)
    
    /// Constructor Standings (all, specific season)
    case constructorStandings(Season?)
    
    /// Drivers (all, specific season).
    case drivers(Season?)
    
    /// Driver Standings.
    case driverStandings(Season?)
    
    /// Lap Times.
    case lapTimes(_ season: Season, race: String, lap: String?)
    
    /// Pit Stops.
    case pitStops(Season?, String)
    
    /// Race Schedule.
    case raceSchedule(Season?)
    
    /// Race Results.
    case raceResults(Season)
    
    /// Race Standings (all, specific season).
    case raceStandings(Season?)
    
    /// Seasons throughout history.
    case seasons
    
    /// Qualifying Results for a given year.
    case qualifyingResults(Season)
}

extension Path {
    /// Function that generates the path for an endpoint within the Ergast API.
    /// - Parameter season: Season enum case, specified by an Int, which indicates to fetch data for a given year (1950-2020).  Data for historical seasons will be fetched if nil.
    /// - Returns: String to be added to the Endpoint path.
    private func subPath() -> String {
                
        switch self {
        case .circuits(let year):
            return "\(year?.query ?? "")/circuits.json"
        case .constructors(let year):
            return "\(year?.query ?? "")/constructors.json"
        case .constructorStandings(let year):
            return "\(year?.query ?? "")/constructorStandings.json"
        case .drivers(let year):
            return "\(year?.query ?? "")/drivers.json"
        case .driverStandings(let year):
            return "\(year?.query ?? "")/driverStandings.json"
        case .lapTimes(let season, let race, let lap):
            if let lap = lap {
                return "\(season.query ?? "")/\(race)/laps/\(lap).json"
            }
            
            return "\(season.query ?? "")/\(race)/laps.json"
        case .pitStops(let year, let race):
            return "\(year?.query ?? "")/\(race)/pitstops.json"
        case .raceSchedule(let year):
            return "\(year?.query ?? "").json"
        case .raceResults(let year):
            return "\(year)/results.json"
        case .raceStandings(let year):
            return "\(year?.query ?? "")/results.json"
        case .seasons:
            return "/seasons.json"
        case .qualifyingResults(let year):
            return "\(year)/qualifying.json"
        }
    }
    
    /// Constructs a path.
    /// - Parameter season: Season enum case, specified by an Int, which indicates to fetch data for a given year (1950-2020). All historical seasons will be fetched if nil.
    /// - Returns: String representing a URL path.
    func urlPath(for season: Season?,
                 round: String?,
                 lap: String?) -> String {
        return Path.basePath + subPath()
    }
    
    /// Returns a Decodable type for a given endpoint.
    var decodingType: Decodable.Type {
        switch self {
        case .circuits(_): return Circuits.self
        case .constructors: return Constructors.self
        case .lapTimes(_, _, _): return Laps.self
        case .seasons: return Seasons.self
        case .pitStops: return PitStops.self
        case .raceResults: return RaceResults.self
        case .raceSchedule: return RaceSchedule.self
        case .qualifyingResults: return QualifyingResults.self
        default: fatalError("Must provide Decodable type for enum case")
        }
    }
}
