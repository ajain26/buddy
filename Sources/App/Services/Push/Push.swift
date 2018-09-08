import UAPusher
import Vapor

final class Push {
    let uapusher: UAManager?

    init(_ uapusher: UAManager?) {
        self.uapusher = uapusher
    }

    func send(message: String, to userId: Int) throws {

        guard let uapusher = uapusher else {
            throw Abort(.internalServerError, reason: "UA is not registered")
        }

        let payload = try UABuilder()
            .add(Audience(.namedUser(value: String(userId))))
            .add(DeviceTypes(.android))
            .add(Notification(.alert(value: message)))
            .payload()

        let request = UARequest(body: payload)
        let _ = try uapusher.send(request: request)
    }
}
