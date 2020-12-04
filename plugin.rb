# frozen_string_literal: true

# name: SealabsOnebox
# about: Load onebox previews for rebetiko.sealabs.net
# version: 0.1
# authors: chrispanag
# url: https://github.com/chrispanag

# register_asset 'stylesheets/common/sealabs-onebox.scss'
# register_asset 'stylesheets/desktop/sealabs-onebox.scss', :desktop
# register_asset 'stylesheets/mobile/sealabs-onebox.scss', :mobile

PLUGIN_NAME ||= 'SealabsOnebox'

# load File.expand_path('lib/sealabs-onebox/engine.rb', __dir__)

Onebox = Onebox

module Onebox
  module Engine
    class RebetikoSealabsOnebox
      include Engine
      include JSON
      include HTML
      matches_regexp(/^(https?:\/\/)?rebetiko.sealabs.net\/display.php\?(.*)recid=(.*)/)

      # def url
      #   "https://en.wikipedia.org/w/api.php?action=query&titles=#{match[:name]}&prop=imageinfo&iilimit=50&iiprop=timestamp|user|url&iiurlwidth=500&format=json"
      # end

      def to_html
        item = fetcher[:data][0]
        <<-HTML
        <aside class="onebox rebetikosealabs">
          <header class="source">
            <a href="#{item[:"0"]}" target="_blank">rebetiko.sealabs.net</a>
          </header>
          <article class="onebox-body">
            <a href="#{item[:"0"]}" target="_blank"><h3>#{item[:name]}</h3></a>
            <p>#{item[:info]}</p>
          </article>
          <div class="onebox-metadata">
            <p>
              #{item[:ar_mitras] != "" ? "<b>Αρ. Μήτρας:</b> " + item[:ar_mitras] + ", " : nil}#{item[:ardiskou] != "" ? "<b>Αρ. Δίσκου:</b> " + item[:ardiskou] + ", " : nil}#{item[:duration] != "" ? "<b>Διάρκεια:</b> " + item[:duration] : nil}
            </p>
          </div>
          <div style="clear: both"></div>
        </aside>
        HTML
      end

      def fetcher
        uri = URI("https://rebetiko.sealabs.net/server_processing.php")
        match = @url.match(/recid=(\d+)&?.*$/)
        id = match[1]
        res = Net::HTTP.post_form(uri, { 
          'columns[0][data]' => 'listsequence',
          'columns[0][name]' => '',
          'columns[0][searchable]' => 'true',
          'columns[0][orderable]' => 'false',
          'columns[0][search][value]' => '',
          'columns[0][search][regex]' => 'false',
          'columns[1][data]' => 'titlos',
          'columns[1][name]' => '',
          'columns[1][searchable]' => 'true',
          'columns[1][orderable]' => 'true',
          'columns[1][search][value]' => '',
          'columns[1][search][regex]' => 'false',
          'columns[2][data]' => 'mousiki',
          'columns[2][name]' => '',
          'columns[2][searchable]' => 'true',
          'columns[2][orderable]' => 'true',
          'columns[2][search][value]' => '',
          'columns[2][search][regex]' => 'false',
          'columns[3][data]' => 'tragoudistis',
          'columns[3][name]' => '',
          'columns[3][searchable]' => 'true',
          'columns[3][orderable]' => 'true',
          'columns[3][search][value]' => '',
          'columns[3][search][regex]' => 'false',
          'columns[4][data]' => 'etosixog',
          'columns[4][name]' => '',
          'columns[4][searchable]' => 'true',
          'columns[4][orderable]' => 'true',
          'columns[4][search][value]' => '',
          'columns[4][search][regex]' => 'false',
          'columns[5][data]' => 'info',
          'columns[5][name]' => '',
          'columns[5][searchable]' => 'true',
          'columns[5][orderable]' => 'true',
          'columns[5][search][value]' => '',
          'columns[5][search][regex]' => 'false',
          'columns[6][data]' => 'mitradiskos',
          'columns[6][name]' => '',
          'columns[6][searchable]' => 'true',
          'columns[6][orderable]' => 'true',
          'columns[6][search][value]' => '',
          'columns[6][search][regex]' => 'false',
          'columns[7][data]' => 'pros8iki',
          'columns[7][name]' => '',
          'columns[7][searchable]' => 'true',
          'columns[7][orderable]' => 'true',
          'columns[7][search][value]' => '',
          'columns[7][search][regex]' => 'false',
          'columns[8][data]' => 'pros8eta',
          'columns[8][name]' => '',
          'columns[8][searchable]' => 'true',
          'columns[8][orderable]' => 'true',
          'columns[8][search][value]' => '',
          'columns[8][search][regex]' => 'false',
          'order[0][column]' => '0',
          'order[0][dir]' => 'asc',
          'start' => '0',
          'length' => '10',
          'search[value]' => '',
          'search[regex]' => 'false',
          'id_xristi' => '16780',
          'compos_query' => '',
          'searchstring' => '',
          'recid' => id,
          'date_span' => '',
          'composer' => '',
          'singer' => '',
          'artist' => ''
          })
          body = ::MultiJson.load(res.body, :symbolize_keys => true)
          @fetcher = body
      end

      # def placeholder_html
      #   "<div class=\"onebox\"><a href=\"" + @url + "\" ><div style='padding:10px;'><h1>Μαρίκα Παπαγκίκα</h1><h2>Test test </h2><p>" + fetcher + "</p></a></div>"
      # end

    end
  end
end

# after_initialize do
#   # https://github.com/discourse/discourse/blob/master/lib/plugin/instance.rb
# end

