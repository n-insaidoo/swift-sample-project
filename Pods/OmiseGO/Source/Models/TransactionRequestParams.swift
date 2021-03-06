//
//  TransactionRequestParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 5/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to generate a transaction request
public struct TransactionRequestCreateParams {

    /// The type of transaction to be generated (send of receive)
    public let type: TransactionRequestType
    /// The unique identifier of the minted token to use for the request
    /// In the case of a type "send", this will be the token taken from the requester
    /// In the case of a type "receive" this will be the token received by the requester
    public let mintedTokenId: String
    /// The amount of minted token to use for the transaction (down to subunit to unit)
    /// This amount needs to be either specified by the requester or the consumer
    public let amount: Double?
    /// The address from which to send or receive the minted tokens
    /// If not specified, will use the primary address by default
    public let address: String?
    /// An id that can uniquely identify a transaction. Typically an order id from a provider.
    public let correlationId: String?
    /// A boolean indicating if the request needs a confirmation from the requester before being proceeded
    public let requireConfirmation: Bool
    /// The maximum number of time that this request can be consumed
    public let maxConsumptions: Int?
    /// The amount of time in millisecond during which a consumption is valid
    public let consumptionLifetime: Int?
    /// The date when the request will expire and not be consumable anymore
    public let expirationDate: Date?
    /// Allow or not the consumer to override the amount specified in the request
    /// This needs to be true if the amount is not specified
    public let allowAmountOverride: Bool
    /// Additional metadata embedded with the request
    public let metadata: [String: Any]
    /// Additional encrypted metadata embedded with the request
    public let encryptedMetadata: [String: Any]

    /// Initialize the params used to generate a transaction request.
    /// Returns nil if allowAmountOverride is false and amount is nil
    ///
    /// - Parameters:
    ///   - type: The type of transaction to be generated (send of receive)
    ///   - mintedTokenId: The unique identifier of the minted token to use for the request
    ///                    In the case of a type "send", this will be the token taken from the requester
    ///                    In the case of a type "receive" this will be the token received by the requester
    ///   - amount: The amount of minted token to use for the transaction (down to subunit to unit)
    ///             This amount needs to be either specified by the requester or the consumer
    ///   - address: The address from which to send or receive the minted tokens
    ///              If not specified, will use the primary address by default
    ///   - correlationId: An id that can uniquely identify a transaction. Typically an order id from a provider.
    ///   - requireConfirmation: A boolean indicating if the request needs a confirmation from the requester before being proceeded
    ///   - maxConsumptions: The maximum number of time that this request can be consumed
    ///   - consumptionLifetime: The amount of time in milisecond during which a consumption is valid
    ///   - expirationDate: The date when the request will expire and not be consumable anymore
    ///   - allowAmountOverride: Allow or not the consumer to override the amount specified in the request
    ///                          This needs to be true if the amount is not specified
    ///   - metadata: Additional metadata embeded with the request
    public init?(type: TransactionRequestType,
                 mintedTokenId: String,
                 amount: Double?,
                 address: String?,
                 correlationId: String?,
                 requireConfirmation: Bool,
                 maxConsumptions: Int?,
                 consumptionLifetime: Int?,
                 expirationDate: Date?,
                 allowAmountOverride: Bool,
                 metadata: [String: Any] = [:],
                 encryptedMetadata: [String: Any] = [:]) {
        guard allowAmountOverride || amount != nil else { return nil }
        self.type = type
        self.mintedTokenId = mintedTokenId
        self.amount = amount
        self.address = address
        self.correlationId = correlationId
        self.requireConfirmation = requireConfirmation
        self.maxConsumptions = maxConsumptions
        self.consumptionLifetime = consumptionLifetime
        self.expirationDate = expirationDate
        self.allowAmountOverride = allowAmountOverride
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
    }

}

extension TransactionRequestCreateParams: Parametrable {

    private enum CodingKeys: String, CodingKey {
        case type
        case mintedTokenId = "token_id"
        case amount
        case address
        case correlationId = "correlation_id"
        case requireConfirmation = "require_confirmation"
        case maxConsumptions = "max_consumptions"
        case consumptionLifetime = "consumption_lifetime"
        case expirationDate = "expiration_date"
        case allowAmountOverride = "allow_amount_override"
        case metadata
        case encryptedMetadata = "encrypted_metadata"
    }

    // Custom encoding as we need to encode amount event if nil
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(mintedTokenId, forKey: .mintedTokenId)
        try container.encode(amount, forKey: .amount)
        try container.encode(address, forKey: .address)
        try container.encode(correlationId, forKey: .correlationId)
        try container.encode(requireConfirmation, forKey: .requireConfirmation)
        try container.encode(maxConsumptions, forKey: .maxConsumptions)
        try container.encode(consumptionLifetime, forKey: .consumptionLifetime)
        try container.encode(expirationDate, forKey: .expirationDate)
        try container.encode(allowAmountOverride, forKey: .allowAmountOverride)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(encryptedMetadata, forKey: .encryptedMetadata)
    }

}

/// Represents a structure used to retrieve a transaction request from its id
struct TransactionRequestGetParams: Parametrable {

    let id: String

}
