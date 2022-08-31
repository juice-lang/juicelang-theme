# frozen_string_literal: true

require 'jekyll'
require 'liquid'

module Jekyll
    module CustomFilters
        def is_active?(pageHash, children = nil)
            page = pageFromHash(pageHash)
            return true if page.equal? currentPage

            isActiveRecursion? children
        end

        def find(input, property, targetValue = nil)
            first(where(input, property, targetValue))
        end

        def previous_and_next(pageHash, nav)
            result = {'previous' => nil, 'next' => nil}
            page = pageFromHash(pageHash)

            indexPage = pageFromHash(nav, 'index_path')

            if page.equal? indexPage
                result['next'] = pageFromHash(nav['menu'].first)
                return result
            end

            flattenedMenu = flattenMenu(nav['menu'])

            for i in 0...flattenedMenu.count
                pageI = flattenedMenu[i]

                if page.equal? pageI
                    result['previous'] = i == 0 ? indexPage : flattenedMenu[i - 1]
                    result['next'] = flattenedMenu[i + 1] unless i == flattenedMenu.count - 1
                    return result
                end
            end

            result
        end

        def url_without_ext(pageHash)
            page = pageFromHash(pageHash)
            url = absolute_url(page.url)

            return url.sub /\.x?html?$/, ''
        end


        private

        include Liquid::StandardFilters
        include Jekyll::Filters::URLFilters

        def currentPage
            pageFromHash(@context.registers[:page])
        end

        def site
            @context.registers[:site]
        end

        def pageFromHash(hash, pathKey = 'path')
            site.pages.find { |page|
                page.path == hash[pathKey]
            } unless hash.nil?
        end

        def isActiveRecursion?(children)
            children && children.any? { |item|
                pageFromHash(item).equal?(currentPage) || isActiveRecursion?(item['children'])
            }
        end

        def flattenMenu(menu)
            result = []

            for item in menu
                result.push(pageFromHash(item))
                if item['children']
                    result.concat(flattenMenu(item['children']))
                end
            end

            result
        end
    end
end

Liquid::Template.register_filter(Jekyll::CustomFilters)
