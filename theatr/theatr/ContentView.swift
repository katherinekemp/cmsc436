//
//  ContentView.swift
//  theatr
//
//  Created by Katherine Kemp on 2/24/22.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject var movies: MovieList = MovieList()
    @StateObject var locationManager: LocationManager = LocationManager()
    @StateObject var votingSession: VotingSession = VotingSession()
    
    var body: some View {
        VotingView().environmentObject(movies).environmentObject(locationManager).environmentObject(votingSession)
    }
}

struct VotingView: View {
    @EnvironmentObject var movies: MovieList
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var votingSession: VotingSession
    @State var movieDate: Date = Date()
    
    var body: some View {
        if votingSession.state == States.welcome {
            VStack {
                Text("Theatr: The Movie-Finder!").font(.title)
                Button("Start New Voting Session") {
                    votingSession.updateState(newState: States.date)
                }.voteButton()
            }
        } else if votingSession.state == States.date {
            VStack {
                Text("Theatr: The Movie-Finder!").font(.title)
                Text("Select Movie Date: ")
                DatePicker(
                    "Movie Date",
                    selection: $movieDate,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                ).datePickerStyle(.wheel) .labelsHidden()
                Button("Continue") {
                    votingSession.updateState(newState: States.voting)
                    votingSession.setMovieDate(date: movieDate)
                }.voteButton()
            }
        } else if votingSession.state == States.voting {
            VStack {
                Text("Theatr: The Movie-Finder!").font(.title)
                Divider()
                VStack {
                    Text("Pull down to refresh and find movies near you!")
                    MovieView().environmentObject(movies).environmentObject(locationManager)
                        .environmentObject(votingSession)
                }
            }
        } else if votingSession.state == States.waiting {
            VStack {
                Text("Pass the Phone").font(.largeTitle)
                Button("Vote!") {
                    votingSession.updateState(newState: States.voting)
                }.voteButton()
                Button("End Session") {
                    votingSession.updateState(newState: States.save)
                }.voteButton()
            }
        } else if votingSession.state == States.save {
                VStack {
                    Text("Save Results?").font(.largeTitle)
                    HStack {
                        Button("No") {
                            votingSession.reset(save: false)
                            votingSession.updateState(newState: States.results)
                        }.voteButton()
                        Button("Yes") {
                            votingSession.reset(save: true)
                            votingSession.updateState(newState: States.results)
                        }.voteButton()
                    }
                }
            } else if votingSession.state == States.results {
                VStack {
                    Text("Theatr: The Movie-Finder!").font(.title)
                    ResultView().environmentObject(votingSession)
                    Button("Start New Voting Session") {
                        votingSession.updateState(newState: States.date)
                    }.voteButton()
                }
            } else {
                VStack {
                    Text("Theatr: The Movie-Finder!").font(.title)
                    Text("ERROR").font(.title)
                }
            }
    }
}

struct MovieView: View {
    @EnvironmentObject var movies: MovieList
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var votingSession: VotingSession
    
    var body: some View {
        
        return VStack {
            List(movies.movies, id:\.self) { movie in
                ZStack {
                    Rectangle().fill(Color.green).cornerRadius(15)
                    VStack {
                        Text(movie.title).font(.headline).fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                        Text(movie.location).fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                        Text(formatTime(time: movie.time)).fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                        
                        Button("Vote") {
                            votingSession.vote(movie: movie)
                            votingSession.updateState(newState: States.waiting)
                        }.voteButton()
                    }.padding()
                }.padding()
            }.refreshable {
                let coord = locationManager.location?.coordinate
                let lat = coord?.latitude ?? 0
                let lon = coord?.longitude ?? 0
                
                let _ = movies.updateMovies(currDate: votingSession.movieDate, lon: lon, lat: lat)
            }.onAppear {
                let coord = locationManager.location?.coordinate
                let lat = coord?.latitude ?? 0
                let lon = coord?.longitude ?? 0
                
                let _ = movies.updateMovies(currDate: votingSession.movieDate, lon: lon, lat: lat)
            }
        }
    }
}

struct ResultView: View {
    @EnvironmentObject var votingSession: VotingSession

    var body: some View {
        VStack {
            List(votingSession.results, id:\.self) { result in
               ZStack {
                   Rectangle().fill(Color.green).cornerRadius(15)
                   VStack {
                       Text("Session on \(formatTime(time: result.time))").fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                       Divider()
                       Text(result.movie?.title ?? "No Movie Selected").font(.headline).fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                       Text("at \(result.movie?.location ?? "--")").fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                       Text("on \(formatTime(time: result.movie?.time ?? Date()))").fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                
                       HStack {
                           Text("Share a link to purchase tickets: ")
                           Button(action: {shareResult(link: result.movie?.ticketLink ?? "")}) {
                               Image(systemName: "square.and.arrow.up")
                                  .resizable()
                                  .aspectRatio(contentMode: .fit)
                                  .frame(width: 20, height: 20)
                           }.padding()
                       }
                   }.padding()
               }.padding()
            }
        }
    }
}


extension Button {
    func voteButton() -> some View {
        self.buttonStyle(DefaultButtonStyle())
            .padding()
            .font(.headline)
            .foregroundColor(.black)
            .background(Color.red.cornerRadius(20))
    }
}


func shareResult(link: String) {
    let activityViewController = UIActivityViewController(activityItems: [URL(string: link) ?? "ERROR"], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
}


func formatTime(time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("EEEE MMMMd h:m")
    return dateFormatter.string(from: time)
}
