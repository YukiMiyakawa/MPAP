class TagsController < ApplicationController
  def index
    @tag_list= Tag.all.limit(6).sort {|a,b| b.post_tags.size <=> a.post_tags.size}
  end
end
