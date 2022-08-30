Jekyll::Hooks.register :site, :pre_render do |site|
    require "rouge"

    class JuiceLexer < Rouge::RegexLexer
        title 'Juice'
        desc 'Extended Backus-Naur Form'
        mimetypes 'text/x-juice'
        tag 'juice'
        filenames '*.juice'

        state :root do
            rule %r/./m, Text
        end
    end
end
