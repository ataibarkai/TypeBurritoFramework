/// A marker protocol.
/// If a `SemanticTypeSpec` conforms to this protocol, its associated `SemanticType`
/// will conform to `Numeric`.
/// 
/// `Numeric` support may not make sense for all
/// `SemanticType`s associated with a `Numeric` `RawValue`
/// (for instance, [`Second` * `Second` = `Second`] does not make semantic sense).
/// Nevertheless, we *can* provide an implementation in all such cases.
///
/// We allow the `Spec` backing the `SemanticType` to signal whether `Numeric`
/// support should be provided by conforming to the `ShouldBeNumeric` marker protocol.
/// - Tag: ShouldBeNumeric
public protocol ShouldBeNumeric: MetaValidatedSemanticTypeSpec
    where
    RawValue: Numeric { }

extension SemanticType: Numeric
    where
    Spec: ShouldBeNumeric,
    Spec.Error == Never
{
    public typealias Magnitude = Spec.RawValue.Magnitude

    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let inside = Spec.RawValue.init(exactly: source)
            else { return nil }
        
        self.init(inside)
    }
    
    public var magnitude: Spec.RawValue.Magnitude {
        rawValue.magnitude
    }
    
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue * rhs.rawValue)
    }
    
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs.rawValue *= rhs.rawValue
    }
}


extension SemanticType: SignedNumeric
    where
    Spec: ShouldBeNumeric,
    Spec.RawValue: SignedNumeric,
    Spec.Error == Never
{ }

