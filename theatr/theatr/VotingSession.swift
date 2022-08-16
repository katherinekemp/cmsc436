//
//  VotingSession.swift
//  theatr
//
//  Created by Katherine Kemp on 4/21/22.
//

import Foundation

enum States {
    case welcome // welcome page shown only on first opening the app
    case date // date selection page
    case voting // movie list is displayed and user can click vote
    case waiting // waiting for user to select vote again or end session
    case save // asking if results should be saved
    case results // results page with start new session button
}

class Result: Hashable {
    var time: Date
    var movie: Movie?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
    
    static func == (lhs: Result, rhs: Result) -> Bool {
        if lhs.time == rhs.time && lhs.movie == rhs.movie {
            return true
        }
        return false
    }
    
    init(movie: Movie?, time: Date) {
        self.movie = movie
        self.time = time
    }
}

class VotingSession: ObservableObject {
    @Published var results: [Result]
    @Published var state: States
    var movieDate: Date
    var votes: Dictionary<Movie, Int>
    var time: Date
    
    init() {
        self.votes = [:]
        self.results = []
        self.time = Date()
        self.movieDate = Date()
        self.state = .welcome
    }
    
    func setMovieDate(date: Date) {
        self.movieDate = date
    }
    
    func updateState(newState: States) {
        self.state = newState
    }
    
    func reset(save: Bool) {
        
        // Calculate winner of current session
        var winner: Movie? = nil
        var max = 0
        
        for (key, val) in votes {
            if val > max {
                max = val
                winner = key
            }
        }
        
        // Update results with most recent result if desired
        if save {
            results = [Result(movie: winner, time: self.time)] + results
        }
        
        // Reset for next session
        self.votes = [:]
    }
    
    func vote(movie: Movie) {
        if votes[movie] == nil {
            votes[movie] = 1
        } else {
            votes[movie]! += 1
        }
    }
}

