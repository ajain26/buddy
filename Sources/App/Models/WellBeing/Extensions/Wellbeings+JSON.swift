extension WellBeing.JSONKeys {
    static let latestWellbeing = "latestWellBeing"
}

extension WellBeing {
    func makeCustomJSON() throws -> JSON {
        var json = try makeJSON()

        try json.set(WellBeing.createdAtKey, createdAt)

        return json
    }
}
