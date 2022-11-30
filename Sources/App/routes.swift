import Vapor

func routes(_ app: Application) throws {
  app.get { req async in
    "It works!"
  }

  // Creating a new Route without a parameter
  app.get("name") { req async -> String in
    let namesArray = ["John", "Philip", "Samson", "Mark", "Helen", "Henry"]
    return "Hello, \(namesArray[0]) and \(namesArray[3])"
  }

  // Creating a Route with a Parameter
  app.get("hello", ":name") { req -> String in
    guard let name = req.parameters.get("name") else {
      throw Abort(.internalServerError)
    }
    return "Hello, \(name)!"
  }

  // Returning a JSON value
  app.get("json") { req -> DataCollection in
    let dataArr: [IndividualData] = [
      IndividualData(name: "John", age: 30), IndividualData(name: "Philips", age: 35),
      IndividualData(name: "Samson", age: 45), IndividualData(name: "Mark", age: 52),
      IndividualData(name: "Helen", age: 25), IndividualData(name: "Henry", age: 85),
    ]

    let dataObject = DataCollection(status: 201, data: dataArr)

    return dataObject

  }

  // Handling a Post Request
  app.post("gender-group") { req -> DataCollection in
    let dataKind = try req.content.decode(DataKind.self)

    if dataKind.gender == "males" || dataKind.gender == "females" {
      return getDataArr(gender: dataKind.gender)
    } else {
      return DataCollection(status: 400, data: [])
    }
  }

}

func getDataArr(gender: String) -> DataCollection {
  // men and women data group arrays in database
  let menData: [IndividualData] = [
    IndividualData(name: "John", age: 30), IndividualData(name: "Philips", age: 35),
    IndividualData(name: "Samson", age: 45), IndividualData(name: "Mark", age: 52),
    IndividualData(name: "Henry", age: 85),
  ]

  let womenData: [IndividualData] = [
    IndividualData(name: "Gloria", age: 56), IndividualData(name: "Victoria", age: 78),
    IndividualData(name: "Lizzy", age: 45), IndividualData(name: "Juliet", age: 78),
    IndividualData(name: "Helen", age: 25),
  ]

  // fetch operation from database
  var data = menData
  if gender == "females" {
    data = womenData
  } else {
    data = menData
  }

  let dataCollected = DataCollection(status: 201, data: data)

  return dataCollected
}

struct DataCollection: Content {
  let status: Int
  let data: [IndividualData]
}
struct IndividualData: Content {
  let name: String
  let age: Int
}

struct DataKind: Content {
  let gender: String
}
