require "ostruct"
require "delegate"

module PodcastIndex
  class Episode < SimpleDelegator
    class << self
      def find(id, fulltext: nil)
        response = Api::Episodes.by_id(id: id, fulltext: fulltext)
        from_response(response)
      end

      def find_by_feed_id(feed_id, since: nil, max: nil, fulltext: nil)
        response = Api::Episodes.by_feed_id(id: feed_id, since: since, max: max, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_by_feed_url(url, since: nil, max: nil, fulltext: nil)
        response = Api::Episodes.by_feed_url(url: url, since: since, max: max, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_by_podcast_guid(podcast_guid, since: nil, max: nil, fulltext: nil )
        response = Api::Episodes.by_podcast_guid(podcast_guid: podcast_guid, since: since, max: max, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_by_guid(guid, feedurl: nil, feedid: nil, fulltext: nil)
        response = Api::Episodes.by_guid(guid: guid, feedurl: feedurl, feedid: feedid, fulltext: fulltext)
        from_response(response)
      end

      def find_by_itunes_id(itunes_id, since: nil, max: nil, fulltext: nil)
        response = Api::Episodes.by_itunes_id(id: itunes_id, since: since, max: max, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_by_live_item(max: nil)
        response = Api::Episodes.live(max: max)
        from_response_collection(response)
      end

      def sample(max: nil, lang: nil, categories: [], exclude_categories: [], fulltext: nil)
        response = Api::Episodes.random(max: max, lang: lang, cat: categories.join(","),
                                        notcat: exclude_categories.join(","), fulltext: fulltext)
        from_response_collection(response, "episodes")
      end

      def find_by_person(person, fulltext: nil)
        response = Api::Search.by_person(person: person, fulltext: fulltext)
        from_response_collection(response)
      end

    private

      def from_response(response)
        feed = response["episode"].transform_keys(&:underscore)
        new(JSON.parse(feed.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
      end

      def from_response_collection(response, collection_key = "items")
        response[collection_key].map do |item|
          episode = item.transform_keys(&:underscore)
          new(JSON.parse(episode.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
        end
      end
    end
  end
end
