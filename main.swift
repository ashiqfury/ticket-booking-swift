print("WELCOME TO BOOKMYMOVIE")

let ADMIN_SECRET = "12345"

enum Language {
    case Tamil, English, Hindi
}

enum Genre {
    case Action, Horror, Comedy, Romance
}

enum Time {
    case Morning, Afternoon, Evening, Night
}

func getIntegerInput(name: String) -> Int {
    var value = 0
    print("Enter \(name): ")
    if let nameStr = readLine() {
        value = Int(nameStr)!
    }
    return value
}

func getStringInput(name: String) -> String {
    var value = ""
    print("Enter \(name): ")
    if let val = readLine() {
        value = val
    }
    return value
}

class Movie {
    static var movieId = 0
    let id: Int
    let name: String
    let genre: Genre
    let language: Language
    let time: Time
    let price: Int
    
    init(name: String, genre: Genre, language: Language, time: Time, price: Int) {
        Movie.movieId += 1
        self.id = Movie.movieId
        self.name = name
        self.genre = genre
        self.language = language
        self.time = time
        self.price = price
    }
}

let MOVIES = [
    Movie(name: "Titanic", genre: Genre.Romance, language: Language.Tamil, time: Time.Evening, price: 100),
    Movie(name: "Jurassic Park", genre: Genre.Action, language: Language.English, time: Time.Morning, price: 150),
    Movie(name: "Finding Nemo", genre: Genre.Comedy, language: Language.Hindi, time: Time.Night, price: 200),
]

class Theatre {
    static var theatreId = 0
    let id: Int
    let name: String
    let location: String
    let capacity: Int
    var movies: [Movie]
    var availableSeats: Int
    
    var seats: Int {
        get {
            return availableSeats
        }
        set(seatCount) {
            availableSeats -= seatCount
        }
    }
    
    init(name: String, location: String, capacity: Int, movies: [Movie] = MOVIES) {
        Theatre.theatreId += 1
        self.id = Theatre.theatreId
        self.name = name
        self.location = location
        self.capacity = capacity
        self.availableSeats = capacity
        self.movies = movies
    }
    
    func showAllMovies() {
        for movie in movies {
            print("""
            ******************************************
                Movie id: \(movie.id)
                Movie name: \(movie.name)
                Movie language: \(movie.language)
                Movie genre: \(movie.genre)
                Movie time: \(movie.time)
            *******************************************
            """)
        }
    }
    func showAllMoviesNames() {
        for movie in movies {
            print("\(movie.id). \(movie.name)")
        }
    }
    
    func addMovie() {
        let movieName = "Baahubali " + String(Int.random(in: 1...20))
        movies.append(Movie(name: movieName, genre: Genre.Comedy, language: Language.Hindi, time: Time.Night, price: 200))
    }
    
    func removeMovie(item: Int) {
        self.movies = movies.filter { $0.id != item }
    }
    func removeMovie(item: String) {
        self.movies = movies.filter { $0.name != item }
    }
    func showTheatreDetails() {
        print("""
        ***********************************
            Id: \(id)
            Name: \(name)
            Location: \(location)
            Total seats: \(capacity)
            Seats available: \(seats)
            Movies: \(movies.map({$0.name}).joined(separator: ", "))
        ***********************************
        """)
    }
}


let THEATRES = [
    Theatre(name: "Ram", location: "Tirunelveli", capacity: 10),
    Theatre(name: "Muthu Ram", location: "Tenkasi", capacity: 15),
]

class Details {
    var theatres = THEATRES
    
    func showAllTheatre() {
        for theatre in theatres {
            theatre.showTheatreDetails()
        }
    }
    
    func showAllTheatreNames() {
        for theatre in theatres {
            print("\(theatre.id). \(theatre.name)")
        }
    }
    
    func addTheatre(name: String, location: String, totalSeats: Int) {
        theatres.append(Theatre(name: name, location: location, capacity: totalSeats, movies: []))
        print("Theatre \(name) is successfully added!")
    }
}

var detail = Details()
var choice = 0

struct User {
    var name: String
    var phoneNumber: String
    
    func showUser() {
        print("""
            Name: \(name)
            Phone number: \(phoneNumber)
        """)
    }
}

class BookMyMovie {
    let noOfSeats: Int
    let theatreId: Int
    let movieId: Int
    var registredUser: User?
//    var theatres = THEATRES
    var details = Details()
    
    init(noOfSeats: Int, theatreId: Int, movieId: Int, user: User? = nil) {
        self.noOfSeats = noOfSeats
        self.theatreId = theatreId
        self.movieId = movieId
        self.registredUser = user
    }
    
    func bookTicket() {
        if registredUser != nil { // check if user is authorized or not
            for theatre in details.theatres where theatre.id == theatreId { // checking the theatre
                for movie in theatre.movies where movie.id == movieId { // check movie is available in that theatre
                    if theatre.seats > 0 && theatre.seats >= noOfSeats { // check seat availablility
                        print("""
                            Booking successful! 🔥
                            
                            Details:
                            User name: \(registredUser!.name)
                            Phone number: \(registredUser!.phoneNumber)
                            Theatre id: \(theatre.id)
                            Theatre name: \(theatre.name)
                            Location: \(theatre.location)
                            Movie id: \(movie.id)
                            Movie name: \(movie.name)
                            Genre: \(movie.genre)
                            Language: \(movie.language)
                            Ticket Price: Rs. \(movie.price)/-
                            Total Price: Rs. \(movie.price * noOfSeats)/-
                            Time: \(movie.time)

                            Thank you...!
                        """)
                        theatre.seats = noOfSeats
                        return
                    } else {
                        print("Seats unavailable! Available seats in \(theatre.name) is \(theatre.seats)")
                        return
                    }
                }
                print("\(movieId) is not available in \(theatre.name) theatre!")
                return
            }
            print("Theatre \(theatreId) not found!")
        }
        else {
            print("You cant book tickets. Please login!")
        }
    }
}

// for adding users details
var user: User?

// getting booking details and book the ticket
func makeDecision(choice: Int) {
    outerloop: switch(choice) {
        case 1:
            detail.showAllTheatre()
        case 2:
            detail.showAllTheatreNames()
            print("Enter theatre id: ")
            if let idStr = readLine() {
                if let id = Int(idStr) {
                    for theatre in detail.theatres where theatre.id == id {
                        theatre.showAllMovies()
                        break outerloop
                    }
                    print("Invalid theatre id!")
                }
            }
        case 3:
            print("Enter theatre id: ")
            detail.showAllTheatreNames()
            if let theatreIdStr = readLine() {
                if let theatreId = Int(theatreIdStr) {
                    if theatreId > detail.theatres.count || theatreId < 1 {
                        print("Invalid theatre id")
                        break
                    }
                    print("Movies in \(detail.theatres[theatreId - 1].name) theatre: ")
                    detail.theatres[theatreId - 1].showAllMoviesNames()
                    print("Enter movie id: ")
                    if let movieIdStr = readLine() {
                        if let movieId = Int(movieIdStr) {
                            if movieId > detail.theatres[theatreId - 1].movies.count || theatreId < 1 {
                                print("Invalid movie id")
                                break
                            }
                            print("Enter number of seats: ")
                            if let seatStr = readLine() {
                                if let seat = Int(seatStr) {
                                    let book = BookMyMovie(noOfSeats: seat, theatreId: theatreId, movieId: movieId, user: user)
                                    book.bookTicket()
                                }
                            }
                        }
                    }
                }
            }
            
        default:
            break
            
    }
}

func userInitialChoices() {
    repeat {
        print("""
        \n
            1. show theatres list
            2. show movie list
            3. book ticket
            4. exit
        """)
        if let c = readLine() {
            if let intc = Int(c) {
                choice = intc
            }
        }
        makeDecision(choice: choice)

    } while(choice != 4)
}

struct Admin {
    
    func adminAddNewTheatre() {
        print("ADD A NEW THEATRE: ")
        print("\nEnter theatre name: ")
        if let theatreName = readLine() {
            print("Enter location: ")
            if let location = readLine() {
                print("Enter total seat capacity: ")
                if let capacityStr = readLine() {
                    if let capacity = Int(capacityStr) {
                        detail.addTheatre(name: theatreName, location: location, totalSeats: capacity)
                    }
                }
            }
        }
    }
    
    func adminRemoveTheatre() {
        detail.showAllTheatreNames()
        let theatreId = getIntegerInput(name: "theatre id")
        if (theatreId < 0 || theatreId > detail.theatres.count) {
            print("Invalid theatre id")
            return
        }
        detail.theatres = detail.theatres.filter({ $0.id != theatreId })
        print("Successfully removed!")
    }
    
    func adminAddNewMovie() {
        detail.showAllTheatreNames()
        let theatreId = getIntegerInput(name: "theatre id")
        if (theatreId < 0 || theatreId > detail.theatres.count) {
            print("Invalid theatre id")
            return
        }
//        let movieName = getStringInput(name: "movie name")
//        let genre = Genre.Action
//        let language = Language.English
//        let time = Time.Night
//        let price = getIntegerInput(name: "ticket price")
////        Movie(name: movie, genre: <#T##Genre#>, language: <#T##Language#>, time: <#T##Time#>, price: <#T##Int#>)
//        print("""
//            1. \(Language.Tamil)
//            2. \(Language.English)
//            3. \(Language.Hindi)
//        """)
//        print("Enter genre id: ")
    }
    
    func adminRemoveMovie() {
        detail.showAllTheatreNames()
        let theatreId = getIntegerInput(name: "theatre id")
        if (theatreId < 0 || theatreId > detail.theatres.count) {
            print("Invalid theatre id")
            return
        }
        detail.theatres[theatreId - 1].showAllMoviesNames()
        let movieId = getIntegerInput(name: "movie id")
        if (movieId < 0 || movieId > detail.theatres[theatreId - 1].movies.count) {
            return
        }
        detail.theatres[theatreId - 1].movies = detail.theatres[theatreId - 1].movies.filter({$0.id != movieId})
        print("Successfully removed!")
    }
    
    func adminMakeDecision() {
        outerloop: switch(choice) {
            // list all theatre
            case 1:
                detail.showAllTheatre()
                
            // list all movies
            case 2:
                detail.showAllTheatreNames()
                print("Enter theatre id: ")
                if let idStr = readLine() {
                    if let id = Int(idStr) {
                        for theatre in detail.theatres where theatre.id == id {
                            theatre.showAllMovies()
                            break outerloop
                        }
                        print("Invalid theatre id!")
                    }
                }
            case 3:
                adminAddNewTheatre()
            case 4:
                adminRemoveTheatre()
            case 5:
                adminAddNewMovie()
            case 6:
                adminRemoveMovie()
            default:
                break
        }
                

    }
    
    
    func adminInitialChoices() {
        repeat {
            print("""
            \n
                1. show theatres list
                2. show movie list
                3. add a theatre
                4. remove a theatre
                5. add a movie
                6. remove a movie
                7. exit
            """)
            if let c = readLine() {
                if let intc = Int(c) {
                    choice = intc
                }
            }
            adminMakeDecision()

        } while(choice != 7)
    }
    
}

print("""
    1. User
    2. Admin
""")
if let choiceStr = readLine() {
    if let choiceInt = Int(choiceStr) {
        switch(choiceInt) {
            case 1:
                let name = getStringInput(name: "your name")
                let phoneNumber = getStringInput(name: "your phone number")
                user = User(name: name, phoneNumber: phoneNumber)
                userInitialChoices()
            case 2:
                print("Enter admin password: ")
                if let inputPassword = readLine() {
                    if inputPassword == ADMIN_SECRET {
                        let admin = Admin()
                        admin.adminInitialChoices()
                    } else {
                        print("Password invalid!")
                        break
                    }
                }
            default:
                break
        }
    }
}

// let user = User(name: "Ashiq", phoneNumber: "7339278868")
//let user: User? = nil

// user.userInitialChoices()

// --------------------


//let book = BookMyMovie(noOfSeats: 3, theatreId: 1, movieId: 1, user: user)

// To book a ticket
// book.bookTicket()

//print("\n***********\n")

// To view registered user
// book.registredUser?.showUser()

// show all movies available in the theatre
//book.details.theatres[0].showAllMovies()

// add a new movie in the theatre
//book.details.theatres[0].addMovie()

// remove a movie by using movie id
//book.details.theatres[0].removeMovie(item: 2)

// show all theatre
//let detail = Details()
//detail.showAllTheatre()
