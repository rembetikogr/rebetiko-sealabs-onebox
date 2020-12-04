# frozen_string_literal: true

# name: SealabsOnebox
# about: Load onebox previews for rebetiko.sealabs.net
# version: 0.1
# authors: chrispanag
# url: https://github.com/chrispanag

register_asset 'stylesheets/common/sealabs-onebox.scss'
# register_asset 'stylesheets/desktop/sealabs-onebox.scss', :desktop
# register_asset 'stylesheets/mobile/sealabs-onebox.scss', :mobile

PLUGIN_NAME ||= "SealabsOnebox"

# load File.expand_path('lib/sealabs-onebox/engine.rb', __dir__)

Onebox = Onebox

module Onebox
  module Engine
    class RebetikoSealabsOnebox
      include Engine
      include JSON
      include HTML
      matches_regexp(/^(https?:\/\/)?rebetiko.sealabs.net\/display.php\?(.*)recid=(.*)/)

      def to_html
        item = fetcher[:data][0]
        etiketa = extractEtiketa(item[:etiketa])
        etos = extractEtos(item[:etosixog])
        <<-HTML
          <aside class="onebox rebetikosealabs">
            <header class="source">
              <a href="#{item[:"0"]}" target="_blank">rebetiko.sealabs.net – Βάση Δεδομένων</a>
            </header>
            <article class="onebox-body">
              #{ etiketa ? 
                <<-HTML
                <img src="#{etiketa}" class="thumbnail"/> 
                HTML
                : nil
              }
              <a href="#{item[:"0"]}" target="_blank"><h3>#{item[:name]}#{etos ? " – " + etos : nil}</h3></a>
              <div class=subtitle>#{extractMousiki(item[:mousiki])}</div>
              <p>#{item[:info]}</p>
              <p>
                <span class="label1">💿 #{item[:ar_mitras] != "" ? " Αρ. Μήτρας: " + item[:ar_mitras] + " " : nil}#{item[:ardiskou] != "" ? "Αρ. Δίσκου: " + item[:ardiskou] : nil}</span>
                <span class="label2">#{item[:duration] != "" ? "Διάρκεια: " + item[:duration] + " ⏱": nil}</span>
              </p>
            </article>
            <div class="onebox-metadata">
            </div>
            <div style="clear: both"></div>
          </aside>
        HTML
        # rescue
        #   @url
      end

      def fetcher
        uri = URI("https://rebetiko.sealabs.net/server_processing.php")
        match = @url.match(/recid=(\d+)&?.*$/)
        id = match[1]
        res = Net::HTTP.post_form(uri, {
          "columns[0][data]" => "listsequence",
          "columns[0][name]" => "",
          "columns[0][searchable]" => "true",
          "columns[0][orderable]" => "false",
          "columns[0][search][value]" => "",
          "columns[0][search][regex]" => "false",
          "columns[1][data]" => "titlos",
          "columns[1][name]" => "",
          "columns[1][searchable]" => "true",
          "columns[1][orderable]" => "true",
          "columns[1][search][value]" => "",
          "columns[1][search][regex]" => "false",
          "columns[2][data]" => "mousiki",
          "columns[2][name]" => "",
          "columns[2][searchable]" => "true",
          "columns[2][orderable]" => "true",
          "columns[2][search][value]" => "",
          "columns[2][search][regex]" => "false",
          "columns[3][data]" => "tragoudistis",
          "columns[3][name]" => "",
          "columns[3][searchable]" => "true",
          "columns[3][orderable]" => "true",
          "columns[3][search][value]" => "",
          "columns[3][search][regex]" => "false",
          "columns[4][data]" => "etosixog",
          "columns[4][name]" => "",
          "columns[4][searchable]" => "true",
          "columns[4][orderable]" => "true",
          "columns[4][search][value]" => "",
          "columns[4][search][regex]" => "false",
          "columns[5][data]" => "info",
          "columns[5][name]" => "",
          "columns[5][searchable]" => "true",
          "columns[5][orderable]" => "true",
          "columns[5][search][value]" => "",
          "columns[5][search][regex]" => "false",
          "columns[6][data]" => "mitradiskos",
          "columns[6][name]" => "",
          "columns[6][searchable]" => "true",
          "columns[6][orderable]" => "true",
          "columns[6][search][value]" => "",
          "columns[6][search][regex]" => "false",
          "columns[7][data]" => "pros8iki",
          "columns[7][name]" => "",
          "columns[7][searchable]" => "true",
          "columns[7][orderable]" => "true",
          "columns[7][search][value]" => "",
          "columns[7][search][regex]" => "false",
          "columns[8][data]" => "pros8eta",
          "columns[8][name]" => "",
          "columns[8][searchable]" => "true",
          "columns[8][orderable]" => "true",
          "columns[8][search][value]" => "",
          "columns[8][search][regex]" => "false",
          "order[0][column]" => "0",
          "order[0][dir]" => "asc",
          "start" => "0",
          "length" => "10",
          "search[value]" => "",
          "search[regex]" => "false",
          "compos_query" => "",
          "searchstring" => "",
          "recid" => id,
          "date_span" => "",
          "composer" => "",
          "singer" => "",
          "artist" => ""
        })
        body = ::MultiJson.load(res.body, symbolize_keys: true)
        @fetcher = body
      end

      def extractEtiketa(etiketa)
        match = etiketa.match(/src='(.*)'/)
        if (match && match.length > 1)
          if (match[1] != "/app.php/gallery/image//source")
            return "https://rebetiko.sealabs.net/" + match[1]
          end
        end

        nil
      end

      def extractMousiki(mousiki)
        splitted = mousiki.split("<br>")
        splitted = splitted[0][0..-5].split(">")
        splitted[splitted.length - 1]
      end

      def extractEtos(etos)
        splitted = etos[0..-5].split(">")
        etos = splitted[splitted.length - 1]
        if (etos != "0")
          return etos
        end
        nil
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
