//
//  SemanticType.swift
//  
//
//  Created by Atai Barkai on 8/2/19.
//

// A very thin, easily-verifiable core for `SemanticType`,
// exposing a single, maximally-typed (`Result`-returning) factory method.
@dynamicMemberLookup
public struct SemanticType<Spec: GeneralizedSemanticTypeSpec> {
    
    public typealias Spec = Spec
    
    /// The (stored) `GatewayOutput` value backing this instance of `SemanticType`.
    /// Guarenteed to have been outputted by `Spec.gateway` for some given input.
    ///
    ///
    /// This stored property is declared `private` to prevent any creation/initialization of a `SemanticType` instance other than
    /// through the creation path explicitly exposed by this file (namely, the [create](x-source-tag://create) factory method).
    ///
    /// Furthermore, since this property is the *only* property stored on instances of `SemanticType`,
    /// and since it is stored as a constant (i.e. as a `let`), the data underlying a `SemanticType` instance
    /// can in no way be modified post-initialization.
    /// This makes it easy to verify that `SemanticType` respects the `Spec.gateway` function
    /// by examining the code in this file *in isolation from code in any other file*:
    /// as long as we make sure this property is always assigned a post-`Spec.gateway` value
    /// *in the context of this file*, we can be sure that it is assigned a post-`Spec.gateway` value
    /// under *all* circumstances.
    private let gatewayOutput: Spec.GatewayOutput
    
    /// A proxy internally exposing the backingPrimitive portion of the `gatewayOutput` property to other files in this package.
    ///
    /// We define it as an underscore-prefixed, internal variable so that we can define a corresponding
    /// variable which has a setter under some conditional extensions, and a getter under others.
    public var _backingPrimitive: Spec.BackingPrimitiveWithValueSemantics {
        gatewayOutput.backingPrimitvie
    }
    
    public var gatewayMetadata: Spec.GatewayMetadataWithValueSemantics {
        gatewayOutput.metadata
    }
    
    // MARK: init / factories
    /// An unsafe initializer intended to be used only from within the [create](x-source-tag://create) factory method.
    ///
    /// This initializer **does not** make sure that the `Spec.gatemapMap` function is being respected.
    /// Thus, the *caller* must be sure to call this initializer with a value outputted by the `Spec.gatemapMap` function.
    /// - Parameter _unsafeDirectlyAssignedBackingPrimitive: The `Spec.BackingPrimitive` object directly assigned to self.
    ///                                                      Must have been the output of a `Spec.gateway` call.
    private init(_unsafeDirectlyAssignedBackingPrimitive: Spec.GatewayOutput) {
        self.gatewayOutput = _unsafeDirectlyAssignedBackingPrimitive
    }
    
    /// The only way to create an instance of `SemanticType`.
    /// An obtained `SemanticType` is guarenteed to respect its `Spec.gateway` function, in that
    /// its backing primitive is guarenteed to have been the output of a call to `Spec.gateway`.
    ///
    /// - Parameter preMap: The value to be passed through the `Spec.gatemapMap` function.
    ///
    /// - Returns: A `SemanticType` instance wrapping the `.success` output of the `Sepc.gateway` function,
    ///            or otherwise, the error captured by a `.failure` output of the `Sepc.gateway` function.
    ///
    /// - Tag: create
    public static func create(_ preMap: Spec.BackingPrimitiveWithValueSemantics) -> Result<Self, Spec.Error> {
        return Spec
            .gateway(preMap: preMap)
            .map(Self.init(_unsafeDirectlyAssignedBackingPrimitive:))
    }
}

