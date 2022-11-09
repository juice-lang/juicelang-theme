# frozen_string_literal: true

require 'jekyll'
require 'rouge'

Jekyll::Hooks.register :site, :pre_render do |site|
    require "rouge"

    class JuiceLexer < Rouge::RegexLexer
        title 'Juice'
        desc 'Extended Backus-Naur Form'
        mimetypes 'text/x-juice'
        tag 'juice'
        filenames '*.juice'

        state :root do
            mixin :whitespace
            mixin :keyword
            mixin :operator
            mixin :punctuation
            mixin :identifier
            mixin :literal
        end

        state :whitespace do
            rule %r/[\x20\x0A\x0D\x09\x0B\x0C\x00]+/, Text::Whitespace
            rule %r(//.*\n), Comment::Single
            rule %r(/\*), Comment::Multiline, :multiline_comment
        end

        state :multiline_comment do
            rule %r/(?:[^\*\/]|\*(?!\/)|\/(?!\*))+/, Comment::Multiline

            rule %r(/\*), Comment::Multiline, :multiline_comment
            rule %r(\*/), Comment::Multiline, :pop!
        end

        state :keyword do
            rule %r/binary|enum|extension|func|import|init|internal|let|module|operator|private|precedencegroup|public|static|struct|subscript|throws|trait|type|typeprivate|var/, Keyword::Declaration
            rule %r/break|case|catch|continue|default|defer|do|else|fallthrough|for|guard|if|in|loop|match|return|throw|where|while/, Keyword
            rule %r/as|case|is|self|try/, Keyword
            rule %r/any|some|throws|_/, Keyword::Type
            rule %r/_/, Keyword
            rule %r/above|associativity|below|binary|didSet|get|indirect|left|none|postfix|prefix|right|set|Type|value|willSet/, Keyword
        end

        state :operator do
            rule %r/[+\-\*\/%<>=&\|\^!\?~]+/, Operator
            rule %r/\.[+\-\*\/%<>=&\|\^!\?~\.]+/, Operator
        end

        state :punctuation do
            rule %r/\(|\)|\[|\]|\{|\}|\.|,|:|;|=|&|->|=>|`|\?|!/, Punctuation
        end

        state :identifier do
            rule %r/[_A-Za-z][_A-Za-z0-9]*/, Name
            rule %r/`[_A-Za-z][_A-Za-z0-9]*`/, Name
        end

        state :literal do
            rule %r/true|false|nil/, Keyword::Constant
            rule %r/'/, Str::Delimiter, :character_literal

            rule %r/(#*)"""/ do |m|
                token Str::Delimiter
                @multiline = true
                @rawLevel = m[1].length
                push :string_literal
            end

            rule %r/(#*)"/ do |m|
                token Str::Delimiter
                @multiline = false
                @rawLevel = m[1].length
                push :string_literal
            end

            rule %r/[0-9][0-9_]*(?:\.[0-9][0-9_]*(?:[eE][+-]?[0-9][0-9_]*)?|[eE][+-]?[0-9][0-9_]*)/, Num::Float
            rule %r/[0-9][0-9_]*/, Num::Integer
            rule %r/0b[01][01_]*/, Num::Bin
            rule %r/0o[0-7][0-7_]*/, Num::Oct
            rule %r/0x[0-9a-fA-F][0-9a-fA-F_]*/, Num::Hex
        end

        state :character_literal do
            rule %r/[^\\']/ do
                token Str::Char
                goto :character_literal_ending
            end

            rule %r/\\/ do
                token Str::Escape
                goto :character_literal_ending
                push :escape
            end
        end

        state :character_literal_ending do
            rule %r/'/, Str::Delimiter, :pop!
        end

        state :string_literal do
            rule %r/[^\\"\$]+/, Str
            rule %r/"""/ do
                if @multiline
                    if @rawLevel > 0
                        @delimiter = '"""'
                        @currentRawLevel = @rawLevel
                        goto :raw_string_literal_ending
                    else
                        token Str::Delimiter
                        pop!
                    end
                else
                    token Error
                    pop!
                end
            end

            rule %r/"/ do
                if !@multiline
                    if @rawLevel > 0
                        @delimiter = '"'
                        @currentRawLevel = @rawLevel
                        goto :raw_string_literal_ending
                    else
                        token Str::Delimiter
                        pop!
                    end
                else
                    token Str
                end
            end

            rule %r/\\?\n/ do
                if @multiline
                    token Str
                else
                    token Error
                    pop!
                end
            end

            rule %r/(\\)(#*)/ do |m|
                if m[2].length < @rawLevel
                    token Str
                elsif m[2].length == @rawLevel
                    token Str::Escape
                    push :escape
                else
                    token Error
                end
            end

            rule %r/\$\{/, Str::Interpol, :interpolation
        end

        state :raw_string_literal_ending do
            rule %r/#/ do
                @delimiter += '#'

                if @currentRawLevel > 1
                    @currentRawLevel -= 1
                else
                    token Str::Delimiter, @delimiter
                    pop!
                end
            end

            rule %r/[^#]/ do
                token Str, @delimiter
                token Str
                goto :string_literal
            end

            rule %r/\n/ do
                if @multiline
                    token Str, @delimiter
                    token Str
                    goto :string_literal
                else
                    token Error
                    pop!
                end
            end
        end

        state :interpolation do # TODO
            rule %r/[^\{\}]+/, Str::Interpol
            rule %r/\{/, Str::Interpol, :interpolation
            rule %r/\}/, Str::Interpol, :pop!
        end

        state :escape do
            rule %r/0|\\|t|n|r|"|'|\$/, Str::Escape, :pop!
            rule %r/u\{[0-9a-fA-F]{1,8}\}/, Str::Escape, :pop!
        end
    end
end
