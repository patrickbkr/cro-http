use Cro::HTTP::RequestParser;
use Cro::HTTP::ResponseSerializer;
use Cro;

class ParserExtension does Cro::Transform {
    has $.body-parsers;
    has $.add-body-parsers;

    method consumes() { ... }
    method produces() { ... }

    method transformer(Supply $pipeline --> Supply) {
        "crolog".IO.spurt: "Setting up parserExtension transformer with: " ~ $pipeline.WHICH ~ "\n", :append;
        supply {
            "crolog".IO.spurt: "ParserExtension Supply is set up with (was tapped): " ~ $pipeline.WHICH ~ "\n", :append;
            whenever $pipeline -> $message {
                if $.body-parsers.defined {
                    $message.body-parser-selector = Cro::BodyParserSelector::List.new(parsers => @$.body-parsers);
                }
                if $.add-body-parsers.defined {
                    $message.body-parser-selector = Cro::BodyParserSelector::Prepend.new(parsers => @$.add-body-parsers,
                                                                                               next => $message.body-parser-selector);
                }
                emit $message;
            }
        }
    }
}

class SerializerExtension does Cro::Transform {
    has $.body-serializers;
    has $.add-body-serializers;

    method consumes() { ... }
    method produces() { ... }

    method transformer(Supply $pipeline --> Supply) {
        "crolog".IO.spurt: "Setting up SerializerExtension transformer with: " ~ $pipeline.WHICH ~ "\n", :append;
        supply {
            "crolog".IO.spurt: "SerializerExtension tapped: " ~ $pipeline.WHICH ~ "\n", :append;
            whenever $pipeline -> $message {
                "crolog".IO.spurt: "SerializerExtension processing: " ~ $message.WHICH ~ "\n", :append;

                if $.body-serializers.defined {
                    $message.body-serializer-selector = Cro::BodySerializerSelector::List.new(serializers => @$.body-serializers);
                }
                if $.add-body-serializers.defined {
                    $message.body-serializer-selector = Cro::BodySerializerSelector::Prepend.new(serializers => @$.add-body-serializers,
                                                                                                       next => $message.body-serializer-selector);
                }
                emit $message;
            }
        }
    }
}
