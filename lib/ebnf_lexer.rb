# frozen_string_literal: true

require 'jekyll'
require 'rouge'

Jekyll::Hooks.register :site, :pre_render do |site|
    require "rouge"

    class EBNFLexer < Rouge::RegexLexer
        title 'EBNF'
        desc 'Extended Backus-Naur Form'
        mimetypes 'text/x-ebnf'
        tag 'ebnf'
        filenames '*.ebnf'

        state :whitespace do
            rule %r/[\s\n]+/, Text
            mixin :comment
        end

        state :comment do
            rule %r/\(\*/, Comment::Multiline, :in_comment
        end

        state :in_comment do
            rule %r/\*\)/, Comment::Multiline, :pop!
            rule %r/[^*)]+/m, Comment::Multiline
            rule %r/./, Comment::Multiline
        end

        state :root do
            mixin :whitespace

            rule %r/([A-Za-z][A-Za-z0-9_-]*)(\s*)(=)/ do
                groups Name::Constant, Text, Punctuation

                push :rhs; push :expecting_symbol
            end
        end

        state :rhs do
            mixin :whitespace
            mixin :concat

            rule %r/;/, Punctuation, :pop!
        end

        state :grouped_rhs do
            mixin :whitespace
            mixin :concat

            rule(%r/\)/) { token Punctuation; pop! 2 }
        end

        state :optional_rhs do
            mixin :whitespace
            mixin :concat

            rule(%r/\]/) { token Punctuation; pop! 2 }
        end

        state :repeating_rhs do
            mixin :whitespace
            mixin :concat

            rule(%r/\}/) { token Punctuation; pop! 2 }
        end

        state :expecting_symbol do
            mixin :whitespace

            rule %r/\(/ do
                token Punctuation
                push :grouped_rhs; push :expecting_symbol
            end

            rule %r/\[/ do
                token Punctuation
                push :optional_rhs; push :expecting_symbol
            end

            rule %r/\{/ do
                token Punctuation
                push :repeating_rhs; push :expecting_symbol
            end

            rule %r/"[^"]+"/, Str, :pop!
            rule %r/'[^']+'/, Str, :pop!
            rule %r/\?[^?]+\?/, Comment::Preproc, :pop!
            rule %r/[A-Za-z][A-Za-z0-9_-]*/, Name::Function, :pop!

            rule %r/(0|[1-9][0-9]*)(\s*)(\*)/ do
                groups Literal::Number, Text, Operator
            end
        end

        state :concat do
            rule %r/[,|]/, Punctuation, :expecting_symbol
        end
    end
end
